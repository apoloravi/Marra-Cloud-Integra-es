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
