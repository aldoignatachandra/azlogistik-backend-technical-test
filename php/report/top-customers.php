<?php

declare(strict_types=1);
require_once __DIR__ . '/database-conenction.php';

// Define Params Start AND End Date 
$start = $_GET['start_date'] ?? date('Y-m-d', strtotime('-60 days'));
$end   = $_GET['end_date']   ?? date('Y-m-d');

// query1.sql ( Query Top Customers by Spending Search By Start Date & End Date Reservations )
$sql = "
    SELECT tu.id AS user_id, tu.name, tu.email, COUNT(DISTINCT tr.id) AS visit_count, COUNT(tao.id) as total_orders, SUM(tao.quantity) as total_quantity, SUM(tao.quantity * tm.price) AS total_spent 
    FROM public.users tu 
    JOIN public.reservations tr ON tu.id = tr.user_id 
    JOIN public.orders tao ON tr.id = tao.reservation_id JOIN public.menus tm ON tao.menu_id = tm.id 
    WHERE tr.status = 'ordered' AND tr.start_time >= :s AND tr.end_time <= :e 
    GROUP BY tu.id, tu.name 
    ORDER BY total_spent DESC LIMIT 10
";
$stmt = db()->prepare($sql);
$stmt->execute([':s' => $start, ':e' => $end]);
$top = $stmt->fetchAll();

// Find Total Unique Customers
$totalUnique = db()->prepare("
    SELECT COUNT(DISTINCT u.id)
    FROM users u
    JOIN reservations r ON r.user_id = u.id
    WHERE r.status = 'ordered' AND r.start_time BETWEEN :s AND :e
");
$totalUnique->execute([':s' => $start, ':e' => $end]);
$uniqueCount = (int)$totalUnique->fetchColumn();

// Ranked Customers Based On Total Spent + Additonal Data For User Favourite Menu
$ranked = [];
foreach ($top as $idx => $row) {
    $fav = db()->prepare("
        SELECT m.name
        FROM orders o
        JOIN menus m ON m.id = o.menu_id
        WHERE o.reservation_id IN (
            SELECT id FROM reservations
            WHERE user_id = :uid
              AND status = 'ordered'
              AND start_time BETWEEN :s AND :e
        )
        GROUP BY m.name
        ORDER BY SUM(o.quantity) DESC
        LIMIT 1
    ");
    $fav->execute([':uid' => $row['user_id'], ':s' => $start, ':e' => $end]);
    $row['favorite_menu'] = $fav->fetchColumn();
    $row['rank'] = $idx + 1;
    $row['total_spent'] = (int)$row['total_spent'];
    $row['average_per_visit'] = (int)$row['total_spent'] / (int)$row['total_orders'];
    $row['visit_count'] = (int)$row['visit_count'];
    $ranked[] = $row;
}

// Set API Response ( JSON )
header('Content-Type: application/json');
echo json_encode([
    'period'                 => "$start hingga $end",
    'total_unique_customers' => $uniqueCount,
    'top_customers'          => $ranked
]);

// Execute File PHP
// php -S localhost:8000 -t php

// Execute Url ( Format )
// http://localhost:8000/report/top-customers.php?start_date=YYYY-MM-DD&end_date=YYYY-MM-DD

// Execute Url ( Example )
// http://localhost:8000/report/top-customers.php?start_date=2025-03-19&end_date=2025-05-18
