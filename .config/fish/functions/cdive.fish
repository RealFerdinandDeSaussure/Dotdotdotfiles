function cdive -d 'Move up and down directories'
    if [ ! (count $argv) -eq 1 ]
        return 1
    end

    if [ "$argv" = "up" ]
        set -ga __fish_cd_navigation_stack (pwd)
        cd ..
    else if [ "$argv" = "down" -a (dirname "$__fish_cd_navigation_stack[-1]") = (pwd) ]
        cd $__fish_cd_navigation_stack[-1]
        set -e __fish_cd_navigation_stack[-1]
    else
        return 1
    end
end
