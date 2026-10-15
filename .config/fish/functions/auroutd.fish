function auroutd -d "List outdated AUR packages"
    # -g/--no-git: don't check packages with names ending in -git
    # -v/--verbose: print packages even if they are up-to-date
    # -q/--quiet: only print outdated package names without any version
    #             information
    argparse -n auroutd 'g/no-git' 'v/verbose' 'q/quiet' -- $argv
    set -f aur_rpc_info "https://aur.archlinux.org/rpc/v5/info?arg[]="
    set -f pkgs (pacman --color=never -Qm)
    set -fq _flag_no_git && set pkgs (string match -v -- '*-git *' $pkgs)

    for pkg in $pkgs
        echo $pkg | read -l pkg ver
        curl --silent --show-error {$aur_rpc_info}$pkg | jq -r '.results[0].Version' | read -l remote_ver
        test $pipestatus[1] -ne 0 && return 1

        # print up-to-date packages if -v was passed
        if set -fq _flag_verbose
            echo -n "$pkg"
            not set -fq _flag_quiet && echo -n " $ver==$remote_ver"
            echo -n \n
        end

        test "$remote_ver" = "null" && continue
        test "$remote_ver" = "$ver" && continue
        # delete previous line in verbose mode if there actually is an update
        set -fq _flag_verbose && echo -ne '\e[1A\e[K'

        # print outdated packages
        echo -n "$pkg"
        if not set -fq _flag_quiet
            set_color -o red; echo -n " $ver"; set_color -f normal; echo -n "=>"; set_color green; echo -n "$remote_ver"; set_color normal
        end
        echo -n \n
    end
end
