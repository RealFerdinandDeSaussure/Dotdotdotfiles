function aursearch
    argparse 'b/browser' 'v/sort-by-votes' -- $argv

    if set -q _flag_browser
        open "https://aur.archlinux.org/packages?O=0&K=$(string join + $argv)"
        return
    end

    set aur_rpc_search https://aur.archlinux.org/rpc/v5/search/
    set search_str (string join -- "%20" $argv)
    set jq_filter '.results'
    if set -q _flag_sort_by_votes
        set jq_filter $jq_filter' | sort_by(.NumVotes)[] | [.Name, .Version, .NumVotes, .Description] | @tsv'
    else
        set jq_filter $jq_filter'[] | [.Name, .Version, .NumVotes, .Description] | @tsv'
    end
    set inst_pkgs (pacman -Qq)

    set response (curl --silent --show-error {$aur_rpc_search}{$search_str}?by=name-desc) || return 1
    set error (echo $response | jq -r '.error')
    if [ "$error" != "null" ]
        echo "$error"
        return 1
    end

    echo -n $response | jq --raw-output0 $jq_filter | while read -z line
        set fields (string split \t $line)
        set_color -o magenta; echo -n aur/
        set_color -f normal; echo -n $fields[1]
        set_color green; echo -n " $fields[2]"
        if contains $fields[1] $inst_pkgs
            set_color cyan; echo -n " [$(_ installed)]"
        end
        set_color normal; echo -n " ($fields[3])"
        set_color normal; echo \n"    $fields[4]"
    end
end
