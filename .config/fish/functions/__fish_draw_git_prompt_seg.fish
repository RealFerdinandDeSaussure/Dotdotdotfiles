function __fish_draw_git_prompt_seg -a content
    set -l git_state (command git status --porcelain 2> /dev/null)
    if test -z "$git_state"
        __fish_draw_second_prompt_seg white ""$content
    else
        __fish_draw_second_prompt_seg magenta ""$content
    end
end
