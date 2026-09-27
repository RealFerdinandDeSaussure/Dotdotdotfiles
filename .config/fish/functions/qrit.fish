function qrit -d "Create a QR Code from the provided argument"
    set -f str_out
    switch (count $argv)
        case 0
            cat | read -z str_out
        case 1
            set str_out $argv
        case '*'
            set str_out $argv[1]
            for str in $argv[2..-1]
                set str_out $str_out" $str"
            end
    end

    echo -n "$str_out" | qrencode --size 10 -o - | imv -
end
