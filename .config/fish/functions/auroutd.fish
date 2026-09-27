function auroutd
    argparse 'g/no-git' 'v/verbose' -- $argv
    set -f aur_rpc_info "https://aur.archlinux.org/rpc/v5/info?arg[]="
    set -f pkgs (pacman --color=never -Qm)
    set -fq _flag_no_git && set pkgs (string match -v -- '*-git *' $pkgs)

    for pkg in $pkgs
        echo $pkg | read -l pkg ver
        curl --silent --show-error {$aur_rpc_info}$pkg | jq -r '.results[0].Version' | read -l remote_ver
        test $pipestatus[1] -ne 0 && return 1
        set -fq _flag_verbose && echo "$pkg $ver <> $remote_ver"
        test "$remote_ver" = "null" && continue
        test "$remote_ver" = "$ver" && continue
        echo -n "$pkg "; set_color -o red; echo -n $ver; set_color -f normal; echo -n " => "; set_color green; echo "$remote_ver"; set_color normal
    end
end
