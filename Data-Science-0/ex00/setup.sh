#!/bin/bash

echo "Configuring PostgreSQL…"

sudo -u postgres psql <<EOF
DO
\$do\$
BEGIN
   IF NOT EXISTS (
      SELECT FROM pg_catalog.pg_roles WHERE rolname = 'oiskanda'
   ) THEN
      CREATE ROLE oiskanda WITH LOGIN PASSWORD 'mysecretpassword';
   END IF;
END
\$do\$;

-- Create database only if it doesn't exist
CREATE DATABASE piscineds OWNER oiskanda;
EOF

echo "PostgreSQL setup complete."
echo "You can test the connection using:"
echo "psql -U oiskanda -d piscineds -h localhost -W"