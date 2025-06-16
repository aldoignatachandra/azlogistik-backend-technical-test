-- Table: orders
CREATE TABLE IF NOT EXISTS public.orders (
    id INT NOT NULL,
    reservation_id INT NOT NULL REFERENCES reservations(id),
    menu_id INT NOT NULL REFERENCES menus(id),
    quantity INTEGER NOT NULL,
    order_time TIMESTAMP NOT NULL,
    created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    CONSTRAINT orders_pkey PRIMARY KEY (id),
    CONSTRAINT fk_created_by FOREIGN KEY (created_by) REFERENCES public.users(id),
    CONSTRAINT fk_updated_by FOREIGN KEY (updated_by) REFERENCES public.users(id)
);

-- Indexes for performance
CREATE SEQUENCE IF NOT EXISTS orders_id_seq START 1;

-- Create or replace trigger function for automatic timestamps
CREATE OR REPLACE FUNCTION orders_update_timestamp()
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

-- Create trigger for the orders table
DROP TRIGGER IF EXISTS orders_set_timestamp ON public.orders;
CREATE TRIGGER orders_set_timestamp
BEFORE INSERT OR UPDATE ON public.orders
FOR EACH ROW
EXECUTE FUNCTION orders_update_timestamp();
