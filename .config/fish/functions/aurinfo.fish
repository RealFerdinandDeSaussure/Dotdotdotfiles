function aurinfo -a pkg -d "Get info from AUR for the provided package"
    argparse j/json -- $argv
    test (count $argv) -ne 1 && return 1

    set pr_keys Name Description Version Keywords URL \
        Depends MakeDepends CheckDepends \
        LastModified OutOfDate License Maintainer Submitter \
        Popularity NumVotes
    set pr_values
    for none in (seq (count $pr_keys))
        set pr_values ""
    end

    set pkg $argv[1]
    set date_fields FirstSubmitted LastModified OutOfDate
    set aur_rpc_info "https://aur.archlinux.org/rpc/v5/info?arg[]="
    set response (curl --silent --show-error {$aur_rpc_info}$pkg) || return 1

    if [ (echo $response | jq '.resultcount') -ne 1 ]
        echo "Package $pkg not found in AUR." >&2
        return 1
    end

    if set -q _flag_json
        echo $response | jq .
        return
    end

    for l in (echo $response | jq -r '.results[0] |
        to_entries[] |
        [.key, if (.value | type) == "array" then (.value | @tsv) else (.value | tostring) end] |
        join(":")')
        set pair (string split -m1 ":" $l)

        if set -l i (contains -i $pair[1] $pr_keys)
            set pr_values[$i] "$pair[2]"
        end
    end

    set pr_keys (string pad -r $pr_keys" ")

    for i in (seq (count $pr_keys))
        set k $pr_keys[$i]
        set v (string split -- \t $pr_values[$i])
        set_color -o; echo -n $k; set_color normal
        echo -n ": "

        if [ "$v" = "null" ]
            echo "-"
        # treat date fields in a special way
        else if contains (string trim $k) $date_fields
            date -d "@$v" +%Y-%m-%d 2>/dev/null
        # special formatting if $v is (was) a multi-entry array
        else if [ (count $v) -gt 1 ]
            echo "- $v[1]"
            set width (string length "$k")
            for i in $v[2..]
                printf "%*c  - %s\n" $width " " $i
            end
        # all other values are just printed as-is
        else
            echo "$v"
        end
    end
end
