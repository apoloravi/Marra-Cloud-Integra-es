# Marra-Cloud-Integrações

# Integração Mk-Auth com Mikrotik

integração  Mk-auth com Mikrotik


### 1º Passo: Configurando PPTP-CLIENT VPN DE COMUNICAÇÃO

```bash
interface pptp-client add name=Mk-Auth01 connect-to=IP user=mkauth1 password=123456 disabled=no
```

### 2º Configurando Radius Cliente
```bash
radius remove numbers=0
radius add address=172.20.1.1 secret=123456 service=ppp comment=Ramaul-01
radius incoming set accept=yes
```

### 3º Criar Usuario mk-auth para comunicação SSH
```bash
user remove mkauth
user add name=mkauth password=123456 address=172.20.1.0/24 group=full
```

### 4º Baixando Chave.pub para inserir no user Mk-auth
```bash
tool fetch http-method=get url=http://172.20.1.1/admin/chave.pub
```

### 5º Inserindio chave.pub em user Mk-auth SSH-Keys
```bash
user ssh-keys import user=mkauth public-key-file=chave.pub
```
