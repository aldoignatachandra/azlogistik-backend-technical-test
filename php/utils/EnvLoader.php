<?php

declare(strict_types=1);

class EnvLoader
{
    /**
     * Load environment variables from .env file
     *
     * @param string $path Path to .env file
     * @return void
     */
    public static function load(string $path): void
    {
        if (!file_exists($path)) {
            throw new \RuntimeException(sprintf('Environment file not found: %s', $path));
        }

        $lines = file($path, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
        foreach ($lines as $line) {
            // Skip comments
            if (strpos(trim($line), '#') === 0) {
                continue;
            }

            list($name, $value) = explode('=', $line, 2);
            $name = trim($name);
            $value = trim($value);

            // Remove quotes if present
            if (preg_match('/^(["\'])(.*)\1$/', $value, $matches)) {
                $value = $matches[2];
            }

            // Only set if not already set in environment
            if (!isset($_ENV[$name]) && !isset($_SERVER[$name])) {
                $_ENV[$name] = $value;
                $_SERVER[$name] = $value;
                putenv(sprintf('%s=%s', $name, $value));
            }
        }
    }

    /**
     * Get environment variable with fallback
     *
     * @param string $key Environment variable name
     * @param mixed $default Default value if not found
     * @return mixed
     */
    public static function get(string $key, $default = null)
    {
        return $_ENV[$key] ?? $_SERVER[$key] ?? getenv($key) ?: $default;
    }
}
