function xtr -d "Extract an archive to a dedicated directory if it contains more than one file"
    for arc in $argv
        set -l sheet (7z l -slt "$arc") || return 1
        printf "%s\n" -- $sheet | awk -F " = " '/^Path/ {print $2}' | tail -n+2 | cut -d/ -f1 | sort -u | count | read -l folders

        if [ "$folders" -gt 1 ]
            set -l f_name (path basename -E -- "$arc")
            while [ -e $f_name ]
                set f_name {$f_name}_
            end
            mkdir "$f_name" || return 1
            7z x -o"$(realpath $f_name)" -- "$arc"
        else
            7z x -- "$arc"
        end
    end
end
