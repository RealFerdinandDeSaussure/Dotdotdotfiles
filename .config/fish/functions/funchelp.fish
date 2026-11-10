function funchelp --description "Print available flags for a fish function"
    set -f func $argv
    functions $func >/dev/null || return 1
    set -f description (functions -Dv $func | tail -n1)

    set_color --bold; echo -n $func; set_color normal
    echo -n " - "
    set_color --italics; echo $description; set_color normal

    functions --no-details $func | tail -n+2 | while read line
        string match -qr -- '^\s*#\s*(?<f>-[\-/\w]+)\S*\s+(?<d>.+)$' $line || break
        string join -- \x1f $f $d
    end | column -dt -s \x1f --table-column name=f,color=bold --table-column name=d,wrap --table-column name=pad --table-order pad,f,d
end
