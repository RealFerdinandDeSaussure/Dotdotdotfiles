function passgen
    argparse -x 'diceware,randstring' 'd/diceware' 'r/randstring' -- $argv

    if [ -z "$argv" ]
        echo "Specify a password file name." >&2
        return 1
    end

    if [ -n "$_flag_randstring" ]
        set pass_in (randstring)
    else if [ -n "$_flag_diceware" ]
        set pass_in (diceware -d" " -w de) || return 1
    else
        echo "Please specify either --diceware or --randstring." >&2
        return 1
    end

    set counter 2
    echo "$(set_color -o)Enter line 1$(set_color normal): **************"
    while true
        read -P "$(set_color -o)Enter line $counter$(set_color normal): " input
        test -z "$input" && break
        set -a pass_in $input
        set counter (math $counter + 1)
    end
    printf "%s\n" $pass_in | pass insert -m $argv
end
