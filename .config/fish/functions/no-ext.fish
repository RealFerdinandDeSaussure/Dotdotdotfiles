function no-ext --description "Remove extension from filename"
    if isatty stdin
        set in $argv
    else
        cat - | read in
    end
    string split -r -m1 -f1 "." $in
end
