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
# Comandos para criar o usuário no Mikrotik

# Configurando o Radius no Mikrotik
echo "Configurando o Radius no Mikrotik..."
# Comandos para configurar o Radius no Mikrotik
/ip hotspot profile set [find default=yes] use-radius=yes
/ip hotspot profile set [find default=yes] radius-interim-update=1m

# Baixando o arquivo chave.pub do Mk-auth
echo "Baixando o arquivo chave.pub do Mk-auth..."
/tool fetch url=http://172.20.1.1/chave.pub

# Importando o arquivo chave.pub no Mikrotik
echo "Importando o arquivo chave.pub no Mikrotik..."
/user ssh-keys import user=mk-auth public-key-file=chave.pub

# Configurando permissões de IP para o usuário mkauth
echo "Configurando permissões de IP para o usuário mkauth..."
/ip firewall address-list add list=mkauth-address address=172.20.1.0/24 comment="Permissão para acesso do mkauth"
/ip firewall address-list add list=mkauth-address address=192.99.159.81 comment="Permissão para acesso do mkauth"

# Permitindo o uso do Radius no ppp secret
echo "Permitindo o uso do Radius no ppp secret..."
# Comandos para permitir o uso do Radius no ppp secret
/ppp profile set default local-address=172.20.1.2 remote-address=ppp-remote use-radius=yes

EOF

echo "Integração finalizada."
