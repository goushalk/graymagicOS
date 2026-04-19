#!/usr/bin/env bash

set -e

echo "==> Hyprland full system bootstrap"
echo "==> Arch-based systems only"
echo

# -------------------- Sanity checks --------------------
if ! command -v pacman &>/dev/null; then
  echo "[✗] pacman not found. Arch-based systems only."
  exit 1
fi

if ! command -v sudo &>/dev/null; then
  echo "[✗] sudo is required."
  exit 1
fi

# -------------------- Variables --------------------
DOTFILES_REPO="https://github.com/goushalk/dotfiles.git"
DOTFILES_DIR="$HOME/dotfiles"
BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"

CONFIG_DIRS=(
  hypr
  waybar
  wofi
  wlogout
  swaylock
  swaync
  waypaper
  mpvpaper
)

# -------------------- System update --------------------
echo "==> Updating system"
sudo pacman -Syu --noconfirm

# -------------------- Core packages --------------------
echo "==> Installing core packages"
sudo pacman -S --noconfirm --needed \
  hyprland \
  waybar \
  swaybg \
  mpv \
  wl-clipboard \
  grim \
  slurp \
  brightnessctl \
  pamixer \
  playerctl \
  xdg-desktop-portal-hyprland \
  qt5-wayland \
  qt6-wayland \
  rust \
  cargo \
  ttf-0xproto-nerd \
  eza \
  libnotify \
  zsh \
  neovim \
  unzip \
  git \
  curl \
  wget \
  stow \
  hyprpicker \
  gum \
  wiremix \
  btop \
  socat \
  tmux \
  xdg-desktop-portal-hyprland \
  hyprpolkitagent \
  hyprshot \
  swaync \
  power-profiles-daemon \
  nwg-displays \
  ripgrep

# -------------------- Install yay --------------------
if ! command -v yay &>/dev/null; then
  echo "==> Installing yay"
  sudo pacman -S --noconfirm --needed git base-devel
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  (cd /tmp/yay && makepkg -si --noconfirm)
  rm -rf /tmp/yay
fi

YAY_FLAGS="--noconfirm --needed --answerclean All --answerdiff None --removemake"

# -------------------- AUR packages --------------------
echo "==> Installing AUR packages"
yay -S $YAY_FLAGS \
  matugen-bin \
  wlogout \
  waypaper \
  mpvpaper \
  impala \
  bluetui \
  python-pywalfox \
  swaylock-effects \
  wl-clipboard \
  qt5-graphicaleffects \
  fuzzel \
  swayosd
  gtk-engine-murrine \
  thunar
# -------------------- Backup existing configs --------------------
echo "==> Backing up existing configs"
mkdir -p "$BACKUP_DIR"

for dir in "${CONFIG_DIRS[@]}"; do
  if [ -d "$HOME/.config/$dir" ]; then
    echo "  -> ~/.config/$dir"
    mv "$HOME/.config/$dir" "$BACKUP_DIR/"
  fi
done



# -------------------- Oh My Zsh --------------------
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "==> Installing Oh My Zsh"
  export RUNZSH=no
  export CHSH=no
  export KEEP_ZSHRC=yes
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# -------------------- .zsh backup --------------------

if [ -f "$HOME/.zshrc" ]; then
  echo "  -> ~/.zshrc"
  mv "$HOME/.zshrc" "$BACKUP_DIR/"
fi

# -------------------- Clone dotfiles --------------------
if [ ! -d "$DOTFILES_DIR" ]; then
  echo "==> Cloning dotfiles repository"
  git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
else
  echo "==> Dotfiles repo already exists, skipping clone"
fi


# -------------------- Stow dotfiles --------------------
echo "==> Stowing dotfiles"
cd "$DOTFILES_DIR"
stow */



# -------------------- Font cache --------------------
echo "==> Updating font cache"
fc-cache -fv

# -------------------- Done --------------------
echo
echo "==> Installation complete."
echo "==> Backups stored in: $BACKUP_DIR"
echo "==> Reboot recommended before starting Hyprland."
