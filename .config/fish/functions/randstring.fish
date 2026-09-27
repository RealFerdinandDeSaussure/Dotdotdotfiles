function randstring --description 'Generate a random string'
    argparse -n randstring 'l/length=!_validate_int' 'c/charset=' -- $argv || return 1
    set -fq _flag_length && set -f length $_flag_length || set -f length 25
    set -fq _flag_charset && set -f charset $_flag_charset || set -f charset '[:graph:]'

    set -lx LC_ALL C
    tr -dc "$charset" < /dev/urandom | read -fn $length randstring
    echo -n $randstring
end
