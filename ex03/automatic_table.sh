#!/bin/bash

# Database credentials
DB_NAME="piscineds"
DB_USER="oiskanda"

CUSTOMER_FOLDER="customer"

# Loop over all CSV files
for csvfile in "$CUSTOMER_FOLDER"/*.csv; do

    # Extract filename without extension
    filename=$(basename "$csvfile")
    table_name="${filename%.*}"

    echo "Creating table: $table_name"

    # Read the header (column names)
    header=$(head -n 1 "$csvfile")

    # Split into array
    IFS=',' read -ra columns <<< "$header"

    # Build CREATE TABLE statement dynamically
    create_sql="CREATE TABLE IF NOT EXISTS $table_name ("

    # First column must be TIMESTAMP
    first_col="${columns[0]}"
    create_sql+="\"$first_col\" TIMESTAMPTZ, "

    # Assign PostgreSQL data types
    # Use different types to satisfy requirement
    types=(TEXT INTEGER NUMERIC BIGINT UUID BOOLEAN)

    idx=1  
    for col in "${columns[@]:1}"; do
        type=${types[$(( (idx-1) % ${#types[@]} ))]}
        create_sql+="\"$col\" $type, "
        ((idx++))
    done

    # Remove last comma
    create_sql="${create_sql%, } );"

    # Execute CREATE TABLE
    sudo -u postgres psql -d "$DB_NAME" -c "$create_sql"

    # Import CSV contents
    sudo -u postgres psql -d "$DB_NAME" -c "\COPY $table_name FROM '$(realpath "$csvfile")' CSV HEADER"

    echo "Table '$table_name' created and data imported."
    echo "--------------------------------------------"

done

echo "All tables created successfully!"
