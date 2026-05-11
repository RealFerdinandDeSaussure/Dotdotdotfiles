function fish_vi_cursor --on-variable fish_bind_mode --on-event fish_prompt
    if [ $fish_bind_mode = "insert" ]
        echo -ne '\033[4 q'
    else
        echo -ne '\033[2 q'
    end
            
end
