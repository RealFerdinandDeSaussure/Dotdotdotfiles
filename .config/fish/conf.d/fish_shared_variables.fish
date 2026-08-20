# the variable definitions in this file are automatically copied over to
# ~/.config/environment.d/profile.conf, which uses slightly different quoting
# and variable expansion rules than sh

# define PATHs
set -x GOPATH {$HOME}/.local/share/go
set -x WINEPREFIX {$HOME}/.local/share/wine
set -x MAILDIR {$HOME}/.local/share/mail
set -x PYTHONPYCACHEPREFIX {$HOME}/.cache/python
fish_add_path --path {$HOME}/.local/bin {$GOPATH}/bin
fish_add_path ~/bin

# use systemd service for ssh-agent
set -x SSH_AUTH_SOCK {$XDG_RUNTIME_DIR}/ssh-agent.socket

# define default applications with some common variables
set -x EDITOR nvim
set -x TERMINAL footclient
set -x BROWSER qutebrowser

# define style for QT applications
set -x QT_STYLE_OVERRIDE adwaita

# set Java options
set -x JDK_JAVA_OPTIONS "-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel"

# setup fcitx as default input method for all applications
set -x XMODIFIERS @im=fcitx
set -x QT_IM_MODULE fcitx
set -x QT_IM_MODULES "wayland;fcitx"

# define file locations for some programs by environment variable
set -x GNUPGHOME {$HOME}/.config/gnupg
set -x HISTFILE {$HOME}/.local/share/.bash_history
set -x LESSHISTFILE {$HOME}/.local/share/.lesshst
set -x PASSWORD_STORE_DIR {$HOME}/.local/share/.password-store
set -x ANSIBLE_CONFIG {$HOME}/.config/ansible

# setup application settings
set -x WINEARCH win32
set -x PASSWORD_STORE_ENABLE_EXTENSIONS true

# setup base16 colors as environment variables
set -x __BASE00 32302f
set -x __BASE01 3c3836
set -x __BASE02 504945
set -x __BASE03 665c54
set -x __BASE04 bdae93
set -x __BASE05 d5c4a1
set -x __BASE06 ebdbb2
set -x __BASE07 fbf1c7
set -x __BASE08 fb4934
set -x __BASE09 fe8019
set -x __BASE0A fabd2f
set -x __BASE0B b8bb26
set -x __BASE0C 8ec07c
set -x __BASE0D 83a598
set -x __BASE0E d3869b
set -x __BASE0F d65d0e

# setup font settings
set -x FONT_SANS "Space Grotesk"
set -x FONT_SERIF Fraunces
set -x FONT_MONO "Iosevka Nerd Font"
set -x FONT_TERMINAL "Iosevka Nerd Font"

# set FZF options
set -x FZF_DEFAULT_OPTS "--height 60% --border \
--color=bg+:-1,bg:-1,spinner:#$__BASE0C,hl:#$__BASE0D,hl+:#$__BASE0D,fg:#$__BASE04,fg+:#$__BASE07 \
--color=header:#$__BASE0D,info:#$__BASE0A,pointer:#$__BASE0C,marker:#$__BASE0C,prompt:#$__BASE09 \
--bind=alt-j:down,alt-k:up,alt-\<:first,alt-\>:last --reverse"

set -x FZF_DEFAULT_COMMAND "/usr/bin/find -P \$dir -mindepth 1 \( -regex '\.?/snp' -o -path '*/Steam' -o -path '*/.cache' -o -path '*/.git' \) -prune -o -print 2>/dev/null"
set -x FZF_OVERLAY_OPTS "--no-border --margin 10%,8% --no-height --layout reverse-list"
set -x FZF_ALT_C_COMMAND $FZF_DEFAULT_COMMAND
set -x FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
 
# shell exclusive MEDIA variable
set -x MEDIA "/run/media/$USER/"

# use nvim as a pager for man pages
set -x MANPAGER "nvim +Man! "

# fish customization
set fish_greeting
set fish_default_variables_set
set fish_escape_delay_ms 10
set fish_function_path_local $HOME/.config/fish/functions

# default color
set fish_color_normal --reset
# commands like echo
set fish_color_command $__BASE07
# builtin commands like cd and set - this falls back on the command color if unset
# set fish_color_builtin
# user-defined functions - this falls back on the command color if unset
set fish_color_function $__BASE07 -udotted --underline-color=$__BASE03
# keywords like if - this falls back on the command color if unset
set fish_color_keyword $__BASE09
# quoted text like abc
set fish_color_quote $__BASE0B
# IO redirections like >/dev/null
set fish_color_redirection $__BASE0C --bold
# process separators like ; and &
set fish_color_end $__BASE0E
# syntax errors
set fish_color_error $__BASE08
# ordinary command parameters
set fish_color_param --reset
# parameters and redirection targets that are filenames (if the file exists)
set fish_color_valid_path --underline
# options starting with “-”, up to the first “--” parameter
set fish_color_option $__BASE0D
# comments like ‘# important’
set fish_color_comment --dim
# selected text in vi visual mode
set fish_color_selection --reverse
# parameter expansion operators like * and ~
set fish_color_operator $__BASE0A
# character escapes like \n and \x70
set fish_color_escape $__BASE0F
# autosuggestions (the proposed rest of a command)
set fish_color_autosuggestion $__BASE03
# the ‘^C’ indicator on a canceled command
set fish_color_cancel $__BASE08
# history search matches and selected pager items (background only)
set fish_color_search_match $__BASE07 --italics --bold --background=brblack
# the current position in the history for commands like dirh and cdh
set fish_color_history_current -ucurly --underline-color=$__BASE03 --bold

# the progress bar at the bottom left corner
set fish_pager_color_progress $__BASE02 --background=$__BASE05 --bold
# the background color of a line
set fish_pager_color_background
# the prefix string, i.e. the string that is to be completed
set fish_pager_color_prefix --bold --underline
# the completion itself, i.e. the proposed rest of the string
set fish_pager_color_completion --reset
# the completion description
set fish_pager_color_description $__BASE0A --italics
# background of the selected completion
set fish_pager_color_selected_backgroud $__BASE06
# prefix of the selected completion
# set fish_pager_color_selected_prefix
# suffix of the selected completion
# set fish_pager_color_selected_competion 
# description of the selected completion
set fish_pager_color_selected_description --reset
# # background of every second unselected completion
# set fish_pager_color_secondary_background $__BASE07
# # prefix of every second unselected completion
# set fish_pager_color_secondary_prefix
# # suffix of every second unselected completion
# set fish_pager_color_secondary_completion
# # description of every second unselected completion
# set fish_pager_color_secondary_description
