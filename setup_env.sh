#!/bin/sh
YELLOW=`tput setaf 3`
GREEN=`tput setaf 2`
BLUE=`tput setaf 6`
RED=`tput setaf 1`
BOLD=`tput bold`
RESET=`tput sgr0`

TAB_SIZE='  '

GITHUB_SOURCE_URL='https://raw.githubusercontent.com/bastantoine/dotenv/master'

echo_color () {
    color=$1
    msg=$2
    echo "${color}${msg}${RESET}"
}

echo_done () {
    echo_color $GREEN "${TAB_SIZE}Done!"
}

echo_skip () {
    echo_color $BLUE "${TAB_SIZE}${1} - Skipping"
}

echo_section () {
    echo_color $YELLOW "[ $1 ]"
}

download_file_from_github () {
    echo_color $BLUE "${TAB_SIZE}Downloading $1 to $2"
    url=$GITHUB_SOURCE_URL/$1
    curl -s -L -o $2 $url
}

download_conf_file_from_github () {
    download_file_from_github conf/$1 $2
}

backup_file () {
    if [ -f $1 ]; then
        target=$1.bak-pre-autosetup
        echo_color $BLUE "${TAB_SIZE}Backing up $1 to $1.bak-pre-autosetup"
        mv $1 $target
    fi
}

get_system_package_manager () {
    # Install a given dependency using the system integrated package manager.
    # For now the script will be running on either macOS with brew or Debian
    # with apt, so a simply test should be enough to know which package manager
    # to use.
    if ! which apt >/dev/null 2>&1; then
        echo 'brew'
    else
        echo 'apt-get'
    fi
}

install_system_dep () {
    # Install a given dependency using the system integrated package manager.
    # For now the script will be running on either macOS with brew or Debian
    # with apt, so a simply test should be enough to know which package manager
    # to use.
    echo_color $BLUE "${TAB_SIZE}Installing $1${RESET}"
    sudo $(get_system_package_manager) install -y $1
    echo_done
}

check_if_dep_installed () {
    # Check if a given dependency is installed. Using which is probably not the
    # safest, but by far the easiest way for now.
    if ! which $1 >/dev/null 2>&1; then
        return 1
    fi
}

############

if [ `whoami` != 'vagrant' ]; then
    echo_color $RED "For safety reasons, this script must be run inside a vagrant powered VM.\nExiting"
    exit 1
fi

cat <<-EOF
${BOLD}
┌─────────────────────────────┐
│                             │
│   Setting up environment... │
│                             │
└─────────────────────────────┘
${RESET}
EOF

echo_section "Updating system dependencies list"
sudo $(get_system_package_manager) update
echo_done

echo_section "Installing system dependencies"
deps_to_install=''
for dep in 'git' 'fzf' 'vim' 'tmux' 'curl' 'zsh'; do
    if check_if_dep_installed $dep; then
        echo_skip "$dep already installed"
    else
        deps_to_install="$dep $deps_to_install"
    fi
done
install_system_dep "$deps_to_install"
echo_done

user=$(whoami)
echo_section "Changing default shell to zsh for user $user"
# Set zsh as shell for default user
zsh_location=$(which zsh)
if [ "$SHELL" != $zsh_location ] 2>/dev/null; then
    sudo chsh -s $(which zsh) $user
    echo_done
else
    echo_skip 'Shell already set to zsh'
fi

# Install oh-my-zsh
echo_section "Installing Oh My ZSH"
sh -s -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" -- --unattended
backup_file ~/.zshrc
download_conf_file_from_github 'zshrc' ~/.zshrc
echo_done

# Install oh-my-zsh plugins
echo_section "Installing Oh My ZSH plugins"
for plugin in 'zsh-autosuggestions' 'zsh-syntax-highlighting'; do
    target=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/$plugin
    if [ ! -d $target ]; then
        echo_color $BLUE "${TAB_SIZE}Downloading plugin $plugin"
        git clone --quiet https://github.com/zsh-users/$plugin $target
        echo_done
    else
        echo_skip "Plugin $plugin already installed"
    fi
done

# Install Powerlevel10K
echo_section "Installing Powerlevel10K theme"
target=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
if [ ! -d $target ]; then
    git clone --quiet https://github.com/romkatv/powerlevel10k.git $target
    # We need to make sure the theme is installed before we enable it in the zshrc
    sed -i 's/ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/g' ~/.zshrc
    backup_file ~/.p10k.zsh
    download_conf_file_from_github 'p10k.zsh' ~/.p10k.zsh
    echo_done
else
    echo_skip "Theme Powerlevel10K already installed"
fi

# Tmux
echo_section "Getting tmux conf file"
backup_file ~/.tmux.conf
download_conf_file_from_github 'tmux.conf' ~/.tmux.conf
echo_done

# Vim
echo_section "Getting vim conf file"
backup_file ~/.vimrc
download_conf_file_from_github 'vimrc' ~/.vimrc
echo_done

cat <<-EOF
${BOLD}
┌────────────────────────────────────────────┐
│                                            │
│         DONE ! You're all set!             │
│  Logout and login again to apply changes.  │
│                                            │
└────────────────────────────────────────────┘
${RESET}
EOF
