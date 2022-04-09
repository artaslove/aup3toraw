#!/bin/bash
if [[ $# -eq 2 ]]; then
    corrupt=`sqlite3 "$1" "PRAGMA integrity_check;"`
    if [[ $corrupt -ne "ok" ]]; then
        # rebuild sqlite3 db
        ver=`sqlite3 "$1" "select sqlite_version();"`
                echo "Version: $ver\n$corrupt"
        if [[ "3.22.0" -gt "$ver" ]]; then
            sqlite3 "$1" ".dump" > "$1.sql"
        else
            sqlite3 "$1" ".recover" > "$1.sql"
        fi
        sed -i '/BEGIN TRANSACTION/d;/ROLLBACK/d' "$1.sql" 
        sqlite3 "$1_rebuilt.aup3" < "$1.sql"
        if [[ $? -eq 0 ]]; then
            rm "$1.sql"
        else
            echo "Trouble with that sql."	
            exit 1
        fi
        aup3_input_name="$1_rebuilt.aup3"	        
    else
        aup3_input_name="$1"
    fi
    aup3_output_name=`sed 's/\.aup3//' <<< "$1"`
    aup3toraw -i "$aup3_input_name" -o "$aup3_output_name"
else
    echo "Usage: aup3toraw.sh [aup3 filename]"
fi

