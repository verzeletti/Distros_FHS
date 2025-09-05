# Distros FHS (Filesystem Hierarchy Standard)

- Objetivo
  - Servir de guia para construção de nos servidores GNU/Linux.
  - Arquivos organizados de acordo com o FHS
  - Baseado em ditros Debian e Arch Linux
  - Aos poucos sendo modelados para uso genérico em qualquer distro

- Utilização
  - Fazer o download em ditros recém instaladas, como exemplo usando o "wget" e o formato RAW
  - Atualização em caso de novas versões
  - Melhor prática: associá-los a playbooks com ansible


## Freeradius
  1. A instalação do freeradius foi realizada no momento da instalação do servidor Samba-AD, conforme [projeto Samba-AD](https://git.ifsc.edu.br/ctic/cte/samba4/samba4-ad "Samba-AD IFSC") coordenado pelo Igor
  2. A informação da "Base DN" pode ser encontrada em "mods-enabled/ldap"
  3. Realize um snapshot do servidor antes de iniciar (sempre é bom lembrar:)
  4. Na árvore do Active Directory foi criada uma nova OU com o nome Campus_LAN (Ex. Urupema_LAN)
  5. No arquivo "/root/sincronia/conexoes.conf" foi criada uma excessão de sincronismo, adicionando a linha "OUS_IGNORADOS="Urupema_LAN"
  6. Recomendo a seguinte estrutura de OUs:
  > <img width="838" height="396" alt="samba-ad-ou" src="https://github.com/user-attachments/assets/f598ab6a-fa73-46b7-bea3-407d1b8f0ed9" />

  7. Ao realizar a implementação, recomenda-se ativar o modo debug, adicionando o parâmetro "-X" no arquivo "/etc/default/freeradius".
  8. O serviço pode ser reiniciado e monitorado pelo comando "systemctl restart freeradius.service ; tail -f /var/log/syslog", enquanto o modo debug estiver ativo
  9. Crie o diretório "/etc/ssl/IFSC/" e copie para ele os certificados emitidos para o campus ou para a wifi (Ex: wifi.ifsc.edu.br.crt  e wifi.ifsc.edu.br.key)
  10. Observe a estrutura da policy criada. Ela sugere um ID diferente para cada situação (ex: ID 120 para os "Domain Admins"), bem como a negação de acesso para um usuário no grupo "WIFI-Deny"

### Implementação
  1. Edite o arquivo "clients.conf" e personalize ele com os IPs do dispositivos que farão uso do radius (ex: switch, fortigate, etc) e uma senha exclusiva para cada. Ou, siga o exemplo e deixe "*" no "ipv4addr" para usar a mesma senha em vários dispositivos (não recomendado)
   
  2. Edite o arquivo "users" e comente as linhas relacionadas à atribuição de VLANs
   
3. Faça download do script "policy.d/vlan_ifsc" e altere os parâmetros das variáveis, logo no início, e os IDs de VLAN para cada caso testado pelo "if". Não esqueça de mudar o dono para "freerad" (ex: chown freerad:freerad policy.d/vlan_ifsc)
   
4. Edite o arquivo "mods-available/eap" e corrija os parâmetros "private_key_file" e "certificate_file"

5. Edite os arquivos "sites-available/default" e "sites-available/inner-tunnel" adicionado a opção "rewrite.vlan_ifsc" na seção "post-auth".

   > 5.1 Aqui um detalhe para ficar atento! Se quiser restringir o radius para autenticar somente a wifi, pode fazer uso do laço "&Called-Station-Id && &Called-Station-Id =~ /.*:IFSC" na seção "authorize". Seguir modelos já existentes. Recomendo deixar comentado para que se possa fazer uso da autenticação 802.1X também nos switchs e opção de teste de Usuário Radius através do FortiGate.
  
   > 5.2 O servidor está projetado para autenticar automaticamente computadores no domínio, desde que estejam dentra da "OU Wifi" e em seu respectivo local. Note que, cada OU (ex: ou=Administrativos,ou=Wifi,...) corresponde à um ID de VLAN. E, não será solicitado usuário e senha para o usuário!
 
  6. O uso de somente um SSID é recomendado e facilitará a vida de todo mundo (usuários e administradores de rede :)

   > 6.1 No fortiGate crie o SSID IFSC como "WPA3 Enterprise Transition", Optional VLAN ID = 0 e ative a opção "Dynamic VLAN assignment"
   
  7. Último detalhe, mais não menos importante: não esqueça de configurar os IDs de VLAN utilizados em todas as portas de switches que tem um Access Point conectado.
