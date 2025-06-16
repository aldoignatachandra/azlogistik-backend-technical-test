-- Soal 1 – Query Top Customers by Spending

SELECT tu.id, tu.name, 
    COUNT(tao.id) as total_orders, 
    SUM(tao.quantity) as total_quantity, 
    SUM(tao.quantity * tm.price) AS total_amount
FROM public.users tu
JOIN public.reservations tr ON tu.id = tr.user_id
JOIN public.orders tao ON tr.id = tao.reservation_id
JOIN public.menus tm ON tao.menu_id = tm.id
WHERE tr.status = 'ordered' AND tr.start_time >= CURRENT_DATE - INTERVAL '60 Days'
GROUP BY tu.id, tu.name
ORDER BY total_amount DESC
LIMIT 10
