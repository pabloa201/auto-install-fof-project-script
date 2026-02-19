#!/bin/bash
# =================================================================
# FOG SERVER CORE AUTOMATOR V3.0 - MODULAR EDITION
# Foco: Instalação Limpa + Correção de Certificados SSL
# =================================================================

# Cores para o terminal
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}--- [1/3] Preparando Dependências do Sistema ---${NC}"
# Garante que o usuário tem sudo e as ferramentas básicas
apt update && apt install git curl wget -y

echo -e "${GREEN}--- [2/3] Baixando FOG Project (Dev-Branch) ---${NC}"
cd /opt
if [ -d "fogproject" ]; then
    echo "Limpando instalação anterior..."
    rm -rf fogproject
fi
git clone https://github.com/FOGProject/fogproject.git
cd fogproject && git checkout dev-branch

echo -e "${GREEN}--- [3/3] Iniciando Sentinela SSL em Background ---${NC}"
# Esta função evita o erro "Operação não permitida" no arquivo req.cnf
# que travava o instalador anteriormente.
fix_ssl_sentinel() {
    echo "Sentinela: Aguardando diretório de snapins..."
    while [ ! -d /opt/fog/snapins/ssl ]; do
        sleep 1
    done
    
    # Enquanto o instalador rodar, forçamos o arquivo correto
    while pgrep installfog.sh > /dev/null; do
        if [ -f /opt/fog/snapins/ssl/req.cnf ]; then
            # Remove imutabilidade se o FOG tentar travar
            chattr -i /opt/fog/snapins/ssl/req.cnf 2>/dev/null
        fi
        
        cat <<EOF > /opt/fog/snapins/ssl/req.cnf
[req]
distinguished_name = req_distinguished_name
prompt = no
[req_distinguished_name]
C = BR
ST = SP
L = Local
O = LabSRE
CN = $(hostname -I | awk '{print $1}')
EOF
        sleep 2
    done
}

# Dispara a sentinela em background
fix_ssl_sentinel & 

echo -e "${GREEN}--- INICIANDO INSTALADOR OFICIAL ---${NC}"
echo "Lembre-se: Siga as instruções na tela e use o IP fixo do servidor."
cd bin
./installfog.sh