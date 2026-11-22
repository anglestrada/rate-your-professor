<?php
ini_set('display_errors', '1');
ini_set('display_startup_errors', '1');
error_reporting(E_ALL);

require_once "config.php";
try
{
    $conn = get_pdo_connection();
    $database = $conn->query("SELECT DATABASE()")->fetchColumn();

    echo "Connected successfully to: " . htmlspecialchars($database);
}
catch (PDOException $e)
{
    echo "Database connection failed.";
    error_log($e->getMessage());
}