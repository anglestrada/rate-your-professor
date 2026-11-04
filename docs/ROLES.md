# Team roles

Login lives in the Flask app, so **anything that needs to know who the user is
goes in Flask**. The PHP site is the public side anyone can browse. Both talk to
the same `csubryp` database.

| Person | Stack | Owns |
|---|---|---|
| Danny | Flask | Registration and login, accounts, admin user tools, professor/course requests, ranking and similarity math |
| Gael | Flask | Writing reviews, comments, votes, reports, moderation |
| Angel | PHP | Shared PHP layout, departments, courses, search, mock data, schema reviews |
| Marianno | PHP | Professor pages, stats, leaderboard, ER diagram |

Everyone works on their own branch (`dan`, `gale`, `angle`, `mar`) and opens a
PR into `main`.

---

## Danny: accounts, login and ranking math (Flask)

**Build these first. Gael's pages depend on them.**

- [ ] **Register** (`/register`): username, email, password, class year.
  Hash the password with the `bcrypt` package, then `INSERT INTO users`. A
  duplicate email or username fails with MariaDB error 1062 (`uq_users_email`,
  `uq_users_username`). Show a friendly message instead of the error.
- [ ] **Log in / log out** (`/login`, `/logout`): check the password with
  bcrypt and turn away `suspended` and `banned` users. Then update `last_login`
  and store `user_id` and `user_type` in the Flask session.
- [ ] **`login_required` and `admin_required`** decorators that the rest of the
  Flask app puts on its routes.
- [ ] Add `SECRET_KEY` (needed for Flask sessions) and `PHP_URL` to `.env.example`.
- [ ] **Test logins:** replace the placeholder hashes in `sql/data.sql` with
  real bcrypt hashes of one shared test password, so everyone can log in as the
  mock users.

**Then:**

- [ ] **Account page** (`/account`): your reviews and comments (`content` →
  `review` → `teaching` → `professor`).
- [ ] **Request a professor or course** (`/submit`): `INSERT INTO submission`.
- [ ] **Approve or reject requests** (`/admin/submissions`). Approving runs as
  one transaction: insert the new `professor` or `course`, then set the
  submission to `approved` with `reviewed_at`. Rejecting needs a
  `reject_reason`, or `chk_submission_reject` refuses the update.
- [ ] **Manage users** (`/admin/users`): suspend, ban or reactivate
  (`users.user_status`).

**Ranking math**, as SQL views in `sql/views.sql`. These are views, so the PHP
pages can `SELECT` from them too. Count only reviews whose `content.status` is
`visible`.

- [ ] **`v_professor_score`** `(prof_id, review_count, avg_rating,
  avg_difficulty, score)`. `score` is a confidence-weighted rating:
  `score = (C·m + sum of ratings) / (C + n)`, where `m` is the campus-wide
  average, `n` is the professor's review count, and `C` is the prior weight
  (start with 5). A professor with one 5-star review shouldn't outrank one with
  forty 4.8s. This is the scalar Bayesian/Kalman update: a prior fused with
  `n` equally noisy measurements, where `C` is the ratio of measurement
  variance to prior variance.
- [ ] **`v_professor_similarity`** `(prof_id, other_prof_id, similarity)`.
  Each professor is a vector in ℝ¹⁰, one entry per tag, holding how often
  reviewers applied that tag. Similarity is cosine similarity,
  `a·b / (‖a‖ ‖b‖)`. In SQL: self-join the per-professor tag counts on
  `tag_id`, `SUM(a.cnt * b.cnt)` for the dot product, and
  `SQRT(SUM(cnt * cnt))` for each norm. It's the same math as matching
  feature descriptors in perception.
- [ ] *Stretch:* PCA (NumPy SVD) of each professor's feature vector (rating,
  difficulty, retake %, tag vector), plotted as a 2D map for the presentation.

**SQL you'll show:** unique constraints and error handling, transactions,
`UPDATE`s with `CHECK` constraints, views with aggregates and self-joins.

---

## Gael: reviews and interaction (Flask)

Put `login_required` (from Danny) on every route below. Until it's ready, use a
hard-coded test `user_id`.

- [ ] **Write a review** (`/review/new`): pick the professor, course and term
  (a `teaching` row). Then rating and difficulty (1–5), grade, attendance,
  textbook, would-retake, and tags as checkboxes. Save it in one
  **transaction**: `INSERT INTO content` → `LAST_INSERT_ID()` →
  `INSERT INTO review` with that id → `INSERT INTO review_tag` rows. Roll back
  if any step fails. This is the supertype/subtype design from our document
  (option 8a).
- [ ] **Review page** (`/review/<id>`): one review with its vote, reply and
  report buttons. The PHP pages link here.
