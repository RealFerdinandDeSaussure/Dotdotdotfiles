function ffcut
    argparse -n ffcut -N 1 -X 1 's/ss=' 't/to=' -- $argv
    test -f "$argv"
    and set -fq _flag_ss
    and set -fq _flag_to
    or return 1
    
    set -f vbase (string replace -r '\.[^.]+$' '' -- (basename "$argv"))
    set -f vext (string match -r '[^.]+$' -- (basename "$argv"))
    set -f vpart1 (mktemp -u)".$vext"
    set -f vpart2 (mktemp -u)".$vext"
    set -f concat_file (mktemp)

    set -f vfname "$argv"
    while [ -f "$vfname" ]
        set vfname "$vbase-new.$vext"
    end

    printf 'file %s\n' "$vpart1" "$vpart2" > "$concat_file"
    ffmpeg -to "$_flag_ss" -i "$argv" -c copy "$vpart1" || return 1
    ffmpeg -ss "$_flag_to" -i "$argv" -c copy "$vpart2" || return 1
    ffmpeg -f concat -safe 0 -i "$concat_file" -c copy $vfname || return 1
end
