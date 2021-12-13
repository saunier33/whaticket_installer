Instalação de múltiplas servidores em VPN

### Download e Configurações 

Criar usuário DEPLOY e fazer as instalações por ele, devido a um erro na biblioteca com usuário root:


```bash
sudo adduser deploy
sudo usermod -aG sudo deploy
sudo su deploy
```

Instalação das bibliotecas
```bash
sudo apt -y update && apt -y upgrade
sudo apt install -y git
sudo apt-get install -y libxshmfence-dev libgbm-dev wget unzip fontconfig locales gconf-service libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 ca-certificates fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils nginx
curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt install docker-ce 
sudo usermod -aG docker ${USER}
su - ${USER}
sudo npm install -g pm2
sudo rm -rf /etc/nginx/sites-enabled/default
sudo rm -rf /etc/nginx/sites-available/default
sudo killall apache2
sudo add-apt-repository ppa:certbot/certbot
sudo apt install python3-certbot-nginx
sudo nginx -t
sudo service nginx restart
sudo apt update
sudo apt upgrade
```


Setar no servidor de DNS os dominios para o IP da VPN
Exemplo utilizado neste modelo é da HOSTINGER


Criando uma imagem do instalador do WhaTicket na pasta raiz
```bash
cd ~
sudo git clone https://github.com/saunier33/whaticket_installer.git
sudo chmod +x ./whaticket_installer/whaticket
cd ./whaticket_installer
sudo ./whaticket
```

Ao executar o código, será solicitado o dominio principal do sistema (Frontend) e o dominio referente a API (Backend)
Exemplo: app.dominio.com.br
Exemplo: api.dominio.com.br

Ao finalizar faça os próximos passos para gerenciamento dos arquivos
```bash
mkdir unidade
cd unidade
mkdir XX-UnidadeY
cd XX-UnidadeY
mkdir producao
mkdir base_teste
cd~
pm2 kill
mv whaticket ./unidade/XX-UnidadeY/producao
cd unidade/XX-UnidadeY/producao/whaticket/frontend
sudo nano .env
```

Verifique que o dominio já estará setado pois já fizemos a pré-configuração no instalador.
```bash
REACT_APP_BACKEND_URL=https://api.dominio.com.br
```
APERTE CRTL + X | Y | ENTER
```

FRONTEND - Aqui iremos setar a porta do servidor e utilizaremos a faixa 1000 ~ 1999
```bash
sudo nano server.js
...
app.listem(1000);
...
```
APERTE CRTL + X | Y | ENTER

BACKEND - Aqui iremos setar a porta do servidor e utilizaremos a faixa 7000 ~ 7999
```bash
cd ..
cd backend
sudo nano .env
NODE_ENV=
BACKEND_URL=https://api.dominio.com.br
FRONTEND_URL=https://app.dominio.com.br
PROXY_PORT=443
PORT=7000

DB_HOST=IP_EXTERNO_BD
DB_DIALECT=mysql
DB_USER=USUARIO_BD
DB_PASS=SENHA
DB_NAME=NOME_BD

JWT_SECRET=wKYszNyqUVakedgRbpnvnjllsGHAMj3ZUbsu0r4hScM=
JWT_REFRESH_SECRET=IUseonV3RAoWuMhLSAEThtidvSz1XmyUCtmRvKXayLQ=
```
APERTE CRTL + X | Y | ENTER

NGINX - Aqui iremos fazer as configurações no NGINX ele também já esta pré-configurado 
```bash
cd /etc/nginx/sites-enabled/
sudo nano whaticket-backend
```

Altere a porta de acordo com a porta configurada no BACKEND em "PORT=7000"

```bash
server {
  server_name api.riverview.com.br;

  location / {
    proxy_pass http://127.0.0.1:7000;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_cache_bypass $http_upgrade;
  }
}
```
APERTE CRTL + X | Y | ENTER

```bash
sudo nano whaticket-frontend
```

Altere de acordo com a porta configurada no FRONTEND em "App.Listem(1000);"
```bash
server {
  server_name app.riverview.com.br;

  location / {
    proxy_pass http://127.0.0.1:1000;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_cache_bypass $http_upgrade;
  }
}
```
APERTE CRTL + X | Y | ENTER

```bash
cd ..
cd sites-available
sudo nano whaticket-backend
```
Altere a porta de acordo com a porta configurada no BACKEND em "PORT=7000"

```bash
server {
  server_name api.riverview.com.br;

  location / {
    proxy_pass http://127.0.0.1:7000;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_cache_bypass $http_upgrade;
  }
}
```
APERTE CRTL + X | Y | ENTER
```bash
sudo nano whaticket-frontend
```

Altere de acordo com a porta configurada no FRONTEND em "App.Listem(1000);"
```bash
server {
  server_name app.riverview.com.br;

  location / {
    proxy_pass http://127.0.0.1:1000;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_cache_bypass $http_upgrade;
  }
}
```
APERTE CRTL + X | Y | ENTER

```bash
sudo ln -s /etc/nginx/sites-available/whaticket-frontend /etc/nginx/sites-enabled
sudo ln -s /etc/nginx/sites-available/whaticket-backend /etc/nginx/sites-enabled
cd ..
sudo nano /etc/nginx/nginx.conf
```
Procure HTTP e abaixo de qualquer uma das ligas insira o seguinte código:
```bash
    client_max_body_size 20M; 
```
APERTE CRTL + X | Y | ENTER

Iremos dar o restart no nginx

```bash
sudo rm -rf /etc/nginx/sites-enabled/default
sudo rm -rf /etc/nginx/sites-available/default
sudo killall apache2
sudo nginx -t
sudo service nginx restart
```
START no FRONTEND

```bash
cd~
cd unidade/XX-UnidadeY/producao/whaticket/frontend
sudo npm install
sudo npm run build
pm2 start server.js --name whaticket-frontend
```
START no BACKEND
```bash
cd ..
cd backend
sudo npm install
sudo npm run build
npx sequelize db:migrate
npx sequelize db:seed:all
pm2 start dist/server.js --name whaticket-backend

```
```bash
sudo certbot --nginx
```
