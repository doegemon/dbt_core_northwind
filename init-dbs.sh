# init-dbs.sh

#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE DATABASE northwind_dev;
    CREATE DATABASE northwind_prod;
EOSQL
