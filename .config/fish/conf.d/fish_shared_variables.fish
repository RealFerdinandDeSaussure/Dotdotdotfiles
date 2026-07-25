set -g fish_greeting
set -g fish_default_variables_set
set -g fish_escape_delay_ms 10
set -g fish_function_path_local $HOME/.config/fish/functions

# shell exclusive MEDIA variable
set -gx MEDIA "/run/media/$USER/"

# use nvim as a pager for man pages
set -gx MANPAGER "nvim +Man! "

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
