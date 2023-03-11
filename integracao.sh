#!/bin/bash

echo "Iniciando integração entre Mikrotik e Mk-auth..."

echo "Configurando VPN PPTP..."
ssh root@172.20.1.2 <<EOF
/interface pptp-client add name="VPN MARRA CLOUD" connect-to=demo-ca.marracloud.com.br user=mkauth password=123456
EOF

echo "Acessando o Mikrotik via SSH..."
ssh root@172.20.1.2 <<EOF
/ip address print
EOF

echo "Permitindo o uso do Radius no ppp secret..."
ssh root@172.20.1.2 <<EOF
/radius add service=login disabled=no address=172.20.1.1 secret=123456 authentication-port=1812 accounting-port=1813
/ppp secret set [find service=pppoe] use-radius=yes
EOF

echo "Adicionando o usuário mkauth com as permissões corretas..."
ssh root@172.20.1.2 <<EOF
/system user add name=mkauth group=full password=123456 address=172.20.1.0/24,172.20.1.1 comment=Mk-Auth
EOF

echo "Integração concluída com sucesso!"
