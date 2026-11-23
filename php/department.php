<?php
//Lists Professors in deparrtment using a GET request to get the department id and then query the database for all professors in that department.
require_once 'config.php';

$conn = get_pdo_connection();

$dept_id = filter_input(INPUT_GET, 'id', FILTER_VALIDATE_INT);

if (!$dept_id || $dept_id < 1)
{
    http_response_code(400);
    exit("Invalid department id");
}

$query = $conn->prepare("
    SELECT p.first_name, p.last_name, p.title
    FROM professor AS p
    WHERE p.dept_id = ?
");

$query->execute([$dept_id]);
$professors = $query->fetchAll(PDO::FETCH_ASSOC);

//On click of a professor name, it will redirect to the professorpage.php with the professor id as a GET request.
// professorpage.php?id=prof_id
?>