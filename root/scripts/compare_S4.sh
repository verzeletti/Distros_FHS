#!/bin/bash
#
# Desc: rotina abaixo, que deverá ser agendada no CRON, verificará se houve alguma atualização do arquivo de sincronismo Samba3 --> Samba4, realizando a devida atualização.
# by "Glaidson Verzeletti" <verzeletti@gmail.com> - 12/03/2020 08h47 (First Version)
#
# Version - 20200316-rev0922
#
# Projeto de sincronismo Samba 3 --> Samba 4, disponível em: https://git.ifsc.edu.br/ctic/cte/samba4/samba4-ad/
# by "Igor Fernandes Kattar" <igor.kattar@ifsc.edu.br>
#

# Variaveis
FILE_ORG="/root/sincronia/sinc-S3LDAP-S4.sh"
FILE_NEW="/tmp/sinc-S3LDAP-S4.sh"
LOG="/var/log/sincronia_update"


# Registro de LOG
#exec > >(tee -a /var/log/sincronia) 2>&1


# Novo Script
/usr/bin/wget https://git.ifsc.edu.br/ctic/cte/samba4/samba4-ad/raw/master/sincronia/sinc-S3LDAP-S4.sh -O /tmp/sinc-S3LDAP-S4.sh


# Comparacao
if ! [ -s $FILE_NEW ];
then
        # echo "file not exist or is empty"
        { echo "$(date '+%d-%m-%Y %H:%M:%S') - Ocorreu um erro no download do script de sincronia" >> $LOG;exit 1; }
else
        # echo "files exist and is not empty"
        if [[ `diff $FILE_ORG $FILE_NEW` ]];
        then
                # echo "files different";
                { echo "$(date '+%d-%m-%Y %H:%M:%S') - Novo update do script de sincronia instalado" >> $LOG; mv -f $FILE_NEW $FILE_ORG && exit 1; }
        else
                # echo "files same"
                { rm -f $FILE_NEW && exit 1; }
        fi
fi
