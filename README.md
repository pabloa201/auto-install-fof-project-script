FOG Project Automatizador (Com Correção de SSL)
Este script foi desenvolvido para automatizar a instalação do FOG Project (solução de clonagem e gestão de imagens de disco) em servidores Linux, focando na resolução de problemas comuns de implementação.

Problema Resolvido:
Muitas instalações do FOG falham ao gerar os certificados SSL necessários para a comunicação segura entre servidor e cliente (o erro de "Operação não permitida" no req.cnf). Este script implementa uma função sentinela que monitora o diretório de instalação em tempo real e corrige os parâmetros do OpenSSL automaticamente durante o processo.

Funcionalidades:
Instalação Limpa: Remove vestígios de instalações anteriores para evitar conflitos.

Utiliza a versão dev-branch para maior compatibilidade.

Sentinela de SSL: Monitoramento em background para garantir a criação correta dos certificados.

Automação de Dependências: Prepara o SO com todas as ferramentas necessárias.

Como utilizar:
Baixe o script no seu servidor:

Dê permissão de execução para o arquivo install_fog.sh

chmod +x install_fog.sh

Execute o script (ele cuidará do resto):
sudo ./install_fog.sh