#!/bin/bash
# rebuild sqlite3 db
#
# Usage: recover.sh [corrupt sqlite3 filename] [recovered sqlite3 filename]

ver=`sqlite3 "$1" "select sqlite_version();"`
if [[ "3.22.0" -gt "$ver" ]]; then
 sqlite3 "$1" ".dump" | sqlite3 "$2"
else
 sqlite3 "$1" ".recover" | sqlite3 "$2"
fi

# sed -i '/BEGIN TRANSACTION/d;/ROLLBACK/d' "$1.sql" 
# sqlite3 "$1_rebuilt.aup3" < "$1.sql"
# aup3toraw -i "$1_rebuilt.aup3" -o "$1_rebuilt.raw"
