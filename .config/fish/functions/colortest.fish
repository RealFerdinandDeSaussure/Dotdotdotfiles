function colortest -d "Print an overview of all base16 colors set in the environment"
    # -s/--start: set a start value for a range of base16 colors to include
    # -t/--to: set an end value for a range of base16 colors to include
    argparse -n colortest 's/start=!_validate_int --min 0 --max 15' 't/to=!_validate_int --min 0 --max 15' -- $argv || return 1
    
    not set -fq _flag_start && set -f _flag_start 0
    not set -fq _flag_to && set -f _flag_to 15
    
    set -f width (seq $_flag_start $_flag_to)

    for i in $width
        printf 'BASE0%X ' $i
    end

    for i in (seq $_flag_start $_flag_to)
        set -l fg __BASE0(printf '%X' $i)
        echo

        for k in $width
            set -l bg __BASE0(printf '%X' $k)
            set_color $$fg -b $$bg
            printf 'BASE0%X' $i
            set_color normal
            echo -n ' '
        end

        echo
    end
end
