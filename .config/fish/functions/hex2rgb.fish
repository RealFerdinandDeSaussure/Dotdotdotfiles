function hex2rgb -d "Convert hex color descriptions to their RGB equivalents"
    # -r: print only the value for red
    # -g: print only the value for green
    # -b: print only the value for blue
    argparse -n hex2rgb -x 'r,g,b' 'r' 'g' 'b' -- $argv || return 1
    test (count $argv) -eq 1 || return 1
    test (string length $argv) -eq 6 || return 1

    switch $argv_opts
        case -r
            printf '%d' 0x(string sub -l 2 "$argv")
        case -g
            printf '%d' 0x(string sub -s 3 -l 2 "$argv")
        case -b
            printf '%d' 0x(string sub -s 5 -l 2 "$argv")
        case '*'
            printf '%d,' 0x(string sub -l 2 "$argv") 0x(string sub -s 3 -l 2 "$argv") 0x(string sub -s 5 -l 2 "$argv") | string trim -c,
    end
end
