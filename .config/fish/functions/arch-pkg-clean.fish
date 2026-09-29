function arch-pkg-clean -d "Remove all but the most recent packages from the Arch package cache"
    # -d/--directory: path to a directory containing pacman packages to monitor,
    #                 can be specified more than once; by default all
    #                 directories in /var/cache/pacman will be checked
    # -i/--interactive: prompt before deleting
    # -k/--keep: number of most recent packages to retain, must be an integer
    # -v/--verbose: print all remove operations
    argparse -n arch-pkg-clean 'd/directory=*' 'i/interactive' 'k/keep=!_validate_int --min 1' 'v/verbose' -- $argv
    set -fq _flag_keep || set -f _flag_keep 3
    set -fq _flag_directory || set -f _flag_directory /var/cache/pacman/*
    set keep -f -$_flag_keep

    for d in $_flag_directory
        test -d $d || continue

        for f in (string split -r -m3 -f1 -- "-" $d/* | sort -u)
            set -l versions (string match -gr '('$f'(?:-[^\-]+){3}.pkg)' $f* | sort -uV)
            test (count $versions) -le $_flag_keep && continue

            # for interactive mode we need to retain the files we're gonna keep
            # to print them to the terminal
            set -fq _flag_interactive && set -l keepers $versions[$keep..]
            set -e versions[$keep..]

            if set -fq _flag_interactive
                set -l answer
                while [ "$answer" != "y" -o "$answer" != "n" ]
                    printf "-> %s\n" $versions*
                    printf "   %s\n" $keepers*
                    read -l -n1 -p 'set_color -o; echo -n "Delete the marked files? "; set_color normal; echo -n "[y/n] "' answer || return 1

                    if [ "$answer" = "y" ]
                        sudo rm $_flag_verbose $versions* || return 1
                        break
                    else if [ "$answer" = "n" ]
                        break
                    end
                end
            else
                sudo rm $_flag_verbose $versions* || return 1
            end

        end
    end
end
