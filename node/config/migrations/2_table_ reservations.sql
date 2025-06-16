-- Table: reservations
CREATE TABLE IF NOT EXISTS public.reservations (
    id INT NOT NULL,
    user_id INT NOT NULL REFERENCES users(id),
    table_id INT NOT NULL REFERENCES tables(id),
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP NOT NULL,
    status VARCHAR(20) NOT NULL,
    created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    CONSTRAINT reservations_pkey PRIMARY KEY (id),
    CONSTRAINT fk_created_by FOREIGN KEY (created_by) REFERENCES public.users(id),
    CONSTRAINT fk_updated_by FOREIGN KEY (updated_by) REFERENCES public.users(id)
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_reservations_status_start_time ON reservations(status, start_time);
CREATE INDEX IF NOT EXISTS idx_reservations_table_id ON reservations(table_id);
CREATE INDEX IF NOT EXISTS idx_reservations_user_id ON reservations(user_id);
CREATE SEQUENCE IF NOT EXISTS reservations_id_seq START 1;

-- Create or replace trigger function for automatic timestamps
CREATE OR REPLACE FUNCTION reservations_update_timestamp()
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

-- Create trigger for the reservations table
DROP TRIGGER IF EXISTS reservations_set_timestamp ON public.reservations;
CREATE TRIGGER reservations_set_timestamp
BEFORE INSERT OR UPDATE ON public.reservations
FOR EACH ROW
EXECUTE FUNCTION reservations_update_timestamp();
