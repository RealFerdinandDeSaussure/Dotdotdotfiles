function tryout -d "Run command in temporary HOME folder"
    set -f cmd (string escape -- $argv)
    set -fx HOME (mktemp -d)
    eval "$cmd"
end
