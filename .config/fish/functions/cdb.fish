function cdb -d "Browse through directory bookmarks."
    argparse -n cdb 'a/add' 'd/delete' -- $argv
    set bookmark_file "$__fish_user_data_dir/cdb_bookmarks"

    if set -q _flag_add
        # add bookmark
        for location in $argv
            echo $location >> "$bookmark_file"
        end
        return
    else if set -q _flag_delete
        # delete bookmark
        for location in $argv
            set line_num (awk -v line="$location" '$0 == line {print NR}' "$bookmark_file")
            test -z $line_num && echo "$location not in bookmark file." && return 1
            sed -i {$line_num}d "$bookmark_file"
        end
        return
    end

    # no bookmarks?
    test -f "$bookmark_file" || return 1
    test (stat --printf='%s' "$bookmark_file") -gt 0 || return 1

    cat "$bookmark_file" | \
        fzf --expect=ctrl-alt-m,return --with-nth -1 -d "/" +m --preview="if [ -e {} ]; then echo -e \"\e[1;37m\$(basename {})\e[0m\"; ls {}; else echo \"Directory doesn't exist.\"; fi" | \
        read -L exit_key directory
    if [ -e $directory ]
        cd $directory
    else
        return 1
    end

    [ "$exit_key" = "return" ] && cdp || true
end
