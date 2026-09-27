function away -d 'Run a command and immediately disown it'
    set -f cmd (string escape -- $argv)
    fish -c "$cmd" >/dev/null 2>&1 &
    disown
end
