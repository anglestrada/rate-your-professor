<?php

function get_pdo_connection()
{
    $host = "localhost";
    $port = "3306";
    $database = "csubryp";
    $username = //Add your username
    $password = //Add your password
    return new PDO(
        "mysql:host=$host;port=$port;dbname=$database;charset=utf8mb4",
        $username,
        $password,
        [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC
        ]);
}