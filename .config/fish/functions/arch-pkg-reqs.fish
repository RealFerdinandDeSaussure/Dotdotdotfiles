function arch-pkg-reqs
    argparse 'q/query' 'i/install' -- "$argv"
    if [ -z "$_flag_q$_flag_v$_flag_i" ]
        echo "Mode must be set: --query/--install" >&2
        return 1
    end

    set pkg_file $HOME/.config/.packages
    test -f $pkg_file || return 1

    set new_file
    test -n "$_flag_install" && set i_pkgs

    while read line
        set -a new_file "$line"
        string match -qr -- '^\s*$' "$line" && continue
        string match -qr -- '^\s*#' "$line" && continue
        set pkg (string split -m1 -f1 : "$line")

        if [ -n "$_flag_install" ]
            pacman -Qq "$pkg" >/dev/null 2>&1 && continue
            if not pacman -Siq $pkg >/dev/null 2>&1
                echo "Package \"$pkg\" missing but not in pacman repos"
                continue
            end
            set -a i_pkgs $pkg
            continue
        end

        set query (string split -m1 -f2 : "$line")

        if [ -z "$query" ]
            set query $pkg
        else
            set query (string split , $query)
        end

        for q in query
            git grep -q "\b$query\b" -- ':!.config/.packages' && continue
            echo "$pkg not verified on system." >&2
        end
    end < $pkg_file

    if [ -n "$_flag_install" -a (count $i_pkgs) -ne 0 ]
        sudo pacman -S $i_pkgs
    end
end
