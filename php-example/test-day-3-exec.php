<?php

declare(strict_types=1);

require_once __DIR__ . '/test-day-3.php';

try {
    /* -------- CREATE -------- */
    $newId = addParcel('PKG-001', 'Jakarta', 2.75);
    echo "Inserted parcel id: {$newId} <br>";

    /* -------- READ -------- */
    $parcel = getParcel($newId);
    echo "<pre>Fetched: ";
    print_r($parcel);
    echo "</pre>";
;
    echo "<br>";

    /* -------- UPDATE -------- */
    if (updateWeight($newId, 3.10)) {
        echo "Weight updated. <br>";
    }

    echo "<br>";

    /* -------- READ (again) -------- */
    $parcel = getParcel($newId);
    echo "<pre>After update: ";
    print_r($parcel);
    echo "</pre>";

    /* -------- DELETE -------- */
    if (deleteParcel($newId)) {
        echo "Parcel deleted. <br>";
    }

    echo "<br>";

    /* -------- READ (should be null) -------- */
    var_dump(getParcel($newId)); // expected: NULL
} catch (Throwable $e) {
    echo "Error: {$e->getMessage()} <br>";
}
