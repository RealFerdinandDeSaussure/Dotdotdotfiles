function randstring --description 'Generate a random string'
    # argparsing
    # function to validate input is int

    argparse -n randstring 'l/length=!_validate_int' 'c/charset=' -- $argv || return 1
    set -q _flag_length && set -l length $_flag_length || set -l length 25
    set -q _flag_charset && set -l charset $_flag_charset || set -l charset '[:graph:]'

    set -lx LC_ALL C
    tr -dc "$charset" < /dev/urandom | read -l -n $length randstring
    echo -n $randstring
end
