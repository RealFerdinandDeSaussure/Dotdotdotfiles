function fftrim
    argparse -n fftrim -x 'l,r' -x 'l,s' -x 'r,t' -N 1 -X 1 'l/left' 'r/right' 's/ss=' 't/to=' -- $argv
    test -f "$argv" || return 1

    set vbase (string replace -r '\.[^.]+$' '' -- (basename "$argv"))
    set vext (string match -r '[^.]+$' -- (basename "$argv"))

    if set -q _flag_left && set -q _flag_to
        ffmpeg -i "$argv" -ss "$_flag_to" -c copy "$vbase""_end"".$vext"
    else if set -q _flag_right && set -q _flag_ss
        ffmpeg -i "$argv" -to "$_flag_ss" -c copy "$vbase""_start"".$vext"
    else
        return 1
    end
end
