CREATE SCHEMA IF NOT EXISTS admin;

-- import foreign schemas after corresponding databases completed initialization within theirs containers
CREATE OR REPLACE FUNCTION admin.import_foreign_schema
( p_foreign_schema   VARCHAR
, p_local_schema     VARCHAR
, p_foreign_server   VARCHAR
, p_options          VARCHAR DEFAULT NULL
, p_steps            INTEGER DEFAULT 36
, p_sleep            INTEGER DEFAULT 5
)
RETURNS void
AS
$import_foreign_schema$
DECLARE
   idx   INTEGER;
BEGIN
   RAISE INFO USING message = CONCAT_WS(' ',
      'Importing foreign schema', QUOTE_LITERAL(p_foreign_schema),
      'from server', QUOTE_LITERAL(p_foreign_server),
      'into local schema', QUOTE_LITERAL(p_local_schema)
   );

   FOR idx IN 1..p_steps
   LOOP
      BEGIN
         EXECUTE CONCAT_WS(' ',
            'IMPORT FOREIGN SCHEMA', QUOTE_IDENT(p_foreign_schema),
            'FROM SERVER', QUOTE_IDENT(p_foreign_server),
            'INTO', QUOTE_IDENT(p_local_schema),
            NULLIF(CONCAT('OPTIONS (', p_options, ')'), 'OPTIONS ()')
         );
         RAISE INFO USING message = 'Schema ' || QUOTE_LITERAL(p_foreign_schema) || ' succesfully imported';
         EXIT;
      EXCEPTION
         WHEN OTHERS THEN
            RAISE WARNING USING message = CONCAT('error code: ', sqlstate, ', message: ', sqlerrm);
            RAISE WARNING USING message = 'Error happened. sleeping for ' || p_sleep || ' seconds...';
            PERFORM pg_sleep(p_sleep);
      END;
   END LOOP;
END;
$import_foreign_schema$
LANGUAGE plpgsql;
