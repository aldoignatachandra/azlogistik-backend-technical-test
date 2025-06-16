-- config/migrations/5_table_seeder.sql

-- Users data
INSERT INTO users (id, name, email, role) VALUES
(1, 'John Doe', 'john@example.com', 'customer'),
(2, 'Jane Smith', 'jane@example.com', 'customer'),
(3, 'Admin User', 'admin@restaurant.com', 'admin'),
(4, 'Michael Brown', 'michael@example.com', 'customer'),
(5, 'Sarah Wilson', 'sarah@example.com', 'customer'),
(6, 'Robert Johnson', 'robert@example.com', 'customer'),
(7, 'Lisa Anderson', 'lisa@example.com', 'customer'),
(8, 'James Williams', 'james@example.com', 'customer'),
(9, 'Emily Taylor', 'emily@example.com', 'customer'),
(10, 'David Miller', 'david@example.com', 'customer'),
(11, 'Jennifer Garcia', 'jennifer@example.com', 'customer'),
(12, 'Daniel Martinez', 'daniel@example.com', 'customer'),
(13, 'Patricia Robinson', 'patricia@example.com', 'customer'),
(14, 'Thomas Lee', 'thomas@example.com', 'customer'),
(15, 'Nancy Rodriguez', 'nancy@example.com', 'customer');

-- Update sequence to continue after the inserted IDs
SELECT setval('users_id_seq', 15);

-- Tables data
INSERT INTO tables (id, name, capacity) VALUES
(1, 'Table A1', 4),
(2, 'Table B2', 2),
(3, 'Table C3', 6),
(4, 'Table D4', 8),
(5, 'Table E5', 4),
(6, 'Table F6', 2),
(7, 'Table G7', 10),
(8, 'Table H8', 6),
(9, 'Table I9', 4),
(10, 'Table J10', 8);

-- Update sequence
SELECT setval('tables_id_seq', 10);

-- Menus data
INSERT INTO menus (id, name, price, category) VALUES
(1, 'Steak', 250000.00, 'main'),
(2, 'Salad', 75000.00, 'appetizer'),
(3, 'Pasta', 125000.00, 'main'),
(4, 'Soup', 60000.00, 'appetizer'),
(5, 'Fish', 200000.00, 'main'),
(6, 'Rice', 35000.00, 'side'),
(7, 'Cake', 85000.00, 'dessert'),
(8, 'Ice Cream', 45000.00, 'dessert'),
(9, 'Coffee', 40000.00, 'beverage'),
(10, 'Tea', 35000.00, 'beverage'),
(11, 'Juice', 45000.00, 'beverage'),
(12, 'Wine', 180000.00, 'beverage'),
(13, 'Beer', 80000.00, 'beverage'),
(14, 'Chicken', 175000.00, 'main'),
(15, 'Burger', 150000.00, 'main');

-- Update sequence
SELECT setval('menus_id_seq', 15);

-- Add specific reservations from problem statement first
INSERT INTO reservations (id, user_id, table_id, start_time, end_time, status) VALUES
(1, 1, 2, '2025-05-18 18:00:00', '2025-05-18 20:00:00', 'ordered'),
(2, 2, 1, '2025-05-19 19:00:00', '2025-05-19 21:00:00', 'ordered'),
(3, 1, 3, '2025-05-20 18:00:00', '2025-05-20 20:00:00', 'pending');

-- Orders for specific reservations
INSERT INTO orders (id, reservation_id, menu_id, quantity, order_time) VALUES
(1, 1, 1, 2, '2025-05-18 18:15:00'),
(2, 1, 3, 1, '2025-05-18 18:15:00'),
(3, 2, 2, 1, '2025-05-19 19:10:00');
