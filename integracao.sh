#!/bin/bash
echo "Iniciando integração entre Mikrotik e Mk-auth..."

# Configuração da VPN PPTP
echo "Configurando VPN PPTP..."
# Comandos para configurar a VPN PPTP no Mikrotik

# Acessando o Mikrotik via SSH
echo "Acessando o Mikrotik via SSH..."
ssh admin@172.20.1.2 -p 2215 <<EOF
# Criando usuário no Mikrotik
echo "Criando usuário no Mikrotik..."
/user add name=mk-auth password=123456 group=full

# Configurando o Radius no Mikrotik
echo "Configurando o Radius no Mikrotik..."
/radius add service=ppp address=172.20.1.1 secret=senha12345

# Baixando o arquivo chave.pub do Mk-auth
echo "Baixando o arquivo chave.pub do Mk-auth..."
/tool fetch url=http://172.20.1.1/admin/chave.pub mode=http

# Importando o arquivo chave.pub no Mikrotik
echo "Importando o arquivo chave.pub no Mikrotik..."
/user ssh-keys import user=mk-auth public-key-file=chave.pub

# Configurando permissões de IP para o usuário mkauth
echo "Configurando permissões de IP para o usuário mkauth..."
/user group add name=mk-auth policy="ssh,ftp,reboot,sensitive,read,test,write,policy,test,winbox,password,web,sniff,api,!local,!telnet,!ssh,!ftp,!web,!api,!winbox,!reboot,! sensitive,!read,!write,!policy"

# Permitindo o uso do Radius no ppp secret
echo "Permitindo o uso do Radius no ppp secret..."
/ppp secret set [find] service=pppoe,hotspot,ovpn,vpn pptp-incoming-filter=accept

EOF

echo "Integração finalizada."
