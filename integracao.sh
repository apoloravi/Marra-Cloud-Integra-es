#!/bin/bash

echo "Iniciando integração entre Mikrotik e Mk-auth..."

# Configuração da VPN PPTP
echo "Configurando VPN PPTP..."
# Comandos para configurar a VPN PPTP no Mikrotik

# Acessando o Mikrotik via SSH
echo "Acessando o Mikrotik via SSH..."
ssh -o StrictHostKeyChecking=no admin@172.20.1.2 -p 2215 << EOF
    # Criando usuário no Mikrotik
    echo "Criando usuário no Mikrotik..."
    /user add name=mkauth password=123456 group=full permissions=172.20.1.0/24,$(echo "ip route get 1" | awk '{print $NF;exit}') comment="Usuário para integração com Mk-auth"

    # Configurando o Radius no Mikrotik
    echo "Configurando o Radius no Mikrotik..."
    /radius add service=ppp address=172.20.1.1 secret=123456

    # Baixando o arquivo chave.pub do Mk-auth
    echo "Baixando o arquivo chave.pub do Mk-auth..."
    /tool fetch url=http://172.20.1.1/admin/chave.pub mode=http dst-path=chave.pub

    # Importando o arquivo chave.pub no Mikrotik
    echo "Importando o arquivo chave.pub no Mikrotik..."
    /user ssh-keys import file-name=chave.pub user=mkauth

    # Configurando permissões de IP para o usuário mkauth
    echo "Configurando permissões de IP para o usuário mkauth..."
    /user group set name=full policy=telnet,ssh,ftp,reboot,read,write,test,winbox,password,web,sniff,sensitive,api,romon,dude,tikapp local-address=172.20.1.0/24 remote-address=$(echo "ip route get 1" | awk '{print $NF;exit}')

    # Permitindo o uso do Radius no ppp secret
    echo "Permitindo o uso do Radius no ppp secret..."
    /ppp secret set default use-radius=yes
EOF

echo "Integração finalizada."
