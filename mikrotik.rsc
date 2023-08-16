# Conexão VPN com MikroTik
/interface pptp-client add connect-to="{$service_server_ip}" user=mkauth1 password=123456 name=MARRA-VPN disabled=no

# Adicionando Usuário no MikroTik
/user add group=full name=mkauth password=mkauth1010 address=172.20.1.0/24 disabled=no

# Download da Chave Pública
#/tool fetch http-method=get url=http://172.20.1.1/admin/chave.pub
/tool netwatch add comment=mkauth host=172.20.1.1 up-script="/tool fetch http-method=get url=http://172.20.1.1/admin/chave.pub" disabled=no

# Importando Chave Pública para o Usuário mkauth
/user ssh-keys import user=mkauth public-key-file=chave.pub

# Configurando Porta SSH 2215 - IP 172.20.1.0/24 Restrito Externo
/ip service set ssh address=172.20.1.0/24 port=2215 disabled=no

# Configurando RADIUS
/radius add address=172.20.1.1 secret=123456 service=ppp
/radius incoming set accept=yes

# Regras de Corte via Filters (você pode usar o seu método)
/ip firewall filter
add action=drop chain=forward comment=CORTE dst-port=!53 protocol=udp src-address-list=pgcorte
add action=drop chain=forward comment=CORTE dst-port=!80,85,443,445 protocol=tcp src-address-list=pgcorte
.. .. ..

# Fim
/user ssh-keys import user=mkauth public-key-file=chave.pub
