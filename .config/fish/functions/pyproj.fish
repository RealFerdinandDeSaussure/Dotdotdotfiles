function pyproj -d "Activate python virtual environment for current project"
    # -d/--delete: delete the virtual environment for the current project
    argparse -n pyproj 'd/delete' -- $argv
    set -f first_run 0

    if functions -q __pyproj_fish_prompt
        functions -e fish_prompt
        functions -c __pyproj_fish_prompt fish_prompt
        functions -e __pyproj_fish_prompt
        for var in PYTHONPATH VIRTUAL_ENV PATH
            set -l backup_var __pyproj_$var
            if set -gq $backup_var
                set -gx $var $$backup_var
                set -ge $backup_var
            else
                set -ge $var
            end
        end
        # if the delete flag has been set, we should return after deleting the
        # venv
        if not set -fq _flag_delete
            return
        end
    end

    set -f toplevel (git rev-parse --show-toplevel 2>/dev/null)
    if [ "$toplevel" = "$HOME" ] && [ "$(pwd)" = "$HOME" ]
        echo "Cannot use a virtual environment in the home folder."
        return 1
    else if [ "$toplevel" = "$HOME" ] || [ -z "$toplevel" ]
        set -gx PYTHONPROJECTNAME (basename (pwd))
    else
        set -gx PYTHONPROJECTNAME (basename $toplevel)
        set -f proj_id (git rev-list --parents HEAD | tail -n1) || return 1
    end

    set -f venv_dir "$HOME/.local/share/python/venv/$PYTHONPROJECTNAME-$proj_id"

    if set -fq _flag_delete
        rm -rfv "$venv_dir"
        return
    end

    mkdir -p $venv_dir || return 1
    if [ ! -e "$venv_dir/bin/activate.fish" ]
        python -m venv $venv_dir || return 1
        set first_run 1
    end

    for var in PYTHONPATH VIRTUAL_ENV PATH
        set -gq $var && set -gx __pyproj_$var "$$var"
    end

    set -gx VIRTUAL_ENV $venv_dir
    set -gx PYTHONPATH (string join ":" $toplevel "$VIRTUAL_ENV/lib"*"/python"*"/site-packages")
    set -gx PATH "$VIRTUAL_ENV/bin:$PATH"

    functions -c fish_prompt __pyproj_fish_prompt
    functions -e fish_prompt

    function fish_prompt
        # __pyproj_fish_prompt needs to execute first so we can catch the exit
        # code in $status
        set -l pfprompt (__pyproj_fish_prompt)
        printf "(PY)%s%s%s%s" (set_color yellow) $PYTHONPROJECTNAME (set_color normal) $pfprompt
    end

    if [ "$first_run" -ne 0 ]
        pip install --upgrade pip pip-tools
    end
end
