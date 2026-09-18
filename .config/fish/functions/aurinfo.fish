function aurinfo -a pkg -d "Get info from AUR for the provided package"
    argparse 'j/json' -- $argv
    test (count $argv) -ne 1 && return 1

    set pkg $argv[1]
    set date_fields FirstSubmitted LastModified
    set aur_rpc_info "https://aur.archlinux.org/rpc/v5/info?arg[]="
    set response (curl --silent --show-error "$aur_rpc_info$pkg") || return 1

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

    for l in (echo $response | jq -r '.results[0] | to_entries[] | .key + ":" + (.value | tostring)')
        set pair (string split -m1 ":" $l)
        set -a keys "$pair[1]"
        set -a values "$pair[2]"
    end

    set keys (string pad -r $keys)

    for i in (seq (count $keys))
        set_color -o; echo -n $keys[$i]; set_color normal
        echo -n ": "

        # treat date fields in a special way
        if contains (string trim $keys[$i]) $date_fields
            date -d "@$values[$i]" +%Y-%m-%d
        else if not set v (string trim -c "[]" -- "$values[$i]") # not an array
            echo "$v"
        else if set v (string split "," -- $v) # array with multiple elements
            set v (string trim -c \" $v)
            echo "- $v[1]"
            set width (string length "$keys[$i]")
            for i in $v[2..]
                printf "%*c  - %s\n" $width " " $i
            end
        else # array with one or zero elements
            string trim -c \" $v
        end
    end
end
