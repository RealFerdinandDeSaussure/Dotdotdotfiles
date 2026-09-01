function chksum
    argparse -n 'chksum' 'h/hash=' -- $argv || return

    if [ ! (count $argv) -eq 2  -o ! -f "$argv[-1]" ]
        echo "syntax: chksum [-h HASH_TYPE] CHECKSUM FILE"
        return
    end

    set -a _flag_hash sha256
    set hash_exc {$_flag_hash[1]}sum
    if not command -q "$hash_exc"
        echo "No program $hash_exc found in \$PATH." >/dev/stderr
        return 1
    end

    set filehash ($_flag_hash[1]sum "$argv[-1]" | awk '{print $1}') || return

    if [ (string lower "$filehash") = (string lower "$argv[-2]") ]
        echo "OK: Checksum matches." > /dev/stderr
        return 0
    else
        echo "FAIL: Checksum does not match." > /dev/stderr
        return 1
    end
end
