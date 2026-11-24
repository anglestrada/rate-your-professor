<?php
require_once 'config.php';

// chk_user();

try {
    $dbh = get_pdo_connection();

    // Get search input
    $search = trim($_GET['search'] ?? '');

    $professors = [];
    $courses = [];

    if ($search !== '') {

        // Search professors by first name, last name,
        // or full name.
        $profQuery = $dbh->prepare("
            SELECT
                p.prof_id,
                p.first_name,
                p.last_name,
                p.title,
                d.dept_name
            FROM professor AS p
            JOIN department AS d
                ON p.dept_id = d.dept_id
            WHERE p.first_name LIKE ?
                OR p.last_name LIKE ?
                OR CONCAT(p.first_name, ' ', p.last_name) LIKE ?
            ORDER BY p.last_name, p.first_name
        ");

        $searchParam = '%' . $search . '%';

        $profQuery->execute([
            $searchParam,
            $searchParam,
            $searchParam
        ]);

        $professors = $profQuery->fetchAll(PDO::FETCH_ASSOC);

        // Search courses by subject, course number,
        // or both together (example: CMPS 2010).
        $courseQuery = $dbh->prepare("
            SELECT
                c.course_id,
                c.subject,
                c.course_number,
                c.title,
                d.dept_name
            FROM course AS c
            JOIN department AS d
                ON c.dept_id = d.dept_id
            WHERE c.subject LIKE ?
                OR CAST(c.course_number AS CHAR) LIKE ?
                OR CONCAT(c.subject, ' ', c.course_number) LIKE ?
                OR CONCAT(c.subject, c.course_number) LIKE ?
            ORDER BY c.subject, c.course_number
        ");

        $courseQuery->execute([
            $searchParam,
            $searchParam,
            $searchParam,
            $searchParam
        ]);

        $courses = $courseQuery->fetchAll(PDO::FETCH_ASSOC);
    }

    // Departments always appear at the bottom.
    $deptQuery = $dbh->query("
        SELECT
            dept_id,
            dept_name
        FROM department
        ORDER BY dept_name ASC
    ");

    $departments = $deptQuery->fetchAll(PDO::FETCH_ASSOC);

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

    <title>Professor and Course Search</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            color: #222;
        }

        .container {
            max-width: 1000px;
            margin: auto;
            padding: 30px;
        }

        .search-section {
            min-height: 65vh;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
        }

        .search-section h1 {
            font-size: 36px;
        }

        .search-form {
            display: flex;
            width: 100%;
            max-width: 650px;
            gap: 10px;
        }

        .search-form input {
            flex: 1;
            min-width: 0;
            padding: 15px;
            font-size: 16px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }

        .search-form button {
            padding: 15px 25px;
            border: none;
            border-radius: 6px;
            background: #333;
            color: white;
            cursor: pointer;
        }

        .results-section {
            margin-bottom: 60px;
        }

        .result {
            padding: 15px;
            border-bottom: 1px solid #ddd;
        }

        .result a {
            text-decoration: none;
            color: #0056b3;
        }

        .result a:hover {
            text-decoration: underline;
        }

        .departments-section {
            border-top: 1px solid #ddd;
            padding-top: 40px;
            padding-bottom: 80px;
        }

        .department-list {
            display: grid;
            grid-template-columns:
                repeat(auto-fit, minmax(230px, 1fr));
            gap: 15px;
        }

        .department {
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 6px;
        }

        .department a {
            color: #0056b3;
            text-decoration: none;
        }
    </style>
</head>

<body>
<div class="container">

    <!-- Search bar -->
    <section class="search-section">

        <h1>CSUB Rate Your Professor</h1>

        <p>
            Search by professor name, course subject,
            or course number.
        </p>

        <form method="GET"
              action="index.php"
              class="search-form">

            <input
                type="search"
                name="search"
                placeholder="Professor name or CMPS 2010"
                value="<?= htmlspecialchars($search) ?>"
                required
            >

            <button type="submit">
                Search
            </button>

        </form>

    </section>

    <!-- Search results -->
    <?php if ($search !== ''): ?>

        <section class="results-section">

            <h2>
                Search Results for
                "<?= htmlspecialchars($search) ?>"
            </h2>

            <h3>Professors</h3>

            <?php if (empty($professors)): ?>
                <p>No professors found.</p>
            <?php else: ?>

                <?php foreach ($professors as $professor): ?>
                    <div class="result">

                        <a href="professorpage.php?id=<?= urlencode($professor['prof_id']) ?>">
                            <?= htmlspecialchars($professor['first_name']) ?>
                            <?= htmlspecialchars($professor['last_name']) ?>
                        </a>

                        <p>
                            <?= htmlspecialchars($professor['title'] ?? '') ?>
                        </p>

                        <p>
                            Department:
                            <?= htmlspecialchars($professor['dept_name']) ?>
                        </p>

                    </div>
                <?php endforeach; ?>

            <?php endif; ?>

            <h3>Courses</h3>

            <?php if (empty($courses)): ?>
                <p>No courses found.</p>
            <?php else: ?>

                <?php foreach ($courses as $course): ?>
                    <div class="result">

                        <a href="courses.php?id=<?= urlencode($course['course_id']) ?>">
                            <?= htmlspecialchars($course['subject']) ?>
                            <?= htmlspecialchars($course['course_number']) ?>
                            -
                            <?= htmlspecialchars($course['title']) ?>
                        </a>

                        <p>
                            Department:
                            <?= htmlspecialchars($course['dept_name']) ?>
                        </p>

                    </div>
                <?php endforeach; ?>

            <?php endif; ?>

        </section>

    <?php endif; ?>

    <!-- Departments at bottom -->
    <section class="departments-section">

        <h2>Browse Departments</h2>

        <div class="department-list">

            <?php foreach ($departments as $department): ?>

                <div class="department">

                    <a href="department.php?id=<?= urlencode($department['dept_id']) ?>">
                        <?= htmlspecialchars($department['dept_name']) ?>
                    </a>

                </div>

            <?php endforeach; ?>

        </div>

    </section>

</div>
</body>
</html>