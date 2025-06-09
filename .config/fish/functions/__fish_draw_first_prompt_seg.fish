function __fish_draw_first_prompt_seg -a bg_color content
    __fish_chcol black $bg_color; and printf ' '$content
    set -g fish_color_prompt_first_seg_bg $bg_color
end
