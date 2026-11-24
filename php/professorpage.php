<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

require_once 'config.php';

// chk_user();

$id = filter_input(INPUT_GET, 'id', FILTER_VALIDATE_INT);

if (!$id || $id < 1) {
    http_response_code(400);
    exit("Invalid professor id");
}

try {
    $conn = get_pdo_connection();

    // Professor information
    $query = $conn->prepare("
        SELECT
            p.first_name,
            p.last_name,
            p.title,
            d.dept_name AS department
        FROM professor AS p
        JOIN department AS d
            ON p.dept_id = d.dept_id
        WHERE p.prof_id = ?
    ");

    $query->execute([$id]);
    $professor = $query->fetch(PDO::FETCH_ASSOC);

    if (!$professor) {
        http_response_code(404);
        exit("Professor Not Found");
    }

    // Professor ratings
    $ratingQuery = $conn->prepare("
        SELECT
            AVG(r.rating) AS average_rating,
            AVG(r.would_retake) * 100 AS retake_percent,
            AVG(r.difficulty) AS average_difficulty
        FROM review AS r
        JOIN teaching AS t
            ON r.teaching_id = t.teaching_id
        JOIN content AS c
            ON r.review_id = c.content_id
        WHERE t.prof_id = ?
            AND c.status = 'visible'
    ");

    $ratingQuery->execute([$id]);
    $ratingStats = $ratingQuery->fetch(PDO::FETCH_ASSOC);

    // Grade distribution
    $gradeQuery = $conn->prepare("
        SELECT
            r.grade,
            COUNT(*) AS grade_count
        FROM review AS r
        JOIN teaching AS t
            ON r.teaching_id = t.teaching_id
        JOIN content AS c
            ON r.review_id = c.content_id
        WHERE t.prof_id = ?
            AND c.status = 'visible'
        GROUP BY r.grade
        ORDER BY r.grade
    ");

    $gradeQuery->execute([$id]);
    $gradeStats = $gradeQuery->fetchAll(PDO::FETCH_ASSOC);

    // Courses taught by professor
    // Group terms under each course.
    $courseQuery = $conn->prepare("
        SELECT
            c.course_id,
            c.subject,
            c.course_number,
            c.title,
            d.dept_name,

            GROUP_CONCAT(
                DISTINCT CONCAT(tt.season, ' ', tt.term_year)
                ORDER BY
                    tt.term_year ASC,
                    FIELD(
                        tt.season,
                        'Spring',
                        'Summer',
                        'Fall',
                        'Winter'
                    )
                SEPARATOR ', '
            ) AS terms

        FROM teaching AS t

        JOIN course AS c
            ON t.course_id = c.course_id

        JOIN department AS d
            ON c.dept_id = d.dept_id

        LEFT JOIN term AS tt
            ON t.term_id = tt.term_id

        WHERE t.prof_id = ?

        GROUP BY
            c.course_id,
            c.subject,
            c.course_number,
            c.title,
            d.dept_name

        ORDER BY
            c.subject,
            c.course_number
    ");

    $courseQuery->execute([$id]);
    $courses = $courseQuery->fetchAll(PDO::FETCH_ASSOC);
} catch (PDOException $e) {
    error_log($e->getMessage());
    http_response_code(500);
    exit("Database error");
}
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport"
        content="width=device-width, initial-scale=1.0">

    <title>
        <?= htmlspecialchars(
            $professor['first_name'] . ' ' .
                $professor['last_name']
        ) ?>
    </title>

    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            color: #222;
        }

        .container {
            max-width: 1000px;
            margin: auto;
            padding: 30px;
        }

        .professor-header {
            margin-bottom: 35px;
        }

        .stats {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            margin-bottom: 40px;
        }

        .stat-card {
            border: 1px solid #ddd;
            border-radius: 6px;
            padding: 20px;
            min-width: 150px;
        }

        .stat-card h3 {
            margin: 0 0 10px;
        }

        .course {
            padding: 20px;
            margin-bottom: 15px;
            border: 1px solid #ddd;
            border-radius: 6px;
        }

        .course h3 {
            margin-top: 0;
        }

        a {
            color: #0056b3;
            text-decoration: none;
        }

        a:hover {
            text-decoration: underline;
        }

        .grades {
            margin-top: 40px;
        }

        .grade-row {
            padding: 8px 0;
            border-bottom: 1px solid #eee;
        }
    </style>
</head>

<body>
    <div class="container">

        <p>
            <a href="index.php">Back to Search</a>
        </p>

        <!-- Professor information -->
        <section class="professor-header">

            <h1>
                <?= htmlspecialchars($professor['first_name']) ?>
                <?= htmlspecialchars($professor['last_name']) ?>
            </h1>

            <p>
                <?= htmlspecialchars($professor['title'] ?? '') ?>
            </p>

            <p>
                Department:
                <?= htmlspecialchars($professor['department']) ?>
            </p>

        </section>

        <!-- Ratings -->
        <section>

            <h2>Professor Ratings</h2>

            <?php if ($ratingStats['average_rating'] !== null): ?>

                <div class="stats">

                    <div class="stat-card">
                        <h3>Overall Rating</h3>
                        <p>
                            <?= number_format($ratingStats['average_rating'], 1) ?>
                            / 5
                        </p>
                    </div>

                    <div class="stat-card">
                        <h3>Would Retake</h3>
                        <p>
                            <?php if ($ratingStats['retake_percent'] !== null): ?>
                                <?= number_format($ratingStats['retake_percent'], 0) ?>%
                            <?php else: ?>
                                N/A
                            <?php endif; ?>
                        </p>
                    </div>

                    <div class="stat-card">
                        <h3>Difficulty</h3>
                        <p>
                            <?php if ($ratingStats['average_difficulty'] !== null): ?>
                                <?= number_format($ratingStats['average_difficulty'], 1) ?>
                                / 5
                            <?php else: ?>
                                N/A
                            <?php endif; ?>
                        </p>
                    </div>

                </div>

            <?php else: ?>

                <p>No reviews yet.</p>

            <?php endif; ?>

        </section>

        <!-- Teaching history -->
        <section>

            <h2>Courses Taught</h2>

            <?php if (empty($courses)): ?>

                <p>No teaching history available.</p>

            <?php else: ?>

                <?php foreach ($courses as $course): ?>

                    <div class="course">

                        <h3>
                            <a href="courses.php?id=<?= urlencode($course['course_id']) ?>">
                                <?= htmlspecialchars($course['subject']) ?>
                                <?= htmlspecialchars($course['course_number']) ?>
                                -
                                <?= htmlspecialchars($course['title']) ?>
                            </a>
                        </h3>

                        <p>
                            Department:
                            <?= htmlspecialchars($course['dept_name']) ?>
                        </p>

                        <p>
                            Terms:
                            <?= htmlspecialchars($course['terms'] ?? 'TBA') ?>
                        </p>

                    </div>

                <?php endforeach; ?>

            <?php endif; ?>

        </section>

        <!-- Grade distribution -->
        <section class="grades">

            <h2>Grade Distribution</h2>

            <?php if (empty($gradeStats)): ?>

                <p>No grade information available.</p>

            <?php else: ?>

                <?php foreach ($gradeStats as $grade): ?>

                    <?php if (
                        $grade['grade'] !== null &&
                        $grade['grade'] !== ''
                    ): ?>

                        <div class="grade-row">
                            <?= htmlspecialchars($grade['grade']) ?>:
                            <?= htmlspecialchars($grade['grade_count']) ?>
                        </div>

                    <?php endif; ?>

                <?php endforeach; ?>

            <?php endif; ?>

        </section>

    </div>
</body>

</html>