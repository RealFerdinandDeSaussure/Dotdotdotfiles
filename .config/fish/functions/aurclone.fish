function aurclone
    argparse 'd/directory=' -- $argv
    test (count $argv) -eq 1 || return 1
    set -f pkg $argv[1]

    if [ -z "$(git ls-remote "https://aur.archlinux.org/$pkg.git")" ]
        echo "Package $pkg not found in AUR." >&2
        return 1
    end

    if set -fq _flag_directory
        git clone "https://aur.archlinux.org/$pkg.git" $_flag_directory || return 1
    else
        git clone "https://aur.archlinux.org/$pkg.git" || return 1
    end
end
