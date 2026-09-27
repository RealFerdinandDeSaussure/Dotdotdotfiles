function __fish_modify_commandline
    argparse 'c/command=' 'p/prefix=' 's/suffix=' -- $argv
    set -fq _flag_command || return 1

    set -f cmd $_flag_command
    set -fq _flag_prefix && set -f prefixlen1 (math (string length -- "$_flag_prefix") + 1)
    set -f exc_cmdline (string trim -- (status current-commandline))
    set -f cmdline (string trim -- (commandline))

    if [ "$exc_cmdline" = "$cmd" ] || [ -z "$cmdline" ]
        set -l i 1
        while true
            # we need to make sure there is no $cmd in the previous command,
            # otherwise we're going to enter an infinite loop
            string match -rq -- '(^|\|)\s*'$cmd'\b' "$history[$i]" || break
            set i (math $i + 1)
        end
        set cmdline "$history[$i]"
    else
        return 1
    end

    if set -fq _flag_prefix
        test "$(string sub -l $prefixlen1 -- "$cmdline")" = "$_flag_prefix " || set -p cmdline $_flag_prefix
    end
    if set -fq _flag_suffix
        string match -rq -- '\s+\|\s+'$_flag_suffix'$' -- "$cmdline" || set -a cmdline "|" $_flag_suffix
    end

    if [ -n "$exc_cmdline" ]
        eval "$cmdline"
    else
        commandline -r "$cmdline"
        commandline -f execute
    end
end
