#!/bin/sh

# Cambia estos valores según tu configuración
REPO_URL="https://github.com/HynDuf/nixos-conf.git"
FAVOURITE_NAME="<YOUR_FAVOURITE_NAME>"
USERNAME="<YOUR_USERNAME_HERE>"
HOSTNAME="<YOUR_HOSTNAME>"

# Clonar el repositorio
git clone "$REPO_URL" "$FAVOURITE_NAME"

# Copiar el archivo de configuración de hardware
cp --no-preserve=ownership /etc/nixos/hardware-configuration.nix "$FAVOURITE_NAME/hosts/$USERNAME/hardware-configuration.nix"

# Añadir configuración al archivo hardware-configuration.nix
echo 'boot.kernelPackages = pkgs.linuxPackages_latest;' >> "$FAVOURITE_NAME/hosts/$USERNAME/hardware-configuration.nix"

# Comentar ./nvidia.nix en default.nix
sed -i 's|^  ./nvidia.nix|# ./nvidia.nix|' "$FAVOURITE_NAME/hosts/$USERNAME/default.nix"

# Crear un enlace simbólico
sudo ln -s "$(pwd)/$FAVOURITE_NAME/flake.nix" /etc/nixos/

# Hacer ejecutables los scripts
chmod +x "$FAVOURITE_NAME/bin/"*.sh
chmod +x "$FAVOURITE_NAME/home/visuals/eww/config/scripts/"*.sh

# Cambiar ID del monitor
echo "Por favor, ejecuta 'xrandr' y reemplaza 'eDP-1' con tu ID de monitor en los siguientes archivos:"
echo "1. $FAVOURITE_NAME/home/visuals/bspwm_sxhkd/bspwmrc"
echo "2. $FAVOURITE_NAME/home/visuals/polybar/config/config.ini"

# Cambiar nombre de usuario y hostname en flake.nix y system.nix
sed -i "s/your/$USERNAME/g" "$FAVOURITE_NAME/flake.nix"
sed -i "s/hynduf/$USERNAME/g" "$FAVOURITE_NAME/modules/system.nix"

# Inicializar el repositorio git
cd "$FAVOURITE_NAME" || exit
rm -rf .git
git init
git add --all

# Rebuild del sistema
sudo nixos-rebuild switch --flake .#$HOSTNAME

# Mensaje final
echo "Configuración completada. Asegúrate de revisar y ajustar cualquier configuración adicional necesaria."
