#!/bin/bash
# written in 11/02/2021
# by verzeletti at gmail dot com

####
# File Config Sample: /usr/share/thingsboard/conf/thingsboard.yml
  #address: "${HTTP_BIND_ADDRESS:0.0.0.0}"
  #port: "${HTTP_BIND_PORT:8080}"
  #enabled: "${SSL_ENABLED:true}"
  #key-store: "${SSL_KEY_STORE:classpath:keystore/agrotechlab.p12}"
  #key-store-password: "${SSL_KEY_STORE_PASSWORD:thingsboard-agrotech}"
  #key-store-type: "${SSL_KEY_STORE_TYPE:PKCS12}"
  #key-alias: "${SSL_KEY_ALIAS:thingsboard-tomcat}"


####
# LetsEncrypt to Thingsboard Certificate Format

# Variaveis
DATE=$(date +%Y-%m-%d)

# Criar backup do certificado anterior
echo ""
echo "Criando backup do certificado. . . "
mv /usr/share/thingsboard/conf/keystore/agrotechlab.p12 /usr/share/thingsboard/conf/keystore/agrotechlab.p12_$DATE

# Gerar certificado com senha e alias
echo ""
echo "Gerando certificado. . ."
openssl pkcs12 -export -out /usr/share/thingsboard/conf/keystore/agrotechlab.p12 -inkey /etc/letsencrypt/live/agrotechlab.lages.ifsc.edu.br/privkey.pem -in /etc/letsencrypt/live/agrotechlab.lages.ifsc.edu.br/cert.pem -certfile /etc/letsencrypt/live/agrotechlab.lages.ifsc.edu.br/chain.pem -name thingsboard-tomcat -password pass:thingsboard-agrotech

# Corrigir permissões
echo ""
echo "Corrigindo permissões. . ."
chown thingsboard:thingsboard /usr/share/thingsboard/conf/keystore/agrotechlab.p12

# Reiniciar serviço
echo ""
echo "Reiniciando serviço. . ."
systemctl restart thingsboard.service

# Monitorar LOG
echo ""
sleep 2
echo "Apresentando LOG. . ."
tail -f /var/log/thingsboard/thingsboard.log
