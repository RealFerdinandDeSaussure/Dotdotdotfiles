function chksum
    argparse -n 'chksum' 'h/hash=' -- $argv
    or return

    set -a _flag_hash md5sum
    
    if [ ! (count $argv) -eq 2  -o ! -f "$argv[-1]" ]
        echo "syntax: chksum [-h HASH_TYPE] CHECKSUM FILE"
        return
    end

    set filehash ($_flag_hash[1]sum "$argv[-1]" | awk '{print $1}')
    or return

    if [ (string lower "$filehash") = (string lower "$argv[-2]") ]
        echo "OK: Checksum matches." > /dev/stderr
        return 0
    else
        echo "FAIL: Checksum does not match." > /dev/stderr
        return 1
    end
end
