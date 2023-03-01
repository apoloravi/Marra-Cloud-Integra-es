# INTEGRAÇÃO MARRA CLOUD
# Integração Mk-Auth com Mikrotik

# Menu de Integração
:put "#######################"
:put "# MENU DE INTEGRAÇÃO  #"
:put "#######################"
:put "Digite 1 para Integração:  "
:put "Digite 2 para Reparar: "
:put "Digite 3 para Testar se está tudo OK: "

# Lê a opção digitada pelo usuário
:local opcao [/system script environment get opcao]

:if ($opcao = "") do={
  :set opcao [/system script environment get opcao]
}

# Se não houver opção definida, lê a opção digitada pelo usuário
:if ($opcao = "") do={
  :local opcao
  :if ([/interface find comment="VPN MK-AUTH"] = "") do={
    :put "Digite a opção desejada:"
    :input opcao
  } else={
    :put "A configuração já existe. Digite 1 para integrar, 2 para reparar ou 3 para testar."
    :input opcao
  }
}

# Configuração VPN PPTP
:if ($opcao = "1") do={
  :put "Integrando..."

  # Solicita o IP da VPN PPTP
  :put "Digite o IP da VPN PPTP: "
  :local pptp_ip [/system script environment get pptp_ip]
  :if ($pptp_ip = "") do={
    :set pptp_ip [/system script environment get pptp_ip]
  }
  :if ($pptp_ip = "") do={
    :input pptp_ip
  }

  # Cria uma conexão VPN PPTP
  :put ("Criando uma conexão VPN PPTP com comment='VPN MK-AUTH', IP=" . $pptp_ip . ", user='mkauth1' e senha='123456'")
  /interface pptp-client add name="vpn-mkauth" connect-to=$pptp_ip comment="VPN MK-AUTH" user="mkauth1" password="123456"

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

  :put "Integração concluída."
}

# Opção 2 - Reparar
:if ($opcao = "2") do={
  :put "Reparando..."
  # Coloque aqui as ações
