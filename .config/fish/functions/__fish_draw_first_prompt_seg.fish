function __fish_draw_first_prompt_seg -a bg_color content
    set_color -b $bg_color black; and printf ' '$content
    set_color $bg_color
end
