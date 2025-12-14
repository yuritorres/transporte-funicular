#!/bin/bash
# =====================================================================
#                         CURSODEV INSTALLER v1.0
# =====================================================================

# Cores
amarelo="\e[33m"
verde="\e[32m"
branco="\e[97m"
azul="\e[94m"
vermelho="\e[91m"
reset="\e[0m"

# Função: Cabeçalho bonito
banner() {
    clear
    echo -e "${amarelo}===================================================================================================$reset"
    echo -e "${amarelo}                                                                                                  $reset"
    echo -e "${amarelo}              ${branco}██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ███████╗██████╗              ${amarelo}$reset"
    echo -e "${amarelo}              ${branco}██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██╔════╝██╔══██╗             ${amarelo}$reset"
    echo -e "${amarelo}              ${branco}██║██╔██╗ ██║███████╗   ██║   ███████║██║     █████╗  ██████╔╝             ${amarelo}$reset"
    echo -e "${amarelo}              ${branco}██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██╔══╝  ██╔══██╗             ${amarelo}$reset"
    echo -e "${amarelo}              ${branco}██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗██║  ██║             ${amarelo}$reset"
    echo -e "${amarelo}              ${branco}╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝  ╚═╝             ${amarelo}$reset"
    echo -e "${amarelo}                                                                                                  $reset"
    echo -e "${amarelo}                         ${branco}>>>  INSTALADOR  CURSODEV  <<<${amarelo}                        $reset"
    echo -e "${amarelo}                                                                                                  $reset"
    echo -e "${amarelo}===================================================================================================$reset"
    echo ""
}

# Função: Mensagem com animação
mensagem() {
    local texto="$1"
    local cor="${2:-$branco}"
    echo -ne "$cor$texto$reset"
    sleep 0.3
    echo -ne "."
    sleep 0.3
    echo -ne "."
    sleep 0.3
    echo -ne "."
    sleep 0.5
    echo ""
}

# Função: Checa retorno e mostra status
check_status() {
    if [ $? -eq 0 ]; then
        echo -e "${verde}[ OK ]${reset} $1"
    else
        echo -e "${vermelho}[ FALHA ]${reset} $1"
    fi
}

# Função: Barra de progresso fake (visual)
progresso() {
    echo -ne "${azul}Progresso: ["
    for ((i=0; i<=20; i++)); do
        echo -ne "#"
        sleep 0.05
    done
    echo -e "]${reset}"
}

# ---------------------------------------------------------------------
# Início do Script
# ---------------------------------------------------------------------
banner
mensagem "Verificando sistema operacional...." "$amarelo"

if ! grep -q 'PRETTY_NAME="Debian GNU/Linux 11' /etc/os-release; then
    echo -e "${vermelho}- Este script foi testado em Debian 11, Ubuntu 20 e 22.${reset}"
    echo -e "Bora continuar mesmo assim? (S/N)"
    read -r resp
    [[ "$resp" != "s" ]] && echo "Instalação Abortada." && exit 1
fi

# Verifica se é root
if [ "$(id -u)" -ne 0 ]; then
    echo -e "${vermelho}❌ Execute este script como usuario root, na pasta root.${reset}"
    exit 1
fi

# Selecione o Caminho da Instalação.
#cd /home/thiago || exit

# Vai para /root
cd /root || exit

banner
mensagem "Descomplicando sua vida e atualizando os pacotes do sistema" "$amarelo"
progresso
apt update -y > /dev/null 2>&1
check_status "Atualização foi concluída com sucesso!"

mensagem "Agora, instalando os pacotes necessários" "$amarelo"
PACKAGES=(sudo apt-utils dialog jq apache2-utils git python3 neofetch)

count=1
for pkg in "${PACKAGES[@]}"; do
    apt install -y "$pkg" > /dev/null 2>&1
    check_status "($count/${#PACKAGES[@]}) - $pkg instalado"
    ((count++))
done

progresso
mensagem "Calma Lá... Estamos preparando ambiente..." "$amarelo"
sleep 2

# ---------------------------------------------------------------------
# Executa o setup local
# ---------------------------------------------------------------------

if [ -f "./setup.sh" ]; then
    echo -e "${verde}✅ setup.sh encontrado. Iniciando próxima etapa...${reset}"
    chmod +x setup.sh
    sleep 1
    clear
    ./setup.sh
else
    echo -e "${vermelho}❌ Arquivo setup.sh não encontrado no diretório atual!${reset}"
    echo "Por favor, coloque o arquivo setup.sh em /root e execute novamente."
    exit 1
fi

banner
echo -e "${verde}✅ Instalação foi concluída com sucesso e sem erros!${reset}"
echo -e "${branco}Sistema pronto para uso.${reset}"
echo ""
neofetch
