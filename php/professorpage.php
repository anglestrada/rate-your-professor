<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);
require_once ("config.php");

$conn = get_pdo_connection();

//For testing the URL has to have a prof_id
$id = filter_input(INPUT_GET, 'id', FILTER_VALIDATE_INT);

if (!$id || $id < 1)
{
    http_response_code(400);
    exit("invalid professor id");
}

$query = $conn->prepare("
    SELECT p.first_name, p.last_name, p.title,
           d.dept_name AS department
    FROM professor AS p
    JOIN department AS d ON p.dept_id = d.dept_id
    WHERE p.prof_id = ?
");

$ratingQuery = $conn->prepare("
    SELECT AVG(r.rating) AS average_rating,
    AVG(r.would_retake) * 100 AS retake_percent,
    AVG(r.difficulty) AS average_difficulty
    FROM review AS r
    JOIN teaching AS t ON r.teaching_id = t.teaching_id
    JOIN content AS c ON r.review_id = c.content_id
    WHERE t.prof_id = ?
      AND c.status = 'visible'
");

$gradeQuery = $conn->prepare("
    SELECT r.grade, COUNT(*) AS grade_count 
    FROM review AS r 
    JOIN teaching AS t ON r.teaching_id = t.teaching_id 
    JOIN content AS c ON r.review_id = c.content_id 
    WHERE prof_id = ? 
    GROUP BY r.grade 
    ORDER BY r.grade;
");

$reviewQuery = $conn->prepare("
    SELECT c.body, c.created_at, r.rating, r.difficulty, r.grade
    FROM review AS r
    JOIN teaching AS t ON r.teaching_id = t.teaching_id
    JOIN content AS c ON r.review_id = c.content_id
    WHERE t.prof_id = ?
    AND c.status = 'visible'
    ORDER BY c.created_at DESC
");

$query->execute([$id]);
$professor = $query->fetch(PDO::FETCH_ASSOC);

$ratingQuery->execute([$id]);
$ratingStats = $ratingQuery->fetch(PDO::FETCH_ASSOC);

$gradeQuery->execute([$id]);
$gradeStats = $gradeQuery->fetchAll(PDO::FETCH_ASSOC);

$reviewQuery->execute([$id]);
$reviewStats = $reviewQuery->fetchAll(PDO::FETCH_ASSOC);

if (!$professor)
{
    http_response_code(404);
    exit("Professor Not Found :)");
}
?>

<h2>
    <?php 
    echo htmlspecialchars(
        $professor['first_name']. ' '. $professor['last_name']. ' '. $professor['title']. ' '. $professor['department']
    );
    ?>
    <br>
    <?php
    if ($ratingStats['average_rating'] !== null)
    {
        echo number_format($ratingStats['average_rating'], 0) . ' / 5' .'<br>';
        
        if ($ratingStats['retake_percent'] != NULL)
        {
            echo number_format($ratingStats['retake_percent'], 0) . '%'. '<br>'; 
        }
        else
        {
            echo "No Percent Available";
        }

        echo number_format($ratingStats['average_difficulty'], 0); 
    }
    else
    {
        echo "No reviews yet";
    }

    
    ?>
    <br>
    <br>
    <?php
    if (count($reviewStats) === 0) {
    echo '<p>No reviews yet.</p>';
}

for ($i = 0; $i < count($reviewStats); $i++)
{
    echo '<div class="review">';

    echo '<p>Rating: '. htmlspecialchars($reviewStats[$i]['rating']). ' / 5</p>';

    echo '<p>Difficulty:'. htmlspecialchars($reviewStats[$i]['difficulty']). ' / 5</p>';

    echo '<p>Grade: '. htmlspecialchars($reviewStats[$i]['grade'] ?? 'Not reported'). '</p>';

    echo '<p>'. nl2br(htmlspecialchars($reviewStats[$i]['body'])). '</p>';

    echo '</div>';
}
    ?>
</h2>