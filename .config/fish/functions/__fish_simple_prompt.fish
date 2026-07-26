function __fish_simple_prompt -a return_code
    echo -n (set_color -o)"$USER "(set_color normal)(prompt_pwd)(set_color yellow)
    if [ $return_code -ne 0 ]
        set_color red
    else
        set_color yellow
    end
    echo -n " [$return_code]"(set_color normal)" > "
end
