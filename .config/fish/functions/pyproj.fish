function pyproj -d "Activate python virtual environment for current project"

    if functions -q __pyproj_fish_prompt
        functions -e fish_prompt
        functions -c __pyproj_fish_prompt fish_prompt
        functions -e __pyproj_fish_prompt
        for var in PYTHONPATH VIRTUAL_ENV PATH
            set backup_var __pyproj_$var
                echo $backup_var
            if set -q $backup_var
                echo $backup_var
                set -gx $var $$backup_var
                set -e $backup_var
            else
                set -e $var
            end
        end
        return
    end

    set toplevel (git rev-parse --show-toplevel)
    test $status -ne 0 && return
    if [ $toplevel = "$HOME" ]
        echo "Cannot create virtual environment for home folder project."
        return 1
    end
    set proj_id (git rev-list --parents HEAD | tail -n1)
    set -gx PYTHONPROJECTNAME (basename $toplevel)
    set venv_dir $HOME/.local/share/python/venv/$PYTHONPROJECTNAME-$proj_id

    mkdir -p $venv_dir
    if [ ! -e $venv_dir/bin/activate.fish ]
        python -m venv $venv_dir
    end

    for var in PYTHONPATH VIRTUAL_ENV PATH
        set -q $var && set -gx __pyproj_$var "$$var"
    end

    set -gx PYTHONPATH $toplevel
    set -gx VIRTUAL_ENV $venv_dir
    set -gx PATH "$VIRTUAL_ENV/bin:$PATH"

    functions -c fish_prompt __pyproj_fish_prompt
    functions -e fish_prompt

    function fish_prompt
        printf "(PY)%s%s%s" (set_color $__BASE09) $PYTHONPROJECTNAME (set_color normal)
        __pyproj_fish_prompt
    end
end
