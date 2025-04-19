function fish_user_key_bindings
    if status --is-interactive
        fzf_key_bindings
    end

    fish_hybrid_key_bindings
    
    # additional bindings that base fzf search in $MEDIA
    bind -M insert alt-shift-c 'commandline $MEDIA; and fzf-cd-widget'
    bind -M insert alt-t 'commandline -a $MEDIA; and fzf-file-widget'

    # history and completion bindings
    bind -M insert alt-k up-or-search
    bind -M insert alt-j down-or-search
    bind -M insert alt-l forward-bigword
    bind -M insert alt-space accept-autosuggestion

    # paste with single quotes around clipboard contents
    bind -M insert alt-ctrl-v 'commandline -i \\\'; and fish_clipboard_paste; and commandline -i \\\''

    # prepend/append commands by keypress
    bind -M insert alt-p __fish_pls_bind
    bind -M insert alt-a __fish_away_bind
    bind -M insert ctrl-shift-g __fish_lass_bind

    # better line editing
    bind -M insert ctrl-shift-q edit_command_buffer
    bind ctrl-shift-q edit_command_buffer

    # keybindings for path navigation
    bind -M insert alt-shift-h 'prevd; commandline -f repaint'
    bind -M insert alt-shift-l 'nextd; commandline -f repaint'
    bind -M insert alt-shift-k '__fish_cd_navigation up; commandline -f repaint'
    bind -M insert alt-shift-j '__fish_cd_navigation down; commandline -f repaint'
    bind -M insert alt-~ 'cd $HOME; commandline -f repaint'

    # create a directory from the current token
    bind -M insert alt-o 'mkdir -p (string replace -r \'^~\' $HOME -- (commandline -t))'

    # update history but keep commandline
    bind -M insert ctrl-shift-h 'history merge'

    # clear terminal screen
    bind -M insert ctrl-shift-x 'cls; commandline -f repaint'

    # toggle shadow mode
    bind -M insert alt-\? 'if set -q fish_private_mode; exec fish; else; exec fish --private; end'

    # unbind Ctrl+L for alacritty
    bind --erase -M insert --preset ctrl-shift-l
end
