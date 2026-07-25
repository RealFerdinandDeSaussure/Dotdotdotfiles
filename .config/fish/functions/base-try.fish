function base-try -a yaml_file -d "Set the shell's base16 variables according to the yaml file at the provided address"
    curl -LJ $yaml_file | string replace -rf '^\s*(base..):\s*\"\#([^\"]+).+' '\0\U__$1\E\n$2' | while read -z line
        test -z "$line" && continue
        set parts (string split \n $line)
        echo {$parts[1]}={$parts[2]}
        set -x $parts[1] $parts[2]
    end
end
