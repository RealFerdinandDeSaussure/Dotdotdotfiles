function printfiles --description "Short-hand for printing a list of files separated by newline with printf"
    if [ -n "$argv" ]
        printf "%s\n" $argv/*
    else
        printf "%s\n" *
    end
end
