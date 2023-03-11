#!/bin/bash

echo "Iniciando integração entre Mikrotik e Mk-auth..."

echo "Configurando VPN PPTP..."
sshpass -p 'senhaadmin' ssh -o StrictHostKeyChecking=no admin@172.20.1.2 << EOF
    /interface pptp-client
    add connect-to=172.20.1.1 disabled=no name=mk-auth password=123456 user=mkauth
EOF

echo "Acessando o Mikrotik via SSH..."
sshpass -p 'senhaadmin' ssh -o StrictHostKeyChecking=no admin@172.20.1.2 << EOF
    echo "Criando usuário no Mikrotik..."
    /user add name=mkauth group=full password=123456
    echo "Configurando o Radius no Mikrotik..."
    /radius incoming set accept=yes
    echo "Baixando o arquivo chave.pub do Mk-auth..."
    /tool fetch url="http://172.20.1.1/admin/chave.pub" mode=http
    echo "Importando o arquivo chave.pub no Mikrotik..."
    /user ssh-keys import user=mkauth public-key-file=chave.pub
    echo "Configurando permissões de IP para o usuário mkauth..."
    /user group set name=full policy="local,telnet,ssh,ftp,reboot,read,write,test,winbox,password,web,sniff,sensitive,api,!ftp,!telnet,!ssh,!reboot,!read,!write,!test,!winbox,!password,!web,!sniff,!sensitive,!api" policies="" users=mkauth
    /user group set name=read policy="local,telnet,ssh,!ftp,!reboot,read,test,winbox,!password,!web,!sniff,!api" policies="" users=""
    /user group set name=write policy="local,telnet,ssh,!ftp,!reboot,!read,write,test,winbox,!password,!web,!sniff,!api" policies="" users=""
    /user group set name=webadmin policy="local,!telnet,!ssh,!ftp,!reboot,!read,!write,!test,!winbox,!password,web,!sniff,!api" policies="" users=""
    /user group set name=ftpadmin policy="local,telnet,ssh,ftp,!reboot,!read,!write,!test,winbox,!password,!web,!sniff,!api" policies="" users=""
    /user group set name=vpn policy="local,!telnet,!ssh,!ftp,!reboot,!read,!write,!test,!winbox,!password,!web,!sniff,!api" policies="" users=""
    /user group set name=guest policy="local,!telnet,!ssh,!ftp,!reboot,!read,!write,!test,!winbox,!password,!web,!sniff,!api" policies="" users=""
    /user ssh-keys set user=mkauth value-name=ip-address value=172.20.1.0/24
    /user ssh-keys set user=mkauth value-name=ip-address value=$(echo /interface pptp-client print | sshpass -p 'senhaadmin' ssh admin@172.20.1.2 | awk -F "=" '/connect-to/{print $2}' | awk -F "/" '{print $1}')
EOF

echo "Permitindo o uso do Radius no ppp secret..."
sshpass -p 'senhaadmin' ssh -o StrictHostKeyChecking=no admin@172.20.1.2 << EOF
