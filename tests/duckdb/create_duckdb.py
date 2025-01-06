import duckdb

database_path = 'json_files.duckdb'

# Connect to DuckDB. If the file does not exist, it will be created.
conn = duckdb.connect(database_path, read_only=False)

# Create views
conn.execute("""
    CREATE OR REPLACE VIEW json_file_v AS 
        SELECT * FROM read_json_auto(['/data/file1.json', '/data/file2.json']);
""")


# Close the connection when done
conn.close()
