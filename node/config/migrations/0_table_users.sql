-- Table: users
CREATE TABLE IF NOT EXISTS public.users (
    id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    role VARCHAR(20) NOT NULL,
    created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    CONSTRAINT users_pkey PRIMARY KEY (id),
    CONSTRAINT fk_created_by FOREIGN KEY (created_by) REFERENCES public.users(id),
    CONSTRAINT fk_updated_by FOREIGN KEY (updated_by) REFERENCES public.users(id)
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_users_name ON public.users(name);
CREATE SEQUENCE IF NOT EXISTS users_id_seq START 1;

-- Create or replace trigger function for automatic timestamps
CREATE OR REPLACE FUNCTION users_update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        NEW.created_at = now();
        NEW.updated_at = now();
        RETURN NEW;
    ELSIF TG_OP = 'UPDATE' THEN
        NEW.updated_at = now();
        RETURN NEW;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for the users table
DROP TRIGGER IF EXISTS users_set_timestamp ON public.users;
CREATE TRIGGER users_set_timestamp
BEFORE INSERT OR UPDATE ON public.users
FOR EACH ROW
EXECUTE FUNCTION users_update_timestamp();
