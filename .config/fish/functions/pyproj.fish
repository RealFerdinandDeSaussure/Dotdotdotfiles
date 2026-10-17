function pyproj -d "Activate python virtual environment for current project"
    # -c/--create: create and activate a new virtual environment in the current
    #              working directory, if one already exists, it will be
    #              overwritten!
    # -d/--delete: delete the virtual environment for the current project
    argparse -n pyproj c/create d/delete -- $argv || return 1
    set -f first_run 0
    set -f venv_base $HOME/.local/share/python/venv

    # deactivate the pyproj environment if it's currently active
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
        # venv, not here
        if not set -fq _flag_delete
            return
        end
    end

    set -f origin_dir (pwd)
    set -f toplevel
    while true
        set toplevel (pwd -P)
        if string match -qe "$toplevel" "$HOME"
            echo "Reached \$HOME (or beyond) while looking for a project root."
            cd $origin_dir
            return 1
        else if set -fq _flag_create
            tr -dc '[:alnum:]' </dev/urandom | read -fn 30 proj_id
            # although highly unlikely, this test ensures no duplicate proj_ids
            test (count $venv_base/*-$proj_id) -ne 0 && continue
            echo -n $proj_id >.pyproj
            cd $origin_dir
            break
        else if [ -f .pyproj ]
            set -f proj_id (cat .pyproj)
            echo -n $proj_id | tr -dc '[:alnum:]' | string pad -w 30 | read -l sane_proj_id
            test "$proj_id" = "$sane_proj_id" && break
            echo ".pyproj file found at $(pwd) but does not contain valid project identifier."
            cd $origin_dir
            return 1
        end
        cd ..
    end

    set -gx PYTHONPROJECTNAME (basename $toplevel)
    set -f venv_dir $venv_base/$PYTHONPROJECTNAME-$proj_id

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
