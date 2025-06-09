function __fish_create_second_prompt_seg
    set -l shell_pwd (basename (prompt_pwd))
    # if we're in a git repository display git prompt segment
    __fish_git_test
    switch $status
        case 0
            __fish_draw_git_prompt_seg "["(__fish_get_git_branch)"] $shell_pwd"
        case 1
            __fish_draw_second_prompt_seg green $shell_pwd
        case 2
            set -l default_branch (git config --get init.defaultbranch) || set -l default_branch master
            if test (__fish_get_git_branch) = "$default_branch"
                __fish_draw_git_prompt_seg " $shell_pwd"
            else 
                __fish_draw_git_prompt_seg "["(__fish_get_git_branch)"] $shell_pwd"
            end
    end
end
