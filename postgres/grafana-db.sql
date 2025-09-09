-- Step 1: Create grafana_user if it doesn't exist
DO
$$
BEGIN
   IF NOT EXISTS (
      SELECT FROM pg_catalog.pg_roles WHERE rolname = 'grafana_user'
   ) THEN
      CREATE ROLE grafana_user WITH LOGIN PASSWORD 'grafana_pass';
   END IF;
END
$$;

-- Step 2: Create grafana database (run this separately if needed)
-- This will throw an error if the database already exists
-- You may ignore the error or check beforehand
CREATE DATABASE grafana OWNER grafana_user;

-- Run this after: \c grafana
GRANT CONNECT ON DATABASE grafana TO grafana_user;

GRANT USAGE ON SCHEMA public TO grafana_user;
GRANT CREATE ON SCHEMA public TO grafana_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO grafana_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO grafana_user;

