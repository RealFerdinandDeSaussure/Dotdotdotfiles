function imath -d "Use the math builtin interactively"
    set_color -o && echo -n "imath: " && set_color normal
    echo 'Type "exit" to quit.  "$$" will be replaced with the result of the previous operation.'

    set -f result

    while true
        read -lp 'set_color blue; echo -n math; set_color normal; echo -n "> "' input
        if [ "$input" = "exit" -o $status -ne 0 ]
            return
        end

        set input (string replace -a -- '$$' "$result" "$input")
        math "$input" && set result (math "$input")
    end
end
