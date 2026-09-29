function line -d "Limit output to a specific line"
    sed -n {$argv[1]}p
end
