function frename
    argparse --name='frename' 'a/all' 'i/ignore-case' 'I/non-interactive' 'n/dry-run' 'r/regex' 'v/verbose' -- $argv

    set -fq _flag_non-interactive || set -f _flag_interactive "--interactive"

    # validate input
    if [ ! (count $argv) -ge 3 ]
        echo "Required format: [OPTIONS] PATTERN REPLACEMENT FILE(S)"
        return 2
    end

    set -f pattern $argv[1]
    set -f replacement $argv[2]
    set -f file_list $argv[3..-1]
    # validate file input
    for file in $file_list
        if [ ! \( -f $file -o -d $file \) ]
            echo "$file is not a file or directory."
            return 2
        end
    end

    # do the renaming
    for file in $file_list
        set -l new_name (string replace $_flag_a $_flag_i $_flag_r -- $argv[1] $argv[2] "$file")
        if set -qf _flag_n
            echo "$file --> $new_name"
        else
            if [ "$file" != "$new_name" ]
                mv $_flag_v $_flag_interactive "$file" "$new_name"
            end
        end
    end
end
