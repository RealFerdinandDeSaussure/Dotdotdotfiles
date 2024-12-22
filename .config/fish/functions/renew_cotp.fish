function renew_cotp
    if [ -z "$argv" ]
        echo "Specify the Aegis encrypted database file to import." >&2
        return 1
    else if [ ! -f "$argv" ]
        echo "$argv is not a valid file." >&2
        return 1
    end

    set -q COTP_DB_PATH || set COTP_DB_PATH "$HOME/.local/share/cotp"
    rm -v {$COTP_DB_PATH}/db.cotp
    cotp import --path "$argv" --aegis-encrypted
end
