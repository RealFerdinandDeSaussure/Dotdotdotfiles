function pyproj -d "Activate python virtual environment for current project"
    argparse 'd/delete' -- $argv
    set -l first_run 0

    if functions -q __pyproj_fish_prompt
        functions -e fish_prompt
        functions -c __pyproj_fish_prompt fish_prompt
        functions -e __pyproj_fish_prompt
        for var in PYTHONPATH VIRTUAL_ENV PATH
            set backup_var __pyproj_$var
            if set -q $backup_var
                set -gx $var $$backup_var
                set -e $backup_var
            else
                set -e $var
            end
        end
        # if the delete flag has been set, we should return after deleting the
        # venv
        if [ ! $_flag_delete ]
            return
        end
    end

    set toplevel (git rev-parse --show-toplevel 2>/dev/null)
    if [ "$toplevel" = "$HOME" ] && [ "$(pwd)" = "$HOME" ]
        echo "Cannot use a  virtual environment in the home folder."
        return 1
    else if [ "$toplevel" = "$HOME" ] || [ -z "$toplevel" ]
        set -gx PYTHONPROJECTNAME (basename (pwd))
    else
        set -gx PYTHONPROJECTNAME (basename $toplevel)
        set proj_id (git rev-list --parents HEAD | tail -n1) || return 1
    end

    set venv_dir "$HOME/.local/share/python/venv/$PYTHONPROJECTNAME-$proj_id"

    if [ $_flag_delete ]
        rm -rfv "$venv_dir"
        return
    end

    mkdir -p $venv_dir || return 1
    if [ ! -e "$venv_dir/bin/activate.fish" ]
        python -m venv $venv_dir || return 1
        set first_run 1
    end

    for var in PYTHONPATH VIRTUAL_ENV PATH
        set -q $var && set -gx __pyproj_$var "$$var"
    end

    set -gx VIRTUAL_ENV $venv_dir
    set -gx PYTHONPATH (string join ":" $toplevel "$VIRTUAL_ENV/lib"*"/python"*"/site-packages")
    set -gx PATH "$VIRTUAL_ENV/bin:$PATH"

    functions -c fish_prompt __pyproj_fish_prompt
    functions -e fish_prompt

    function fish_prompt
        # __pyproj_fish_prompt needs to execute first so we can catch the exit
        # code in $status
        set pfprompt (__pyproj_fish_prompt)
        printf "(PY)%s%s%s%s" (set_color yellow) $PYTHONPROJECTNAME (set_color normal) $pfprompt
    end

    if [ "$first_run" -ne 0 ]
        pip install --upgrade pip pip-tools
    end
end
