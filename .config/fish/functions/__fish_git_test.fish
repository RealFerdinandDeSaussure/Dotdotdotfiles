function __fish_git_test
    # no git prompt if in home repository unless we're in the base folder
    set -f git_toplevel (command git rev-parse --show-toplevel 2> /dev/null)
    if test "$git_toplevel" = $HOME
        if test (pwd) = $HOME
            return 2
        else
            return 1
        end
    else if command git rev-parse --is-inside-work-tree > /dev/null 2>&1
        return 0
    else
        return 1
    end
end
