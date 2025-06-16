<?php

// always enable strict mode
declare(strict_types=1);

// Singleton PDO connection for PostgreSQL.
const PG_HOST = '127.0.0.1';
const PG_PORT = 5432;
const PG_DB   = 'db_restaurant';
const PG_USER = 'postgres';
const PG_PASS = 'Dragonking7';

function db(): PDO
{
    static $pdo = null;
    if ($pdo === null) {
        $pdo = new PDO(
            sprintf('pgsql:host=%s;port=%d;dbname=%s', getenv('PG_HOST') ?: PG_HOST, getenv('PG_PORT') ?: PG_PORT, getenv('PG_DB') ?: PG_DB),
            getenv('PG_USER') ?: PG_USER,
            getenv('PG_PASS') ?: PG_PASS,
            [
                PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            ]
        );
    }
    return $pdo;
}
