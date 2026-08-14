function __fish_cdp_preview -d "Function to give to fzf for file previews" -a choice
    set_color -o; echo $choice; set_color normal
    if [ -d $choice ]
        ls $choice
    else if grep -qI '' $choice
        head -n (math $FZF_PREVIEW_LINES - 1) $choice
    else
        file $choice | fold -s -w $FZF_PREVIEW_COLUMNS
    end
end
