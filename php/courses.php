<?php
require_once 'config.php';

//chk_user();

$course_id = filter_input(INPUT_GET, 'id', FILTER_VALIDATE_INT) ?? -1;

try {
    $dbh = get_pdo_connection();

    if ($course_id != -1) {

        // Get information for one course
        $query = $dbh->prepare("
            SELECT
                c.title, c.course_number, c.dept_id, c.course_id, c.subject,
                d.dept_name,
                p.first_name, p.last_name, p.prof_id,
                t.teaching_id, t.term_id,
                GROUP_CONCAT(
            DISTINCT CONCAT(tt.season, ' ', tt.term_year, ' ', t.modality)
            ORDER BY tt.term_year ASC,
                FIELD(tt.season, 'Spring', 'Summer', 'Fall', 'Winter')
            SEPARATOR ', '
        ) AS terms
            FROM course AS c
            JOIN department AS d
                ON c.dept_id = d.dept_id
            LEFT JOIN teaching AS t
                ON c.course_id = t.course_id
            LEFT JOIN professor AS p
                ON t.prof_id = p.prof_id
            LEFT JOIN term AS tt
                ON t.term_id = tt.term_id
            WHERE c.course_id = ?
        GROUP BY
        c.course_id, c.title, c.course_number, c.dept_id, c.subject,
        d.dept_name,
        p.prof_id, p.first_name, p.last_name
        ORDER BY p.last_name ASC
        ");

        $query->execute([$course_id]);
        $courses = $query->fetchAll(PDO::FETCH_ASSOC);

        if (empty($courses)) {
            http_response_code(404);
            exit("Course not found");
        }
    } else {

        // Get all courses
        $query = $dbh->prepare("
            SELECT
                c.title, c.course_number, c.dept_id, c.course_id, c.subject,
                d.dept_name
            FROM course AS c
            JOIN department AS d
                ON c.dept_id = d.dept_id
            ORDER BY c.course_number ASC
        ");

        $query->execute();
        $courses = $query->fetchAll(PDO::FETCH_ASSOC);
    }
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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>
        <?= $course_id ? 'Course Details' : 'All Courses' ?>
    </title>
</head>

<body>

    <?php if ($course_id != -1): ?>

        <h1>Course Details</h1>
        <?php foreach ($courses as $course): ?>
            <div>
                <h2>
                    <?= htmlspecialchars($course['subject']) ?>
                    <?= htmlspecialchars($course['course_number']) ?>
                    -

                    <?= htmlspecialchars($course['title']) ?>
                </h2>

                <p>
                    Department:
                    <?= htmlspecialchars($course['dept_name']) ?>
                </p>

                <p>
                    Professor:
                    <?php if ($course['prof_id'] !== null): ?>
                        <a href="professorpage.php?id=<?= urlencode($course['prof_id']) ?>">
                            <?= htmlspecialchars($course['first_name']) ?>
                            <?= htmlspecialchars($course['last_name']) ?>
                        </a>
                <p>
                    Term:
                    <?= htmlspecialchars($course['terms'] ?? 'TBA') ?>
                </p>

            <?php else: ?>
                TBA
            <?php endif; ?>
            </p>
            </div>
        <?php endforeach; ?>

    <?php else: ?>

        <h1>All Courses</h1>

        <ul>
            <?php foreach ($courses as $course): ?>
                <li>
                    <a href="courses.php?id=<?= urlencode($course['course_id']) ?>">
                        <?= htmlspecialchars($course['subject']) ?>
                        <?= htmlspecialchars($course['course_number']) ?>
                        -
                        <?= htmlspecialchars($course['title']) ?>
                    </a>
                </li>
            <?php endforeach; ?>
        </ul>

    <?php endif; ?>

</body>

</html>