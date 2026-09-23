function aurinfo -a pkg -d "Get info from AUR for the provided package"
    argparse 'j/json' -- $argv
    test (count $argv) -ne 1 && return 1

    set pkg $argv[1]
    set date_fields FirstSubmitted LastModified
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

    set keys Package
    set values $pkg

    for l in (echo $response | jq -r '.results[0] |
        to_entries[] |
        [.key, if (.value | type) == "array" then (.value | @tsv) else (.value | tostring) end] |
        join(":")')
        set pair (string split -m1 ":" $l)
        set -a keys "$pair[1]"
        set -a values "$pair[2]"
    end

    set keys (string pad -r $keys)

    for i in (seq (count $keys))
        set k $keys[$i]
        set v (string split -- \t $values[$i])
        set_color -o; echo -n $k; set_color normal
        echo -n ": "

        # treat date fields in a special way
        if contains (string trim $k) $date_fields
            date -d "@$v" +%Y-%m-%d
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
