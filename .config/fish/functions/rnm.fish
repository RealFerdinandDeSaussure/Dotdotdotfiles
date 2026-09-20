function rnm
    argparse 'n/dry-run' -- $argv
    set rnm_file (mktemp)
    set file_error 0

    for file in $argv
        if [ ! -f "$file" -a ! -d "$file" ]
            echo "No file $file."
            set file_error 1
        else
            echo "$file" >> "$rnm_file"
        end
    end

    if [ $file_error -eq 0 ]
        $EDITOR "$rnm_file"

        if [ ! (wc -l "$rnm_file" | cut -f1 -d\ ) -eq (count $argv) ]
            echo "Number of file names changed."
            rm $rnm_file
            return 1
        end

        set line_num 1
        while read -l new_fname
            set fname "$argv[$line_num]"
            set line_num (math $line_num + 1)

            if set -q _flag_dry_run
                echo "$fname --> $new_fname"
            else if [ "$fname" = "$new_fname" ]
                :
            else if [ -f "$new_fname" ]
                echo "File \"$new_fname\" already exists. Skipping..."
            else
                mv -vn -- "$fname" "$new_fname"
            end

        end < $rnm_file
    end

    rm $rnm_file
    return $file_error
end
