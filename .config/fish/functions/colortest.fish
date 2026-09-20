function colortest
    argparse 's/start=!_validate_int --min 0 --max 15' 't/to=!_validate_int --min 0 --max 15' -- $argv || return 1
    
    not set -q _flag_start && set _flag_start 0
    not set -q _flag_to && set _flag_to 15
    echo $_flag_start
    echo $_flag_to
    
    set width (seq "$_flag_start" "$_flag_to")

    for i in $width
        printf 'BASE0%X ' $i
    end

    for i in (seq 0 15)
        set fg __BASE0(printf '%X' $i)
        echo

        for k in $width
            set bg __BASE0(printf '%X' $k)
            set_color $$fg -b $$bg
            printf 'BASE0%X' $i
            set_color normal
            echo -n ' '
        end

        echo
    end
end
