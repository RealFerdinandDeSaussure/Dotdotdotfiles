function extr
    for arc in $argv
        set sheet (7z l -slt "$arc") || return 1
        printf "%s\n" -- $sheet | awk -F " = " '/^Path/ {print $2}' | tail -n+2 | cut -d/ -f1 | sort -u | count | read folders

        if [ "$folders" -gt 1 ]
            set f_name (string replace -r '\.[^.]+$' '' -- "$arc")
            mkdir "$f_name" || return 1
            7z x -o"$(realpath $f_name)" -- "$arc"
        else
            7z x -- "$arc"
        end
    end
end
