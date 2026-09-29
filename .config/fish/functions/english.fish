function english -d "Run a command with an English locale set"
    set -fx LANG en_US.UTF-8
    set -fx LC C.UTF-8
    $argv
end
