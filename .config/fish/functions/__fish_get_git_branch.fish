function __fish_get_git_branch
    set -l git_branch (command git rev-parse --abbrev-ref HEAD 2> /dev/null)
    test "$git_branch" = "HEAD" && set git_branch "…"
    echo $git_branch
end
