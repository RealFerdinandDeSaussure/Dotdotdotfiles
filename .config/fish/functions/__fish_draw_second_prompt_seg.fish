function __fish_draw_second_prompt_seg -a bg_color content
    __fish_chcol $fish_color_prompt_first_seg_bg $bg_color; and printf ''
    __fish_chcol black; and printf ' %s ' $content
    __fish_chcol $bg_color normal; and printf ' '
    __fish_chcol normal normal
end
