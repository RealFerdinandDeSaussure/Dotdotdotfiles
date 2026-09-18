function aurmake -w cower -d 'Build specified AUR package'
    for a in $argv
        if [ (string sub -l1 -- "$a") = "-" ]
            set -a makepkg_args $a
        else
            set -a pkg $a
        end
    end

    test (count $pkg) -eq 1 || return 1

    set aur_rpc_info "https://aur.archlinux.org/rpc/v5/info?arg[]="
    set response (curl --silent --show-error "$aur_rpc_info$pkg") || return 1
    set resultcount (echo "$response" | jq .resultcount) || return 1

    switch $resultcount
        case 0
            echo "Package $pkg not found in AUR." >&2
            return 1
        case 1
            :
        case '*'
            echo -e "More than one RPC result found for package $pkg.\nWhat's going on?"
            return 1
    end

    for dep in (echo "$response" | jq '.results[0].Depends.[]?')
        if pacman -Si $dep >/dev/null 2>&1
            set_color -o; echo "Package $dep not in pacman repos. Trying AUR..." >&2; set_color normal
            aurmake $dep || return 1
        end
    end

    set build_dir (mktemp -d)
    set orig_dir (pwd)
    set pkg_base (echo "$response" | jq -r '.results[0].PackageBase')

    cd $build_dir
    aurclone -d "build_$pkg" $pkg_base || return 1
    cd "build_$pkg"

    # determine install target
    set future_pkgs (makepkg --packagelist) || return 1
    # get index of correct target in $future_pkgs
    set i (contains -i $pkg (printf "%s\n" $future_pkgs | path basename | string split -r -m3 -f1 -- "-")) || return 1
    set install_target $future_pkgs[$i]

    makepkg $makepkg_args -sr || return 1
    sudo pacman -U $install_target || return 1

    # only remove $build_dir if build was succesful, otherwise we might be able
    # to still use the contents of the directory
    cd $orig_dir
    rm -rf $build_dir || return 1
end
