<?php

// always enable strict mode
declare(strict_types=1);

/**
 * Singleton PDO connection for PostgreSQL.
 *
 * Adjust the constants (or move to env vars) to match your environment.
 */
const PG_HOST = '127.0.0.1';
const PG_PORT = 5432;
const PG_DB   = 'db_restaurant';
const PG_USER = 'postgres';
const PG_PASS = 'Dragonking7';

// PDO Connection (safe & reusable)
function pg(): PDO
{
    static $pdo = null;

    if ($pdo === null) {
        $dsn  = sprintf('pgsql:host=%s;port=%d;dbname=%s', PG_HOST, PG_PORT, PG_DB);
        $pdo  = new PDO($dsn, PG_USER, PG_PASS, [
            PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES   => false,
        ]);
    }

    return $pdo;
}

function getTopCustomers(string $start_date, string $end_date): ?array
{
    $sql =
        `
        SELECT tu.id, tu.name, COUNT(tao.id) as total_orders, SUM(tao.quantity) as total_quantity, SUM(tao.quantity * tm.price) AS total_amount
        FROM public.users tu
        JOIN public.reservations tr ON tu.id = tr.user_id
        JOIN public.orders tao ON tr.id = tao.reservation_id
        JOIN public.menus tm ON tao.menu_id = tm.id
        WHERE tr.status = 'ordered' AND tr.start_time >= :start_date AND tr.start_time <= :end_date'
        GROUP BY tu.id, tu.name
        ORDER BY total_amount DESC
        LIMIT 10
    `;
    $stmt = pg()->prepare($sql);
    $stmt->execute(
        [
            ':start_date' => $start_date,
            ':end_date' => $end_date,
        ]
    );
    return $stmt->fetch() ?: null;
}
