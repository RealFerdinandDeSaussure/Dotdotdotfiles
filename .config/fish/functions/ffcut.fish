function ffcut
    argparse -n ffcut -N 1 -X 1 's/ss=' 't/to=' -- $argv
    test -f "$argv"
    and test -n "$_flag_s"
    and test -n "$_flag_t"
    or return 1
    
    set vbase (string replace -r '\.[^.]+$' '' -- (basename "$argv"))
    set vext (string match -r '[^.]+$' -- (basename "$argv"))
    set vpart1 (mktemp -u)".$vext"
    set vpart2 (mktemp -u)".$vext"
    set concat_file (mktemp)

    set vfname "$argv"
    while [ -f "$vfname" ]
        set vfname "$vbase-new.$vext"
    end

    printf 'file %s\n' "$vpart1" "$vpart2" > "$concat_file"
    ffmpeg -to "$_flag_s" -i "$argv" -c copy "$vpart1" || return 1
    ffmpeg -ss "$_flag_t" -i "$argv" -c copy "$vpart2" || return 1
    ffmpeg -f concat -safe 0 -i "$concat_file" -c copy $vfname || return 1
end
