function randstring --description 'Generate a random string'
    # argparsing
    # function to validate input is int

    argparse -n randstring 'l/length=!_validate_int' 'c/charset=' 'x' -- $argv || return 1
    test -n "$_flag_l" && set -l length $_flag_l || set -l length 25
    test -n "$_flag_c" && set -l charset $_flag_c || set -l charset '[:graph:]'

    set -lx LC_ALL C
    tr -dc "$charset" < /dev/urandom | read -l -n $length randstring
    if [ -n "$_flag_x" ]
        sleep 2; xdotool type $randstring
    else
        echo -n $randstring
    end
end
