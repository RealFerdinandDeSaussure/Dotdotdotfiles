# the variable definitions in this file are automatically copied over to
# ~/.config/environment.d/profile.conf, which uses slightly different quoting
# and variable expansion rules than sh

# define PATHs
export GOPATH=${HOME}/.local/share/go
export PATH=${HOME}/.local/bin:${GOPATH}/bin:${PATH}
export WINEPREFIX=${HOME}/.local/share/wine
export MAILDIR=${HOME}/.local/share/mail
export PYTHONPYCACHEPREFIX=${HOME}/.cache/python

# use systemd service for ssh-agent
export SSH_AUTH_SOCK=${XDG_RUNTIME_DIR}/ssh-agent.socket

# define default applications with some common variables
export EDITOR=nvim
export TERMINAL=footclient
export BROWSER=qutebrowser

# define style for QT applications
export QT_STYLE_OVERRIDE=adwaita

# set Java options
export JDK_JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel"

# setup fcitx as default input method for all applications
export XMODIFIERS=@im=fcitx
export QT_IM_MODULE=fcitx
export QT_IM_MODULES="wayland;fcitx"

# define file locations for some programs by environment variable
export GNUPGHOME=${HOME}/.config/gnupg
export HISTFILE=${HOME}/.local/share/.bash_history
export LESSHISTFILE=${HOME}/.local/share/.lesshst
export PASSWORD_STORE_DIR=${HOME}/.local/share/.password-store
export ANSIBLE_CONFIG=${HOME}/.config/ansible

# setup application settings
export WINEARCH=win32
export PASSWORD_STORE_ENABLE_EXTENSIONS=true

# setup base16 colors as environment variables
export __BASE00=32302f
export __BASE01=3c3836
export __BASE02=504945
export __BASE03=665c54
export __BASE04=bdae93
export __BASE05=d5c4a1
export __BASE06=ebdbb2
export __BASE07=fbf1c7
export __BASE08=fb4934
export __BASE09=fe8019
export __BASE0A=fabd2f
export __BASE0B=b8bb26
export __BASE0C=8ec07c
export __BASE0D=83a598
export __BASE0E=d3869b
export __BASE0F=d65d0e

# setup font settings
export FONT_SANS=Gidole
export FONT_SERIF=Merriweather
export FONT_MONO="Iosevka Nerd Font"
export FONT_TERMINAL="Iosevka Nerd Font"

# set FZF options
export FZF_DEFAULT_OPTS="\
--height 60% --border \
--color=bg+:-1,bg:-1,spinner:#${__BASE0C},hl:#${__BASE0D},hl+:#${__BASE0D},fg:#${__BASE04},fg+:#${__BASE07} \
--color=header:#${__BASE0D},info:#${__BASE0A},pointer:#${__BASE0C},marker:#${__BASE0C},prompt:#${__BASE09} \
--bind=alt-j:down,alt-k:up --reverse \
"
export FZF_DEFAULT_COMMAND="/usr/bin/find -P \$dir -mindepth 1 \( -regex '\.?/snp' -o -path '*/Steam' -o -path '*/.cache' -o -path '*/.git' \) -prune -o -print 2>/dev/null"
export FZF_OVERLAY_OPTS="--no-border --margin 10%,8% --no-height --layout reverse-list"
export FZF_ALT_C_COMMAND=$FZF_DEFAULT_COMMAND
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
 
test -f ${HOME}/.profile_local && source ${HOME}/.profile_local
