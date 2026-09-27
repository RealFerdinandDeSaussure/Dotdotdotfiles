function __fish_pls_bind
    # operate either on the current commandline or the last history entry if the
    # current commandline is empty
    set -l cmdln_old (commandline)
    if [ $cmdln_old = '' ]
        set cmdln_old $history[1]
    end

    # if the selected entry already has the keyword prefixed, don't do any
    # further modification
    if [ ! (string sub -l 5 -- "$cmdln_old") = "sudo " ]
        set -l cmdln_new 'sudo '"$cmdln_old"
        commandline -r $cmdln_new
    else
        commandline -r $cmdln_old
    end

    commandline -f execute
end
