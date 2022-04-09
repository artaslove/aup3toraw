#!/bin/bash
aup3_name=`sed 's/\.aup3//' <<< "$1"`
echo "${aup3_name}"
if [[ $# -eq 1 ]]; then
    corrupt=`sqlite3 "${aup3_name}.aup3" "PRAGMA integrity_check;"`
    if [[ "$corrupt" != "ok" ]]; then
        # rebuild sqlite3 db
        ver=$(sed 's/\.[0-9]$//' <<< `sqlite3 "${aup3_name}.aup3" "select sqlite_version();"`)
                echo -e "Version: ${ver}\n${corrupt}"
        if [[ 3.29 > $ver ]]; then
            sqlite3 "${aup3_name}.aup3" ".dump" > "${aup3_name}.sql"
        else
            sqlite3 "${aup3_name}.aup3" ".recover" > "${aup3_name}.sql"
        fi
        echo "sed part"
        sed -i '/BEGIN TRANSACTION/d;/ROLLBACK/d' "${aup3_name}.sql" 
        sqlite3 "${aup3_name}_rebuilt.aup3" < "${aup3_name}.sql"
        if [[ $? -eq 0 ]]; then
            rm "${aup3_name}.sql"
        else
            echo "Trouble with that sql."	
            exit 1
        fi
        aup3_input_name="${aup3_name}_rebuilt.aup3"	        
    else
        aup3_input_name="${aup3_name}.aup3"
    fi
    echo "$aup3_input_name" "${aup3_name}.raw"
    ./aup3toraw -i "$aup3_input_name" -o "${aup3_name}.raw"
else
    echo "Usage: aup3toraw.sh [aup3 filename]"
fi

