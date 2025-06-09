function __fish_chcol -a fg bg
    if test -n "$bg"
        set_color -b "$bg" "$fg"
    else
        set_color "$fg"
    end
end
