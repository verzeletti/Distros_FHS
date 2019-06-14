#!/bin/bash


usage() {
  echo " Usage: $0 HOSTNAME"
  exit 1
}


# testar parametros
[ -z $1 ] && usage

# testar sintaxe valida
if [[ "$1" =~ [^a-z0-9-] ]]; then
  echo " HOSTNAME must be lowercase alphanumeric: [a-z0-9]*"
  usage
elif [ ${#1} -gt 63 ]; then
  echo " HOSTNAME must have <63 chars"
  usage
fi


# alterar hostname local
chost="$( hostname -s )"
iphost_old="$( ip r s | tail -n1 | awk '{print $1}' )"
iphost="$( head -n2 /etc/hosts | tail -n1 | awk '{print $NF}' )"
sed -i "s/${chost}/${1}/g" /etc/hosts
sed -i "s/${iphost}/${iphost_old}/g" /etc/hosts
sed -i "s/${chost}/${1}/g" /etc/hostname

invoke-rc.d hostname.sh restart
invoke-rc.d networking force-reload
hostnamectl set-hostname $1


# re-gerar chaves SSH
rm -f /etc/ssh/ssh_host_* 2> /dev/null
dpkg-reconfigure openssh-server &> /dev/null
