if status is-login
    # source fish compatible files in /etc/profile.d/
    for f in /etc/profile.d/*.fish
        source $f
    end
end
