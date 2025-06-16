-- Table: tables
CREATE TABLE IF NOT EXISTS public.tables (
    id INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    capacity INTEGER NOT NULL,
    created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    CONSTRAINT tables_pkey PRIMARY KEY (id),
    CONSTRAINT fk_created_by FOREIGN KEY (created_by) REFERENCES public.users(id),
    CONSTRAINT fk_updated_by FOREIGN KEY (updated_by) REFERENCES public.users(id)
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_tables_name ON public.tables(name);
CREATE SEQUENCE IF NOT EXISTS tables_id_seq START 1;

-- Create or replace trigger function for automatic timestamps
CREATE OR REPLACE FUNCTION tables_update_timestamp()
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

-- Create trigger for the tables table
DROP TRIGGER IF EXISTS tables_set_timestamp ON public.tables;
CREATE TRIGGER tables_set_timestamp
BEFORE INSERT OR UPDATE ON public.tables
FOR EACH ROW
EXECUTE FUNCTION tables_update_timestamp();
