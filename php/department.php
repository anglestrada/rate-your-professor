<?php
//Lists Professors in deparrtment using a GET request to get the department id and then query the database for all professors in that department.
require_once 'config.php';

//chk_user(); //For later use to check if user is logged in and has access to this page.

$dept_id = filter_input(INPUT_GET, 'id', FILTER_VALIDATE_INT);
if (!$dept_id || $dept_id < 1) {
    http_response_code(400);
    exit("Invalid department id");
}

try {
    $dbh = get_pdo_connection();
    $query = $dbh->prepare("
    SELECT p.first_name, p.last_name, p.title, p.prof_id
    FROM professor AS p
    WHERE p.dept_id = ?");
} catch (PDOException $e) {
    echo "Connection failed: " . $e->getMessage();
    exit();
}

$query->execute([$dept_id]);
$professors = $query->fetchAll(PDO::FETCH_ASSOC);

if (!$professors) {
    http_response_code(404);
    exit("No professors found for this department");
}

//On click of a professor name, it will redirect to the professorpage.php with the professor id as a GET request.
// professorpage.php?id=prof_id
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Professors</title>
</head>

<body>
    <h1>Professors</h1>
    <ul>
        <?php foreach ($professors as $professor) : ?>
            <li><a href="professorpage.php?id=<?= htmlspecialchars($professor['prof_id']) ?>"><?= htmlspecialchars($professor['first_name']) . ' ' . htmlspecialchars($professor['last_name']) . ' ' . htmlspecialchars($professor['title']) ?></a></li>
        <?php endforeach; ?>
    </ul>