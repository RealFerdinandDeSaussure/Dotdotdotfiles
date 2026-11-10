function randstring -d 'Generate a random string'
    # -c/--charset: specify a tr-style array of allowed characters
    # -l/--length: set length of the generated string (default: 25)
    # -h/--help: show this help and exit
    argparse -n randstring 'c/charset=' 'l/length=!_validate_int' 'h/help' -- $argv || return 1

    if set -fq _flag_help
        funchelp (status function)
        return
    end

    set -fq _flag_length && set -f length $_flag_length || set -f length 25
    set -fq _flag_charset && set -f charset $_flag_charset || set -f charset '[[:graph:]]'

    set -lx LC_ALL C
    tr -dc "$charset" < /dev/urandom | read -fn $length randstring
    echo -n $randstring
end
