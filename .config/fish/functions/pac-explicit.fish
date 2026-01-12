function pac-explicit
    set -l pkgs (pacman -Qettq)
    set -l base_pkgs (pacman -Sp --print-format="%D" base base-devel | string split " ")
    set -l explicits
    for p in $pkgs
        contains $p $base_pkgs $PACEXPLICIT_BLACKLIST && continue
        set -a explicits $p
    end
    if [ (count $explicits) -gt 0  ]
        string join \n $explicits
        return 0
    else
        return 1
    end
end
