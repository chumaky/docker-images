import duckdb

database_path = 'json_files.duckdb'

# Connect to DuckDB. If the file does not exist, it will be created.
conn = duckdb.connect(database_path, read_only=False)

# Create views
conn.execute("""
    CREATE OR REPLACE VIEW json_files_v AS 
        SELECT * FROM read_json_auto(['/home/data/file1.json', '/home/data/file2.json']);
""")


# Close the connection when done
conn.close()
