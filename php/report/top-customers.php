<?php

declare(strict_types=1);

require_once __DIR__ . '/database-conenction.php';

try {
    /* -------- Get Data Top Customer -------- */
    $start_data = "2025-03-19";
    $end_data = "2025-05-18";
    $data_top_customers = getTopCustomers($start_data, $end_data);
    echo "<pre>Top Customers: ";
    print_r($data_top_customers);
    echo "</pre>";
} catch (Throwable $e) {
    echo "Error: {$e->getMessage()} <br>";
}
