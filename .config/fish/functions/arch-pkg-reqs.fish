function arch-pkg-reqs
    if ! git -C $HOME rev-parse --is-inside-work-tree 2>/dev/null >&2
        echo "$HOME is not a git repository."
        return 1
    end

    argparse 'b/backquery' 'i/install' 'q/query' -- "$argv"
    if [ -z "$_flag_b$_flag_i$_flag_q" ]
        echo "Mode must be set: --query/--install" >&2
        return 1
    end

    set -f pkg_file $HOME/.config/.packages
    test -f $pkg_file || return 1
    set -fq _flag_backquery && set -f pkgs_on_system (pacman -Qetq)
    set -f i_pkgs
    set -f aur_i_pkgs

    while read line
        string match -qr -- '^\s*$' "$line" && continue
        string match -qr -- '^\s*#' "$line" && continue
        set -l pkg (string split -m1 -f1 : "$line")
        pacman -Qq "$pkg" >/dev/null 2>&1 && set -l on_system "$pkg"

        if set -qf _flag_install
            test "$pkg" = "$on_system" && continue
            if not pacman -Siq $pkg >/dev/null 2>&1
                test (count $_flag_install) -eq 1 && echo "Package \"$pkg\" missing but not in pacman repos
Supply the i flag twice to install the package with aurmake." >&2
                test (count $_flag_install) -eq 2 && set -a aur_i_pkgs $pkg
                continue
            end
            set -a i_pkgs $pkg
            continue
        else if set -q _flag_query 
            test "$pkg" != "$on_system" && echo "$pkg not installed on system." >&2
            set -l query (string split -m1 -f2 : "$line")

            if [ -z "$query" ]
                set -l query $pkg
            else
                set -l query (string split , $query)
            end

            for q in query
                git -C $HOME grep -q "\b$query\b" -- ':!.config/.packages' && continue
                echo "$pkg not verified on system." >&2
            end
        else if set -q _flag_backquery
            set -l i (contains -i $pkg $pkgs_on_system) || continue
            set -e pkgs_on_system[$i]
        end
    end < $pkg_file

    # handling of collected items
    if set -fq _flag_install
        test (count $i_pkgs) -ne 0 && sudo pacman -S $i_pkgs
        for p in $aur_i_pkgs
            aurmake $p || return 1
        end
    end

    if set -fq _flag_backquery
        printf "%s\n" $pkgs_on_system
    end
end
