function aurmake -w cower -d 'Build specified AUR package'
    set pkgs (string match -r '(?<!\x2d)\b\S+' -- $argv)
    set args (string match -r '(?<!\S)\x2d(\x2d)?\S+' -- $argv)

    # building packages
    for pkg in $pkgs
        set dep_list (auracle buildorder $pkg); or return 1

        for dep in (string join \n $dep_list | awk '$1 == "AUR" {rc=1; print $NF}; END {exit !rc}')
            if not contains $dep $aur_deps
                set -a aur_deps $dep
            end
        end

        # building AUR dependencies
        for dep in $aur_deps
            set_color -o && echo "Building dependency $dep for package $pkg..." && set_color normal
            __aurmake_single --asdeps $dep
            or return 1
        end

        # building the target package
        __aurmake_single $args $pkg
        or return 1

    end

    # finding no longer needed build dependencies...
    set orphans (pacman -Qdtq)
    for dep in $aur_deps
        if contains $dep $orphans
            set -a del_deps $dep
        end
    end

    # ...and removing them
    if [ -n "$del_deps" ]
        set_color -o && echo "Removing build dependencies installed from AUR..." && set_color normal
        sudo pacman -Rsc $del_deps
    end
end
