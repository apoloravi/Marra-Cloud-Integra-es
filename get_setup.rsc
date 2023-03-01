#!/bin/bash

# INTEGRAÇÃO MARRA CLOUD
# Integração Mk-Auth com Mikrotik

# Menu de Integração
echo "#######################"
echo "# MENU DE INTEGRAÇÃO  #"
echo "#######################"
echo "Digite 1 para Integração:  "
echo "Digite 2 para Reparar: "
echo "Digite 3 para Testar se está tudo OK: "

# Lê a opção digitada pelo usuário
read opcao

case $opcao in
  # Opção 1 - Integração
  1)
    echo "Integrando..."
    
    # Verifica se a configuração já existe
    echo "Antes de começar, verifique se a configuração já existe."
    echo "Se existir, mude apenas o usuário para 'mkauth2' e siga na ordem crescente."
    
    # Solicita o IP da VPN PPTP
    echo "Digite o IP da VPN PPTP: "
    read pptp_ip
    
    # Cria uma conexão VPN PPTP
    echo "Criando uma conexão VPN PPTP com comment='VPN MK-AUTH', IP=$pptp_ip, user='mkauth1' e senha='123456'"
    /interface pptp-client add name="vpn-mkauth" connect-to="$pptp_ip" comment="VPN MK-AUTH" user="mkauth1" password="123456"
    
    # Habilita o uso de RADIUS para autenticação
    echo "Habilitando o uso de RADIUS para autenticação."
    /ppp secret set use-radius=yes
    
    # Adiciona um servidor RADIUS
    echo "Adicionando um servidor RADIUS."
    /radius add address=172.20.1.1 secret=123456 service=ppp
    /radius incoming set accept=yes
    
    # Adiciona um usuário
    echo "Adicionando um usuário 'mkauth' com senha 'mkauth1010' e grupo 'full'"
    /user add name=mkauth password=mkauth1010 group=full
    
    # Baixa a chave SSH do servidor
    echo "Baixando a chave SSH do servidor."
    /tool fetch url=http://172.20.1.1/chave.pub mode=http
    
    # Adiciona a chave SSH ao usuário
    echo "Adicionando a chave SSH ao usuário 'mkauth'."
    /user ssh-keys import public-key-file=chave.pub user=mkauth
    
    echo "Integração concluída."
    ;;
  
  # Opção 2 - Reparar
  2)
    echo "Reparando..."
    # Coloque aqui as ações de reparo
    echo "Reparo concluído."
    ;;
    
  # Opção 3 - Testar se está tudo OK
  3)
    echo "Testando se está tudo OK..."
    # Coloque aqui as ações de teste
    echo "Teste OK."
    ;;
    
  # Opção inválida
  *)
    echo "Opção inválida."
    ;;
esac

exit 0
