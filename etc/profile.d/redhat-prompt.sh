########################################
# Custom Prompt - Glaidson Verzeletti
########################################

HISTSIZE=1000000
HISTFILESIZE=2000000

# DEFAULT
#if [ "$PS1" ] && [ "$(tput colors 2>/dev/null || printf 0)" -ge 8 ]; then
#    PS1='\[\e[0;38;5;160m\][\[\e[0;2m\]\A \[\e[0;1;38;5;105m\]\h \[\e[0m\]\W\[\e[0;38;5;160m\]]\[\e[0m\]\$ '
#else
#    PS1='[\A \h \W]\$ '
#fi

# uncomment for a colored prompt,
force_color_prompt=yes

# VLAN Segment: DMZ, LAN, ACAD, TEST
HOST_PROMPT=LAN

# Prompt default: oneline, oneline_nouser, twoline, twoline_nouser
PROMPT_USER=twoline
PROMPT_ROOT=oneline_nouser
if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    case "$HOST_PROMPT" in
        DMZ)
            host_color='\[\033[1;34m\]';;
        LAN)
            host_color='\[\033[00;32m\]';;
        ACAD)
            host_color='\[\033[1;31m\]';;
        TEST)
            host_color='\[\033[1;37m\]';;
    esac
    VIRTUAL_ENV_DISABLE_PROMPT=1

    # ALL USERS
    prompt_color='\[\033[;97m\]'        # branco
    user_color='\[\033[;97m\]'          # branco
    info_color='\[\033[00;90m\]'        # cinza
    #prompt_symbol=' ㉿'
    prompt_symbol='@'
    PROMPT_ALTERNATIVE=$PROMPT_USER

    # ROOT
    if [ "$EUID" -eq 0 ]; then # Change prompt colors for root user
        prompt_color='\[\033[;97m\]'    # branco
        user_color='\[\033[;97m\]'      # branco
        info_color='\[\033[00;90m\]'    # cinza
        # Skull emoji for root terminal
        #prompt_symbol=💀
        unset PROMPT_ALTERNATIVE
        PROMPT_ALTERNATIVE=$PROMPT_ROOT
    fi
    case "$PROMPT_ALTERNATIVE" in
        twoline)
            PS1=$prompt_color'┌──'$info_color' \t '$prompt_color'('$user_color'\u'$host_color$prompt_symbol'\h'$prompt_color')-['$info_color'\w'$prompt_color']\n'$prompt_color'└─'$info_color'\$\[\033[0m\] ';;
        twoline_nouser)
            PS1=$prompt_color'┌──'$info_color' \A '$prompt_color'('$host_color'\h'$prompt_color')-['$info_color'\w'$prompt_color']\n'$prompt_color'└─'$info_color'\$\[\033[0m\] ';;
        oneline)
            PS1=$prompt_color'['$info_color'\A '$user_color'\u'$host_color$prompt_symbol'\h'$info_color' \w'$prompt_color']\$ ' ;;
        oneline_nouser)
            PS1=$prompt_color'['$info_color'\t '$host_color'\h'$info_color' \w'$prompt_color']\$ ' ;;
    esac
    unset prompt_color
    unset user_color
    unset info_color
    unset prompt_symbol

else
    PS1='\u@\h:\w\$ '
fi
