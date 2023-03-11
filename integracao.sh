#!/bin/bash

echo "Iniciando integração entre Mikrotik e Mk-auth..."

# Configuração da VPN PPTP
echo "Configurando VPN PPTP..."
# Comandos para configurar a VPN PPTP no Mikrotik

# Acessando o Mikrotik via SSH
echo "Acessando o Mikrotik via SSH..."
ssh -p 2215 admin@172.20.1.2 << EOF

# Criando usuário no Mikrotik
echo "Criando usuário no Mikrotik..."
# Comandos para criar o usuário no Mikrotik

# Configurando o Radius no Mikrotik
echo "Configurando o Radius no Mikrotik..."
# Comandos para configurar o Radius no Mikrotik
/ip hotspot profile set 0 use-radius=yes
/ip hotspot profile set 1 use-radius=yes

# Baixando o arquivo chave.pub do Mk-auth
echo "Baixando o arquivo chave.pub do Mk-auth..."
/tool fetch url="http://172.20.1.1/chave.pub" mode=http dst-path=chave.pub

# Importando o arquivo chave.pub no Mikrotik
echo "Importando o arquivo chave.pub no Mikrotik..."
/user ssh-keys import user=mkauth public-key-file=chave.pub

# Configurando permissões de IP para o usuário mkauth
echo "Configurando permissões de IP para o usuário mkauth..."
/ip firewall address-list add list=mkauth address=172.20.1.0/24
/ip firewall address-list add list=mkauth address=192.99.159.81

# Permitindo o uso do Radius no ppp secret
echo "Permitindo o uso do Radius no ppp secret..."
/radius incoming set accept=yes

EOF

echo "Integração finalizada."
