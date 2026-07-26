function fish_prompt
    set return_code $status
    if tty | grep -q pts
        __fish_create_first_prompt_seg $return_code
        __fish_create_second_prompt_seg
    else
        __fish_simple_prompt $return_code
    end
end
