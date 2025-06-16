set -g fish_greeting
set -g fish_default_variables_set
set -g fish_escape_delay_ms 10
set -g fish_function_path_local $HOME/.config/fish/functions

# set base16 derived color variables
for var in __BASE00 __BASE01 __BASE02 __BASE03 __BASE04 __BASE05 __BASE06 \
            __BASE07 __BASE08 __BASE09 __BASE0A __BASE0B __BASE0C __BASE0D \
            __BASE0E __BASE0F

    set -g {$var}_R (printf '%d' 0x(string sub -l 2 $$var))
    set -g {$var}_G (printf '%d' 0x(string sub -s 3 -l 2 $$var))
    set -g {$var}_B (printf '%d' 0x(string sub -s 5 -l 2 $$var))
end

# shell exclusive MEDIA variable
set -gx MEDIA "/run/media/$USER/"

# use nvim as a pager for man pages
set -gx MANPAGER "nvim +Man! "

# set folder for aurmake
set -gx AURMAKE_FOLDER ~/Downloads/AUR

set -g fish_color_normal white
set -g fish_color_command brwhite
set -g fish_color_quote $__BASE0B
set -g fish_color_redirection $__BASE0F
set -g fish_color_end brblue
set -g fish_color_error $__BASE08
set -g fish_color_param $__BASE04
set -g fish_color_comment $__BASE03
set -g fish_color_match $__BASE0E
set -g fish_color_selection --background=white
set -g fish_color_search_match --background=$__BASE02
set -g fish_color_operator yellow
set -g fish_color_escape bryellow
set -g fish_color_autosuggestion $__BASE03
set -g fish_color_cancel $__BASE0F

set -g fish_pager_color_prefix $__BASE08
set -g fish_pager_color_completion brwhite
set -g fish_pager_color_description normal
set -g fish_pager_color_progress $__BASE03
# no idea what this one does:
# set -g fish_pager_color_secondary
