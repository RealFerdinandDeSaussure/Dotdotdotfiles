function arch-pkg-reqs
    argparse 'q/query' 'i/install' -- "$argv"
    if [ -z "$_flag_q$_flag_v$_flag_i" ]
        echo "Mode must be set: --query/--install" >&2
        return 1
    end

    set pkg_file $HOME/.config/.packages
    test -f $pkg_file || return 1

    set new_file

    while read line
        set -a new_file "$line"
        string match -qr -- '^\s*$' "$line" && continue
        string match -qr -- '^\s*#' "$line" && continue
        set pkg (string split -m1 -f1 : "$line")
        pacman -Qq "$pkg" >/dev/null 2>&1 && set on_system "$pkg"

        if set -q _flag_install
            test "$pkg" = "$on_system" && continue
            if not pacman -Siq $pkg >/dev/null 2>&1
                test (count _flag_install -eq 1) && echo "Package \"$pkg\" missing but not in pacman repos
Supply the i flag twice to install the package with aurmake." >&2
            test (count _flag_install -eq 2) && set -a aur_i_pkgs $pkg
            continue
            end
            set -a i_pkgs $pkg
            continue
        else if set -q _flag_query 
            test "$pkg" != "$on_system" && echo "$pkg not installed on system." >&2
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
        end
    end < $pkg_file

    if [ (count $i_pkgs) -ne 0 ]
        sudo pacman -S $i_pkgs
    end

    if [ (count $aur_i_pkgs) -ne 0 ]
        for p in $aur_i_pkgs
            aurmake $p
        end
    end
end
