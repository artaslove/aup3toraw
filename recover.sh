#!/bin/bash
# rebuild db also
sqlite3 "$1" ".dump" > "$1.sql"
sed -i '/BEGIN TRANSACTION/d;/ROLLBACK/d' "$1.sql" 
sqlite3 "$1_rebuilt.aup3" < "$1.sql"
# aup3toraw -i "$1_rebuilt.aup3" -o "$1_rebuilt.raw"