- [ ] **Edit or delete your own review**, only when `content.user_id` matches
  the logged-in user. Deleting the review's `content` row cascades to
  `review`, `review_tag`, `vote` and the review's `comment` rows. It does
  **not** delete the comments' own `content` rows (cascades only go from
  `content` down), so delete those first, in the same transaction.
- [ ] **Comments and replies**: `content` plus `comment`, using
  `parent_comment_id` for replies.
- [ ] **Votes**: one per user per review or comment (`uq_vote_once`). Use
  `INSERT ... ON DUPLICATE KEY UPDATE` to change a vote, and `DELETE` when the
  user clicks the same vote again.
- [ ] **Report content**: `INSERT INTO report` with a reason.
- [ ] **Moderation queue** (`/admin/reports`, `admin_required`): open reports
  (`resolved_at IS NULL`) next to the reported content. Hide or remove the
  content (`content.status`) and mark the report resolved (`resolved_at`).

**SQL you'll show:** multi-table transactions, `LAST_INSERT_ID()`, upserts,
`ON DELETE CASCADE`, ownership checks in `WHERE`.

---

## Angel: catalog, search and data (PHP)

**Build the shared layout first. Marianno builds on it.**

- [ ] **Shared PHP pieces** in `php/includes/`: the PDO connection (reads
  `config.php`, prepared statements as in Lab 8), header and nav. Styles go in
  `php/css/`.
- [ ] Add `FLASK_URL` to `php/config.example.php`. Every link to a Flask page
  uses it.
- [ ] **Home and departments** (`index.php`, `department.php?id=`): the
  departments, and the professors in each.
- [ ] **Courses** (`courses.php`, `course.php?id=`): who taught the course,
  which terms, in person or online (`teaching` ⋈ `professor` ⋈ `term`).
- [ ] **Search** (`search.php`): by professor name or course code, using a
  prepared `LIKE` query.
- [ ] **More mock data** in `sql/data.sql`: more professors and `teaching`
  rows, and about 50+ reviews with tags. Ten reviews isn't enough for rankings
  or similarity to mean anything.
- [ ] **Schema owner:** review every PR that changes `sql/tables.sql`.

**SQL you'll show:** multi-table joins, filtered search with prepared
statements, realistic sample data that satisfies every constraint.

---

## Marianno: professor pages and stats (PHP)

- [ ] **Professor page** (`professor.php?id=`): name, title and department.
  Stats: review count, average rating, average difficulty, % would retake,
  and the grade distribution (`GROUP BY grade`).
- [ ] **Reviews on that page**: only `visible` ones, with tags
  (`GROUP_CONCAT`) and vote score (`SUM(vote.value)`). Sort by newest or by
  most helpful. Each review links to Gael's Flask review page.
- [ ] **Comment threads**: nested replies using `WITH RECURSIVE` on
  `parent_comment_id`.
- [ ] **"Similar professors" box** from `v_professor_similarity`, and a
  **leaderboard** (`top.php`) from `v_professor_score`, overall and per
  department. Until Danny's views exist, use plain `AVG(rating)`.
- [ ] **"Write a review" and "Log in" links** to the Flask pages.
- [ ] **ER diagram** in `docs/` that matches `sql/tables.sql`.

**SQL you'll show:** aggregates and `GROUP BY`, `GROUP_CONCAT`, recursive
CTEs, querying views.

---

## Everyone

- [ ] Write your section of the final report and presentation: what you built,
  and the SQL queries you wrote and why.
- [ ] Test on your personal database before touching `csubryp` (see the
  README).

## Who's waiting on whom

| Who | Needs | From | Until then |
|---|---|---|---|
| Gael | `login_required`, `admin_required`, `session["user_id"]` | Danny | Hard-coded test user |
| Marianno | Shared PHP layout and connection | Angel | — |
| Marianno | `v_professor_score`, `v_professor_similarity` | Danny | Plain `AVG(rating)` |
| Danny | More reviews with tags, to test the math | Angel | Current 10 reviews |
| Everyone | Shared test password for the mock users | Danny | — |

## Linking the two sites

- **PHP pages only link to Flask pages, and the form lives on the Flask page.**
  Don't put Flask forms, like vote buttons, directly on a PHP page. Browsers
  don't send the Flask login cookie with a form submitted from another site, so
  the user would look logged out.
- After an action, Flask sends the user back to the PHP professor page.
- Keep the other site's address in config (`FLASK_URL` in `config.php`,
  `PHP_URL` in `.env`), not hard-coded. It's different on your laptop and on
  Artemis.

## Open question

**How does the Flask app get a public URL for grading?** Apache on Artemis only
serves PHP from `public_html`. Danny asks the professor before the Flask side
gets far along. If Flask can't be graded by URL, the team decides what to do
next.
