# INTEGRAÇÃO MARRA CLOUD
# Integração Mk-Auth com Mikrotik

# Menu de Integração
:local opcao ([/system script environment get opcao] ? [/system script environment get opcao] : 0)

:put "#######################"
:put "# MENU DE INTEGRAÇÃO  #"
:put "#######################"
:put "Digite 1 para Integração:  "
:put "Digite 2 para Reparar: "
:put "Digite 3 para Testar se está tudo OK: "

# Lê a opção digitada pelo usuário
:if ($opcao = 0) do={
  :local opcao [/system script mode-value get opcao]
}

:switch $opcao do={
  # Opção 1 - Integração
  1) do={
    :put "Integrando..."

    # Verifica se a configuração já existe
    :put "Antes de começar, verifique se a configuração já existe."
    :put "Se existir, mude apenas o usuário para 'mkauth2' e siga na ordem crescente."

    # Solicita o IP da VPN PPTP
    :put "Digite o IP da VPN PPTP: "
    :local pptp_ip [/system script mode-value get pptp_ip]

    # Cria uma conexão VPN PPTP
    :put "Criando uma conexão VPN PPTP com comment='VPN MK-AUTH', IP=$pptp_ip, user='mkauth1' e senha='123456'"
    /interface pptp-client add name="vpn-mkauth" connect-to="$pptp_ip" comment="VPN MK-AUTH" user="mkauth1" password="123456"

    # Habilita o uso de RADIUS para autenticação
    :put "Habilitando o uso de RADIUS para autenticação."
    /ppp secret set use-radius=yes

    # Adiciona um servidor RADIUS
    :put "Adicionando um servidor RADIUS."
    /radius add address=172.20.1.1 secret=123456 service=ppp
    /radius incoming set accept=yes

    # Adiciona um usuário
    :put "Adicionando um usuário 'mkauth' com senha 'mkauth1010' e grupo 'full'"
    /user add name=mkauth password=mkauth1010 group=full

    # Baixa a chave SSH do servidor
    :put "Baixando a chave SSH do servidor."
    /tool fetch url=http://172.20.1.1/chave.pub mode=http

    # Adiciona a chave SSH ao usuário
    :put "Adicionando a chave SSH ao usuário 'mkauth'."
    /user ssh-keys import public-key-file=chave.pub user=mkauth
