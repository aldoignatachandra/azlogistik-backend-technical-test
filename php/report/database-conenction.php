<?php

declare(strict_types=1);

require_once __DIR__ . '/../utils/EnvLoader.php';

// Load environment variables
EnvLoader::load(__DIR__ . '/../.env');

/**
 * Database connection class using Singleton pattern
 */
class DatabaseConnection
{
    /** @var ?\PDO */
    private static ?PDO $instance = null;

    /** @var array PDO options */
    private static array $options = [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::ATTR_EMULATE_PREPARES => false,
    ];

    /**
     * Private constructor to prevent direct instantiation
     */
    private function __construct() {}

    /**
     * Get PDO instance (creates one if it doesn't exist)
     *
     * @return \PDO
     */
    public static function getInstance(): PDO
    {
        if (self::$instance === null) {
            $host = EnvLoader::get('PG_HOST', '127.0.0.1');
            $port = EnvLoader::get('PG_PORT', 5432);
            $dbname = EnvLoader::get('PG_DB', 'db_restaurant');
            $username = EnvLoader::get('PG_USER', 'postgres');
            $password = EnvLoader::get('PG_PASS', '');

            $dsn = sprintf('pgsql:host=%s;port=%d;dbname=%s', $host, $port, $dbname);

            try {
                self::$instance = new PDO($dsn, $username, $password, self::$options);
            } catch (\PDOException $e) {
                throw new \PDOException(
                    sprintf('Database connection failed: %s', $e->getMessage()),
                    (int)$e->getCode(),
                    $e
                );
            }
        }

        return self::$instance;
    }

    /**
     * Prevent cloning of the instance
     */
    private function __clone() {}

    /**
     * Prevent unserialization of the instance
     */
    public function __wakeup()
    {
        throw new \Exception('Cannot unserialize singleton');
    }
}

/**
 * Helper function to get database connection
 *
 * @return \PDO
 */
function db(): PDO
{
    return DatabaseConnection::getInstance();
}
