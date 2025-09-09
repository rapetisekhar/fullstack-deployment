-- Create role if not exists
CREATE ROLE supersetuser WITH LOGIN PASSWORD 'supersetpassword';
CREATE DATABASE supersetdb OWNER supersetuser;
DO
$$
BEGIN
   IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'supersetuser') THEN
      CREATE ROLE supersetuser WITH LOGIN PASSWORD 'supersetpassword';
   END IF;
END
$$;

-- Create database only if it does not exist
-- This has to be outside the DO block
-- Check first using psql manually, or do it in shell script logic

-- Comment out if database already exists
CREATE DATABASE supersetdb OWNER supersetuser;

-- Grant access to the user
-- Run these **after switching to the database** manually or through `psql -d supersetdb`

-- CONNECT to DB:
-- \c supersetdb;

-- Permissions (run from inside supersetdb)
GRANT CONNECT ON DATABASE supersetdb TO supersetuser;

GRANT USAGE ON SCHEMA public TO supersetuser;
GRANT CREATE ON SCHEMA public TO supersetuser;

GRANT SELECT, INSERT, UPDATE, DELETE, TRIGGER ON ALL TABLES IN SCHEMA public TO supersetuser;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO supersetuser;

-- Optional: give full DB privileges
GRANT ALL PRIVILEGES ON DATABASE supersetdb TO supersetuser;

