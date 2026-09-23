function aursearch
    argparse 'b/browser' 'v/sort-by-votes' -- $argv
    test (count $argv) -eq 0 && return 1

    if set -q _flag_browser
        open "https://aur.archlinux.org/packages?O=0&K=$(string join + $argv)"
        return
    end

    set aur_rpc_search https://aur.archlinux.org/rpc/v5/search/
    set base_search $argv[1]
    set -e argv[1]

    set inst_pkgs (pacman -Qq)
    set response (curl --silent --show-error {$aur_rpc_search}{$base_search}?by=name-desc) || return 1
    if set -q _flag_sort_by_votes
        set results (echo $response | jq -r '.results | sort_by(.NumVotes)[]') || return 1
    else
        set results (echo $response | jq -r '.results[]') || return 1
    end

    set error (echo $response | jq -r '.error') || return 1
    if [ "$error" != "null" ]
        echo "$error"
        return 1
    end

    # drilling further down till we get the packages that match all search queries
    for query in $argv
        set results (echo $results | jq 'select(.Name, .Description | tostring | test("'"$query"'"))')
    end

    echo -n $results | jq --raw-output0 '[.Name, .Version, .NumVotes, .Description] | @tsv' | while read -z line
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
