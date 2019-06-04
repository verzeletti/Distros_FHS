#!/bin/bash
#echo -e ""
echo -e "Realtime..: \e[01;37m$(date +"%A, %e %B %Y, %r")

\033[01;32m______________________________________________________\033[00;37m
   \e[31m_ \e[32m___\e[0m
  \e[31m(_)\e[32m_|_|\e[0m    \033[01;32mInstituto Federal de Santa Catarina\033[00;37m
  \e[37m|_|\e[32m_|_\e[0m
  \e[37m|_|\e[32m_|_|\e[0m    \033[01;32m       CTIC - Campus Lages\033[00;37m
  \e[37m|_|\e[32m_|\e[0m      \033[01;37m     <ctic.lages@ifsc.edu.br>\033[00;37m
\033[01;32m______________________________________________________\033[00;37m

    GNU/Linux kernel.: \e[34m$(uname -r) \033[00;37m
    Tempo ligado.....: \e[34m$(uptime -p)\033[00;37m
    Mem. disponivel..: \e[34m$(free -h | head -n2 | tail -n1 | rev | cut -d' ' -f1 | rev) \033[00;37m
    Enderecos IPv4...: \e[34m$(ip a | grep global | grep inet\ | awk '{print $2}' | cut -f1 -d/ | tr -s '\n' ' ') \033[00;37m
              IPv6...: \e[34m$(ip a | grep global | grep inet6\ | awk '{print $2}' | cut -f1 -d/ | tr -s '\n' ' ') \033[00;37m
    % de disco usado.: \e[34m$(df -x tmpfs -x devtmpfs --output=pcent,target | tac | head -n-1 | sed 's/^[[:space:]]*/(/g;s/$/)/g' | grep -E '/)|/var/log)' | tac | tr '\n' ' ') \033[00;37m
                       \e[34m$(df -x tmpfs -x devtmpfs --output=pcent,target | tac | head -n-1 | sed 's/^[[:space:]]*/(/g;s/$/)/g' | grep -E '/boot)|/tmp)' | tac | tr '\n' ' ') \033[00;37m
                       \e[34m$(df -x tmpfs -x devtmpfs --output=pcent,target | tac | head -n-1 | sed 's/^[[:space:]]*/(/g;s/$/)/g' | grep -Ev '/var/log)|/tmp)|/boot)|/)' | tac | tr '\n' ' ') \033[00;37m
\033[01;32m______________________________________________________\033[00;37m

 \e[31m    * * * Based on Hardening Template * * * \e[0m

"
