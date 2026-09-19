function glob
    argparse -n 'glob' -x 'b,c,d,f,g,G,L,O,p,r,s,S,t,u,w,x' 'h/hidden' 'X/except=+' 'b/block' 'c/character' 'd/directory' 'g/group' 'G/Group' 'f/file' 'L/Link' 'O/Owned' 'p/pipe' 'r/readable' 's/size' 'S/Socket' 't/terminal' 'u/user' 'w/writable' 'x/xecutable' -- $argv || return 1

    # build list of files
    set all_files $argv
    test (count $all_files) -eq 0 && set all_files *
    set -q _flag_hidden && set -a all_files .*
    # normalize paths
    set all_files (path normalize -- $all_files)

    # trim flags so we can use them as operators for test
    for flag in $_flag_b $_flag_c $_flag_d $_flag_f $_flag_g $_flag_G $_flag_L $_flag_O $_flag_p $_flag_r $_flag_s $_flag_S $_flag_t $_flag_u $_flag_w $_flag_x
        test -z "$flag" && continue
        if [ (string length -- "$flag") -gt 2 ]
            set testflag (string sub -s 2 -l 2 -- $flag)
        else
            set testflag $flag
        end
    end

    # normalize exceptions
    set exceptions (path normalize -- $_flag_except)

    # loop through all_files and print those that match
    for f in $all_files
        # skip for any exceptions passed on the command line
        contains $f $exceptions && continue
        test $testflag $f || continue
        echo $f
    end
end
