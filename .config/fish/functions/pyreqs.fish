function pyreqs -d "Install/Upgrade dependencies in an .in file and write their hashes to a .txt file"
    if ! functions -q __pyproj_fish_prompt
        echo "Run this from inside a pyproj virtual environment"
        return 1
    end

    for f in $argv
        if [ (path extension $f) != ".in" -o ! -f $f ]
            echo "All input should be .in files" >&2
            return 1
        end
    end

    for f in $argv
        pip install --upgrade --requirement $f
        set txt_file (path change-extension "txt" $f)
        python -m pip-tools compile --generate-hashes $f --output-file $txt_file
    end
end
