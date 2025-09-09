-- Create the user if it does not exist
DO $$
BEGIN
   IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'metastoreuser') THEN
      CREATE ROLE metastoreuser WITH LOGIN PASSWORD 'metastorepassword';
   END IF;
END
$$;
CREATE DATABASE metastoredb OWNER metastoreuser;

-- Create the database if it does not exist
DO $$
BEGIN
   IF NOT EXISTS (SELECT FROM pg_database WHERE datname = 'metastoredb') THEN
      CREATE DATABASE metastoredb OWNER metastoreuser;
   END IF;
END
$$;

-- Connect to the metastoredb (this part needs to be executed outside in psql shell or scripting)
-- \c metastoredb

-- The following grants must be executed in the context of metastoredb
-- So either use psql shell: \c metastoredb, or run via a script like: psql -d metastoredb -f grants.sql

-- === Run inside metastoredb ===
GRANT CONNECT ON DATABASE metastoredb TO metastoreuser;

GRANT USAGE ON SCHEMA public TO metastoreuser;
GRANT CREATE ON SCHEMA public TO metastoreuser;

GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA public TO metastoreuser;
GRANT USAGE, SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA public TO metastoreuser;

-- Ensure future tables/sequences also get privileges
ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER ON TABLES TO metastoreuser;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT USAGE, SELECT, UPDATE ON SEQUENCES TO metastoreuser;

-- Optional: Grant all database-level privileges
GRANT ALL PRIVILEGES ON DATABASE metastoredb TO metastoreuser;
