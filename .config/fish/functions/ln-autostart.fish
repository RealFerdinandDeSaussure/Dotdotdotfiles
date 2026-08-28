function ln-autostart -d "Create a link to an application's desktop file in ~/.config/autostart" -a app
    test -z "$app" && return 1
    set target_file /usr/share/applications/{$app}.desktop
    if [ ! -f "$target_file" ]
        echo "File $target_file not found." >&2
        return 1
    end

    set link_path $HOME/.config/autostart/{$app}.desktop
    if [ -f "$link_path" ]
        echo "File at $link_path already exists." >&2
        return 1
    end

    ln -sv "$target_file" "$link_path"
end
