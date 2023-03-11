#!/bin/bash

echo "Iniciando integração entre Mikrotik e Mk-auth..."

# Configura VPN PPTP
echo "Configurando VPN PPTP..."
/system package update
/system package enable pptp
/interface pptp-client add name=pptp-cliente user=vpnuser password=vpnpass \
connect-to=vpn.mikrotik.com.br
/ip route add dst-address=192.168.99.0/24 gateway=pptp-cliente

# Acessa o Mikrotik via SSH
echo "Acessando o Mikrotik via SSH..."
sshpass -p 'adminpassword' ssh -o StrictHostKeyChecking=no admin@172.20.1.2 << EOF
    # Cria usuário mkauth com acesso somente para IPs específicos
    echo "Criando usuário mkauth no Mikrotik..."
    /user add name=mkauth group=full password=mkauth123 \
    address=172.20.1.0/24,192.168.99.2
    
    # Configura Radius com secret 123456
    echo "Configurando o Radius no Mikrotik..."
    /radius add service=hotspot address=172.20.1.1 secret=123456
    /radius incoming set accept=yes
    
    # Importa chave.pub do Mk-auth para autenticação via SSH
    echo "Importando o arquivo chave.pub do Mk-auth..."
    /user ssh-keys import user=mkauth public-key-file=chave.pub
    
    # Configura permissões de IP para o usuário mkauth
    echo "Configurando permissões de IP para o usuário mkauth..."
    /ip firewall address-list add list=mkauth address=172.20.1.0/24
    /ip firewall address-list add list=mkauth address=192.168.99.2
    
    # Permite o uso do Radius no ppp secret
    echo "Permitindo o uso do Radius no ppp secret..."
    /ppp secret set [ find service=any ] radius=hotspot
    /ppp secret set [ find name=pptp-cliente ] radius=hotspot
EOF

echo "Integração finalizada."
