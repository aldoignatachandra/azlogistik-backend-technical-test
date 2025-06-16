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
const PG_DB   = 'logistics';
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

/* ---------- CRUD helpers for table parcels ---------- */

function addParcel(string $code, string $dest, float $weight): int
{
    $sql = 'INSERT INTO parcels (code, destination, weight) VALUES (:code, :dest, :weight) RETURNING id';
    $stmt = pg()->prepare($sql);
    $stmt->execute([
        ':code'   => $code,
        ':dest'   => $dest,
        ':weight' => $weight,
    ]);
    return (int)$stmt->fetchColumn();
}

function getParcel(int $id): ?array
{
    $sql = 'SELECT * FROM parcels WHERE id = :id';
    $stmt = pg()->prepare($sql);
    $stmt->execute([':id' => $id]);
    return $stmt->fetch() ?: null;
}

function updateWeight(int $id, float $weight): bool
{
    $sql = 'UPDATE parcels SET weight = :w WHERE id = :id';
    $stmt = pg()->prepare($sql);
    $stmt->execute([':w' => $weight, ':id' => $id]);
    return $stmt->rowCount() === 1;
}

function deleteParcel(int $id): bool
{
    $sql = 'DELETE FROM parcels WHERE id = :id';
    $stmt = pg()->prepare($sql);
    $stmt->execute([':id' => $id]);
    return $stmt->rowCount() === 1;
}
