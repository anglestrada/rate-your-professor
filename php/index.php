<?php
//Lists Departments - Click on a department to see all professors in that department department.php?id=
//I personally want to have a search bar to search for professors or departments or classes and then 
//see the deparments list.
require_once 'config.php';

//chk_user(); //For later use to check if user is logged in and has access to this page.

global $dbh; //Index always runs first so globals can go here.

try {
    $dbh = get_pdo_connection();
    $select = $dbh->prepare("SELECT * FROM department ORDER BY dept_name DESC");
    $select->execute();
    $dept_info = $select->fetchAll(PDO::FETCH_ASSOC);
} catch (PDOException $e) {
    echo "Connection failed: " . $e->getMessage();
    exit();
}
//include 'navbar.php'; For Later use 
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Departments</title>
</head>

<body>
    <h1>Departments</h1>
    <ul>
        <?php foreach ($dept_info as $department) : ?>
            <li><a href="department.php?id=<?= htmlspecialchars($department['dept_id']) ?>"><?= htmlspecialchars($department['dept_name']) ?></a></li>
        <?php endforeach; ?>
    </ul>