#!/bin/bash
if [[ $# -eq 2 ]]; then
    corrupt=`sqlite3 "$1" "PRAGMA integrity_check"`
    if [[ $corrupt -ne "ok" ]]; then
        # rebuild sqlite3 db
        ver=`sqlite3 "$1" "select sqlite_version();"`
        if [[ "3.22.0" -gt "$ver" ]]; then
            sqlite3 "$1" ".dump" > "$1.sql"
        else
            sqlite3 "$1" ".recover" > "$1.sql"
        fi
        sed -i '/BEGIN TRANSACTION/d;/ROLLBACK/d' "$1.sql" 
        sqlite3 "$1_rebuilt.aup3" < "$1.sql"
        rm "$1.sql"
    else
        aup3toraw -i "$1" -o "$1.raw"
    fi
else
    echo "Usage: aup3toraw.sh [aup3 filename]"
fi

