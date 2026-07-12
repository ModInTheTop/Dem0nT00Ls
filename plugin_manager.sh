#!/bin/bash

# Configuración
CONFIG_FILE="plugins.conf"
TOOLS_DIR="Tools"
GIT_BASE_URLS=(
    "https://github.com/tu-repo/alhack"
    "https://github.com/htr-tech/zphisher"
    "https://github.com/techchipnet/CamPhish"
    "https://github.com/zidansec/subscan"
    "https://github.com/juzeon/fast-mail-bomber.git"
    "https://github.com/palahsu/DDoS-Ripper.git"
    "https://github.com/tegal1337/CiLocks"
    "https://github.com/htr-tech/track-ip.git"
    "https://github.com/BullsEye0/dorks-eye.git"
    "https://github.com/jaykali/hackerpro.git"
    "https://github.com/Tuhinshubhra/RED_HAWK"
    "https://github.com/Devil-Tigers/TigerVirus"
    "https://github.com/king-hacking/info-site.git"
    "https://github.com/MrSqar-Ye/BadMod.git"
    "https://github.com/fu8uk1/facebash"
    "https://github.com/D4RK-4RMY/DARKARMY"
    "https://github.com/FDX100/Auto_Tor_IP_changer.git"
)

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Crear directorio si no existe
mkdir -p "$TOOLS_DIR"

# Función para mostrar el banner
show_banner() {
    clear
    echo -e "${RED}"
    cat << 'EOF'
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣴⠾⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀  ⠀⠀  ⢸⡿⠻⢶⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⠞⠋⠀⢠⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀���⠀⠀    ⠈⢿⡄⠀⠉⠻⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⣴⠟⠁⣴⠟⢠⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀   ⠀ ⠈⣿⠀⢾⣆⠈⠻⣦⡀⠀⠀⠀⠀⠀⠀⠀
EOF
    echo -e "${NC}"
}

# Función para cargar y mostrar plugins
show_menu() {
    show_banner
    echo -e "${CYAN}╓────────────────────────────────────────╓"
    echo -e "║  ${YELLOW}SISTEMA DE PLUGINS - MADE BY MOD${CYAN}    ║"
    echo -e "╙────────────────────────────────────────╜${NC}\n"
    
    local count=0
    local cols=2
    
    while IFS='|' read -r num name dir setup exec; do
        if [ $((count % cols)) -eq 0 ]; then
            echo -ne "\n"
        fi
        printf "${BLUE}[%2d]${NC} %-30s " "$num" "$name"
        count=$((count + 1))
    done < "$CONFIG_FILE"
    
    echo -e "\n\n${BLUE}[0]${NC} Limpiar Herramientas"
    echo -e "${BLUE}[99]${NC} Salir\n"
}

# Función para instalar plugin
install_plugin() {
    local num=$1
    local line=$(sed -n "${num}p" "$CONFIG_FILE")
    
    IFS='|' read -r id name dir setup exec <<< "$line"
    
    if [ -z "$name" ]; then
        echo -e "${RED}❌ Plugin no encontrado${NC}"
        return 1
    fi
    
    # Obtener URL de GitHub
    local git_url="${GIT_BASE_URLS[$((num-1))]}"
    
    echo -e "${YELLOW}📥 Instalando: $name${NC}"
    echo -e "${YELLOW}URL: $git_url${NC}\n"
    
    cd "$TOOLS_DIR"
    git clone "$git_url" "$dir" 2>/dev/null || git clone "${git_url%.git}" "$dir"
    
    cd "$dir"
    
    # Ejecutar setup si no es '::'
    if [ ! -z "$setup" ] && [ "$setup" != "::" ]; then
        echo -e "${YELLOW}⚙️  Configurando...${NC}"
        eval "$setup" 2>/dev/null || true
    fi
    
    cd ../..
    echo -e "${GREEN}✅ $name instalado correctamente${NC}"
}

# Función para ejecutar plugin
run_plugin() {
    local num=$1
    local line=$(sed -n "${num}p" "$CONFIG_FILE")
    
    IFS='|' read -r id name dir setup exec <<< "$line"
    
    if [ -z "$name" ]; then
        echo -e "${RED}❌ Plugin no encontrado${NC}"
        return 1
    fi
    
    if [ ! -d "$TOOLS_DIR/$dir" ]; then
        echo -e "${YELLOW}⚠️  $name no instalado. Instalando...${NC}"
        install_plugin "$num"
    fi
    
    echo -e "${YELLOW}▶️  Ejecutando: $name${NC}\n"
    
    cd "$TOOLS_DIR/$dir"
    eval "$exec"
    cd ../..
}

# Función para desinstalar plugin
uninstall_plugin() {
    local num=$1
    local line=$(sed -n "${num}p" "$CONFIG_FILE")
    
    IFS='|' read -r id name dir setup exec <<< "$line"
    
    if [ -d "$TOOLS_DIR/$dir" ]; then
        rm -rf "$TOOLS_DIR/$dir"
        echo -e "${GREEN}✅ $name desinstalado${NC}"
    else
        echo -e "${YELLOW}⚠️  $name no estaba instalado${NC}"
    fi
}

# Función para limpiar todos
clean_all() {
    read -p "¿Seguro de eliminar todas las herramientas? (s/n): " confirm
    if [[ $confirm == "s" || $confirm == "S" ]]; then
        rm -rf "$TOOLS_DIR"
        mkdir -p "$TOOLS_DIR"
        echo -e "${GREEN}✅ Limpiado${NC}"
    fi
}

# Función principal
main() {
    while true; do
        show_menu
        read -p "$(echo -e ${BLUE}Opción${NC}): " option
        
        case $option in
            0)
                clean_all
                sleep 2
                ;;
            99)
                clear
                echo -e "${GREEN}¡Hasta luego!${NC}"
                exit 0
                ;;
            *)
                if [ "$option" -ge 1 ] && [ "$option" -le 18 ]; then
                    read -p "$(echo -e ${BLUE}[I]nstalar [E]jecutar [D]esinstalar${NC}): " action
                    case $action in
                        i|I)
                            install_plugin "$option"
                            ;;
                        e|E)
                            run_plugin "$option"
                            ;;
                        d|D)
                            uninstall_plugin "$option"
                            ;;
                        *)
                            echo -e "${RED}❌ Opción no válida${NC}"
                            ;;
                    esac
                else
                    echo -e "${RED}❌ Opción fuera de rango${NC}"
                fi
                read -p "Presiona Enter para continuar..."
                ;;
        esac
    done
}

main