-- Function to generate a set of reservations across dates
-- Function to generate a set of reservations across dates
DO $$
DECLARE start_date DATE := CURRENT_DATE - INTERVAL '60 days';
end_date DATE := CURRENT_DATE + INTERVAL '30 days';
curr_date DATE := start_date;
-- Renamed variable from current_date to curr_date
reservation_id INT := 4;
-- Start after the explicit reservations
order_id INT := 4;
-- Start after the explicit orders
res RECORD;
-- Added declaration for the record variable used in FOR loop
BEGIN -- Loop through each date
WHILE curr_date <= end_date LOOP -- Skip the specific dates we already inserted
IF curr_date <> '2025-05-18'::date
AND curr_date <> '2025-05-19'::date
AND curr_date <> '2025-05-20'::date THEN -- Morning reservations (around 11:00-13:00)
FOR i IN 1..5 LOOP
INSERT INTO reservations (
        id,
        user_id,
        table_id,
        start_time,
        end_time,
        status
    )
VALUES (
        reservation_id,
        (1 + floor(random() * 15))::int,
        -- Random user 1-15
        (1 + floor(random() * 10))::int,
        -- Random table 1-10
        curr_date + (11 + floor(random() * 2))::int * INTERVAL '1 hour' + floor(random() * 60)::int * INTERVAL '1 minute',
        -- Random time 11:00-13:00
        curr_date + (13 + floor(random() * 2))::int * INTERVAL '1 hour' + floor(random() * 60)::int * INTERVAL '1 minute',
        -- Random time 13:00-15:00
        CASE
            WHEN curr_date < CURRENT_DATE THEN 'ordered'
            ELSE (ARRAY ['ordered', 'pending']) [1 + floor(random() * 2)::int]
        END -- Status logic
    );
reservation_id := reservation_id + 1;
END LOOP;
-- Evening reservations (around 18:00-20:00)
FOR i IN 1..8 LOOP -- More reservations in the evening
INSERT INTO reservations (
        id,
        user_id,
        table_id,
        start_time,
        end_time,
        status
    )
VALUES (
        reservation_id,
        (1 + floor(random() * 15))::int,
        -- Random user 1-15
        (1 + floor(random() * 10))::int,
        -- Random table 1-10
        curr_date + (18 + floor(random() * 2))::int * INTERVAL '1 hour' + floor(random() * 60)::int * INTERVAL '1 minute',
        -- Random time 18:00-20:00
        curr_date + (20 + floor(random() * 2))::int * INTERVAL '1 hour' + floor(random() * 60)::int * INTERVAL '1 minute',
        -- Random time 20:00-22:00
        CASE
            WHEN curr_date < CURRENT_DATE THEN 'ordered'
            ELSE (ARRAY ['ordered', 'pending']) [1 + floor(random() * 2)::int]
        END -- Status logic
    );
reservation_id := reservation_id + 1;
END LOOP;
END IF;
-- Move to next date
curr_date := curr_date + INTERVAL '1 day';
END LOOP;
-- Add a few overlapping reservations for testing
-- Same table, overlapping times
INSERT INTO reservations (
        id,
        user_id,
        table_id,
        start_time,
        end_time,
        status
    )
VALUES (
        reservation_id,
        1,
        1,
        CURRENT_DATE + INTERVAL '3 days' + INTERVAL '18 hours',
        CURRENT_DATE + INTERVAL '3 days' + INTERVAL '20 hours',
        'pending'
    );
reservation_id := reservation_id + 1;
INSERT INTO reservations (
        id,
        user_id,
        table_id,
        start_time,
        end_time,
        status
    )
VALUES (
        reservation_id,
        2,
        1,
        CURRENT_DATE + INTERVAL '3 days' + INTERVAL '19 hours',
        CURRENT_DATE + INTERVAL '3 days' + INTERVAL '21 hours',
        'pending'
    );
-- Update sequence
PERFORM setval('reservations_id_seq', reservation_id);
-- Generate orders for past reservations with 'ordered' status
FOR res IN
SELECT id,
    start_time
FROM reservations
WHERE status = 'ordered'
    AND id > 3 LOOP FOR i IN 1..((1 + floor(random() * 4))::int) LOOP -- Random 1-5 orders per reservation
INSERT INTO orders (
        id,
        reservation_id,
        menu_id,
        quantity,
        order_time
    )
VALUES (
        order_id,
        res.id,
        (1 + floor(random() * 15))::int,
        -- Random menu 1-15
        (1 + floor(random() * 3))::int,
        -- Random quantity 1-3
        res.start_time + (floor(random() * 30))::int * INTERVAL '1 minute' -- Order time shortly after reservation starts
    );
order_id := order_id + 1;
END LOOP;
END LOOP;
-- Update sequence
PERFORM setval('orders_id_seq', order_id);
END $$;
-- Add a VIP user with high spending for testing
DO $$
DECLARE vip_reservation_id INT;
current_order_id INT;
BEGIN -- Get next reservation ID
SELECT nextval('reservations_id_seq') INTO vip_reservation_id;
-- Create a VIP reservation
INSERT INTO reservations (
        id,
        user_id,
        table_id,
        start_time,
        end_time,
        status
    )
VALUES (
        vip_reservation_id,
        5,
        3,
        CURRENT_DATE - INTERVAL '10 days',
        CURRENT_DATE - INTERVAL '10 days' + INTERVAL '2 hours',
        'ordered'
    );
-- Get next order ID
SELECT nextval('orders_id_seq') INTO current_order_id;
-- Add expensive orders for the VIP
INSERT INTO orders (
        id,
        reservation_id,
        menu_id,
        quantity,
        order_time
    )
VALUES (
        current_order_id,
        vip_reservation_id,
        1,
        10,
        CURRENT_DATE - INTERVAL '10 days' + INTERVAL '10 minutes'
    );
-- 10 Steaks
-- Get next order ID
SELECT nextval('orders_id_seq') INTO current_order_id;
INSERT INTO orders (
        id,
        reservation_id,
        menu_id,
        quantity,
        order_time
    )
VALUES (
        current_order_id,
        vip_reservation_id,
        5,
        10,
        CURRENT_DATE - INTERVAL '10 days' + INTERVAL '15 minutes'
    );
-- 10 Fish
-- Get next order ID
SELECT nextval('orders_id_seq') INTO current_order_id;
INSERT INTO orders (
        id,
        reservation_id,
        menu_id,
        quantity,
        order_time
    )
VALUES (
        current_order_id,
        vip_reservation_id,
        12,
        20,
        CURRENT_DATE - INTERVAL '10 days' + INTERVAL '20 minutes'
    );
-- 20 Wines
END $$;