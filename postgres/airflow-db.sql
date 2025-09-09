-- Create user if not exists
DO
$$
BEGIN
   IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'airflowuser') THEN
      CREATE ROLE airflowuser WITH LOGIN PASSWORD 'airflowpassword';
   END IF;
END
$$;

-- Create database if not exists
CREATE DATABASE airflowdb OWNER airflowuser;
DO
$$
BEGIN
   IF NOT EXISTS (SELECT FROM pg_database WHERE datname = 'airflowdb') THEN
      CREATE DATABASE airflowdb OWNER airflowuser;
   END IF;
END
$$;

-- Permissions
GRANT CONNECT ON DATABASE airflowdb TO airflowuser;
GRANT ALL PRIVILEGES ON DATABASE airflowdb TO airflowuser;

-- Switch to DB manually if needed:
-- \c airflowdb;

-- Schema and object-level grants
GRANT USAGE ON SCHEMA public TO airflowuser;
GRANT CREATE ON SCHEMA public TO airflowuser;

GRANT SELECT, INSERT, UPDATE, DELETE, TRIGGER ON ALL TABLES IN SCHEMA public TO airflowuser;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO airflowuser;

