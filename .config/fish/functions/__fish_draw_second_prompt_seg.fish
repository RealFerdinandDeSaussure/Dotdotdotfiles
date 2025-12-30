function __fish_draw_second_prompt_seg -a bg_color content
    set_color -b $bg_color; and printf ''
    set_color black; and printf ' %s ' $content
    set_color -b normal $bg_color; and printf ' '
    set_color -b normal normal
end
