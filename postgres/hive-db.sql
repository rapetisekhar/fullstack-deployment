-- Create role if not exists
DO
$$
BEGIN
   IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'metastoreuser') THEN
      CREATE ROLE metastoreuser WITH LOGIN PASSWORD 'metastorepassword';
   END IF;
END
$$;

-- Create database only if it does not exist
-- This has to be outside the DO block
-- Check first using psql manually, or do it in shell script logic

-- Comment out if database already exists
CREATE DATABASE metastoredb OWNER metastoreuser;

-- Grant access to the user
-- Run these **after switching to the database** manually or through `psql -d metastoredb`

-- CONNECT to DB:
-- \c metastoredb;

-- Permissions (run from inside metastoredb)
GRANT CONNECT ON DATABASE metastoredb TO metastoreuser;

GRANT USAGE ON SCHEMA public TO metastoreuser;
GRANT CREATE ON SCHEMA public TO metastoreuser;

GRANT SELECT, INSERT, UPDATE, DELETE, TRIGGER ON ALL TABLES IN SCHEMA public TO metastoreuser;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO metastoreuser;

-- Optional: give full DB privileges
GRANT ALL PRIVILEGES ON DATABASE metastoredb TO metastoreuser;

