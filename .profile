
echo -e "\e[0;32m"
echo "###############################################################"
echo "#                                                             #"
echo "#                        ENTORNO TEST                         #"
echo "#                                                             #"
echo "###############################################################"
echo "                                         "
echo "  @ofs          - Cargar entorno OFSAA"
echo "  @agentCN      - Cargar entorno Oracle Management Agent CN"
echo "  @agentLC      - Cargar entorno Oracle Management Agent LC"
echo -e "\e[0m"

alias @ofs=". /u01/app/oracle/scripts/ofs02_domain/conf/wls-environment-set.sh; export PS1=\"\[\033[0;32m\][TEST]\[\033[0m\][\[\033[1;34m\]\u\[\033[0m\]@\h][\$DOMAIN_NAME]:\W\\$ \" "
alias @agentCN="cd /u01/app/oracle/scripts/agent/; . ./conf/env_agentCN.sh; export PS1=\"\[\033[0;32m\][TEST]\[\033[0m\][\[\033[1;34m\]\u\[\033[0m\]@\h][\$ORACLE_ENV_TYPE]:\W\\$ \" "
alias @agentLC="cd /u01/app/oracle/scripts/agent/; . ./conf/env_agentLC.sh; export PS1=\"\[\033[0;32m\][TEST]\[\033[0m\][\[\033[1;34m\]\u\[\033[0m\]@\h][\$ORACLE_ENV_TYPE]:\W\\$ \" "


export PS1="\[\033[0;32m\][TEST]\[\033[0m\][\[\033[1;34m\]\u\[\033[0m\]@\h]:\W\\$ "
