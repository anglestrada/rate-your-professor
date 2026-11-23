-- data.sql - COMPLETE CSUB Rate My Professor mock dataset (csubryp)
-- Includes the original seed and all additions: 65 reviews TOTAL.
-- 5 departments, 13 professors, 20 courses, 4 terms, 40 teaching assignments,
-- 20 users, 97 content entries, 65 reviews, 32 comments, 20 tags,
-- 184 review/tag links, 174 votes, 3 reports, and 4 submissions.
--
-- Run the project's CREATE TABLE schema first. This file fills those tables.
-- It supports empty tables, the original 10-review seed, the partial import
-- in the supplied log, and repeat imports of this same mock dataset.
-- Rows already present with the same primary key are kept; only missing IDs
-- are inserted. Existing non-email fields, including passwords, are retained.
-- The four named original seed accounts get their @example.com email values.
-- This file is intended for this mock dataset, not unrelated IDs or records.
--
-- Save this file on the server, then run from the Linux shell:
--     mariadb csubryp < data.sql
-- Keep the default batch behavior so errors stop import; do not use --force.
-- This file contains no table creation, deletion, or truncation statements.
--
-- Professor IDs 1-8 retain the supplied names; IDs 9-13 are fictional.
-- All teaching assignments, reviews, comments, users, votes, reports, and
-- submissions are mock data, not factual evaluations of any person.
-- All seeded email addresses use @example.com.
--
-- Password hashes for missing original accounts are the supplied placeholders.
-- Existing account hashes are never changed. If this is a fresh database,
-- merge Danny's current hashes into the four original user rows below before
-- using the accounts to log in. New users copy user 1's current seeded hash.
--
-- Review/content IDs: 1-10 and 19-73. Comment/content IDs: 11-18 and 74-97.
-- Each professor has five tagged reviews. Of the 65 reviews, 64 are visible;
-- the original spam review remains hidden for moderation testing.
-- Ratings and difficulty use 1-5. Optional unknown values use NULL.
-- Original reports, submissions, and removed comment remain included.
-- Expected counts assume this dataset without additional application records.

SET NAMES utf8mb4;
START TRANSACTION;

-- All five original departments.

INSERT INTO `department` (`dept_id`, `code`, `name`)
SELECT mock_row.`dept_id`, mock_row.`code`, mock_row.`name`
FROM (
    SELECT 1 AS `dept_id`, 'CMPS' AS `code`, 'Computer Science' AS `name`
    UNION ALL SELECT 2, 'MATH', 'Mathematics'
    UNION ALL SELECT 3, 'ENGL', 'English'
    UNION ALL SELECT 4, 'PSYC', 'Psychology'
    UNION ALL SELECT 5, 'PHYS', 'Physics'
) AS mock_row
WHERE NOT EXISTS (
    SELECT 1 FROM `department` AS existing_row
    WHERE existing_row.`dept_id` = mock_row.`dept_id`
);

-- Original professor IDs 1-8 plus fictional additions 9-13.

INSERT INTO `professor` (`prof_id`, `dept_id`, `first_name`, `last_name`, `title`)
SELECT mock_row.`prof_id`, mock_row.`dept_id`, mock_row.`first_name`, mock_row.`last_name`, mock_row.`title`
FROM (
    SELECT 1 AS `prof_id`, 1 AS `dept_id`, 'Melissa' AS `first_name`, 'Danforth' AS `last_name`, 'Professor' AS `title`
    UNION ALL SELECT 2, 1, 'Nick', 'Toothman', 'Assistant Professor'
    UNION ALL SELECT 3, 1, 'Jay', 'Manibo', 'Lecturer'
    UNION ALL SELECT 4, 2, 'Charles', 'Lam', 'Professor'
    UNION ALL SELECT 5, 2, 'Eduardo', 'Montoya', 'Professor'
    UNION ALL SELECT 6, 3, 'Emerson', 'Case', 'Professor'
    UNION ALL SELECT 7, 4, 'Tyler', 'Ensor', 'Associate Professor'
    UNION ALL SELECT 8, 5, 'Yize', 'Li', 'Professor'
    UNION ALL SELECT 9, 1, 'Elena', 'Marquez', 'Lecturer'
    UNION ALL SELECT 10, 2, 'Adrian', 'Brooks', 'Assistant Professor'
    UNION ALL SELECT 11, 3, 'Priya', 'Bennett', 'Lecturer'
    UNION ALL SELECT 12, 4, 'Nolan', 'Reyes', 'Associate Professor'
    UNION ALL SELECT 13, 5, 'Maya', 'Chen', 'Assistant Professor'
) AS mock_row
WHERE NOT EXISTS (
    SELECT 1 FROM `professor` AS existing_row
    WHERE existing_row.`prof_id` = mock_row.`prof_id`
);

-- All 20 original course rows.

INSERT INTO `course` (`course_id`, `dept_id`, `subject`, `course_number`, `title`)
SELECT mock_row.`course_id`, mock_row.`dept_id`, mock_row.`subject`, mock_row.`course_number`, mock_row.`title`
FROM (
    SELECT 1 AS `course_id`, 1 AS `dept_id`, 'CMPS' AS `subject`, '2010' AS `course_number`, 'Programming I: Programming Fundamentals' AS `title`
    UNION ALL SELECT 2, 1, 'CMPS', '2020', 'Programming II: Data Structures and Algorithms'
    UNION ALL SELECT 3, 1, 'CMPS', '3420', 'Database Systems'
    UNION ALL SELECT 4, 1, 'CMPS', '3600', 'Operating Systems'
    UNION ALL SELECT 5, 2, 'MATH', '2200', 'Introduction to Statistical Concepts and Methods'
    UNION ALL SELECT 6, 2, 'MATH', '2510', 'Single Variable Calculus I'
    UNION ALL SELECT 7, 3, 'ENGL', '1109', 'Writing and Research'
    UNION ALL SELECT 8, 4, 'PSYC', '1018', 'Explorations in Psychology'
    UNION ALL SELECT 9, 5, 'PHYS', '2210', 'Physics for Scientists and Engineers I'
    UNION ALL SELECT 10, 1, 'CMPS', '3120', 'Algorithm Analysis'
    UNION ALL SELECT 11, 1, 'CMPS', '2120', 'Discrete Structures'
    UNION ALL SELECT 12, 1, 'CMPS', '3140', 'Theory of Computation'
        UNION ALL SELECT 13, 1, 'CMPS', '3350', 'Software Engineering'
    UNION ALL SELECT 14, 1, 'CMPS', '3500', 'Programming Languages'
    UNION ALL SELECT 15, 1, 'CMPS', '4620', 'Network and Computer Security'
    UNION ALL SELECT 16, 2, 'MATH', '2520', 'Single Variable Calculus II'
    UNION ALL SELECT 17, 2, 'MATH', '2610', 'Linear Algebra I'
    UNION ALL SELECT 18, 3, 'ENGL', '1100', 'Critical Reading and Writing'
    UNION ALL SELECT 19, 4, 'PSYC', '2018', 'Introduction to Statistical Methods in Psychological Research'
    UNION ALL SELECT 20, 5, 'PHYS', '2220', 'Physics for Scientists and Engineers II'
) AS mock_row
WHERE NOT EXISTS (
    SELECT 1 FROM `course` AS existing_row
    WHERE existing_row.`course_id` = mock_row.`course_id`
);

-- All four original term rows.

INSERT INTO `term` (`term_id`, `season`, `term_year`)
SELECT mock_row.`term_id`, mock_row.`season`, mock_row.`term_year`
FROM (
    SELECT 1 AS `term_id`, 'Fall' AS `season`, 2025 AS `term_year`
    UNION ALL SELECT 2, 'Spring', 2026
    UNION ALL SELECT 3, 'Summer', 2026
    UNION ALL SELECT 4, 'Fall', 2026
) AS mock_row
WHERE NOT EXISTS (
    SELECT 1 FROM `term` AS existing_row
    WHERE existing_row.`term_id` = mock_row.`term_id`
);

-- Original teaching IDs 1-18 plus new IDs 19-40.

INSERT INTO `teaching` (`teaching_id`, `prof_id`, `course_id`, `term_id`, `modality`)
SELECT mock_row.`teaching_id`, mock_row.`prof_id`, mock_row.`course_id`, mock_row.`term_id`, mock_row.`modality`
FROM (
    SELECT 1 AS `teaching_id`, 1 AS `prof_id`, 3 AS `course_id`, 1 AS `term_id`, 'In-Person' AS `modality`
    UNION ALL SELECT 2, 1, 3, 4, 'In-Person'
    UNION ALL SELECT 3, 2, 4, 2, 'Hybrid'
    UNION ALL SELECT 4, 3, 1, 1, 'In-Person'
    UNION ALL SELECT 5, 3, 2, 2, 'In-Person'
    UNION ALL SELECT 6, 4, 6, 1, 'In-Person'
    UNION ALL SELECT 7, 5, 5, 2, 'Online'
    UNION ALL SELECT 8, 6, 7, 1, 'In-Person'
    UNION ALL SELECT 9, 7, 8, 3, 'Online'
    UNION ALL SELECT 10, 8, 9, 2, 'In-Person'
    UNION ALL SELECT 11, 2, 10, 4, 'In-Person'
    UNION ALL SELECT 12, 3, 1, 4, 'Hybrid'
    UNION ALL SELECT 13, 1, 11, 2, 'In-Person'
    UNION ALL SELECT 14, 2, 12, 4, 'In-Person'
    UNION ALL SELECT 15, 3, 14, 4, 'In-Person'
    UNION ALL SELECT 16, 4, 16, 2, 'In-Person'
    UNION ALL SELECT 17, 7, 19, 4, 'Hybrid'
    UNION ALL SELECT 18, 8, 20, 4, 'In-Person'
    UNION ALL SELECT 19, 1, 13, 4, 'Hybrid'
    UNION ALL SELECT 20, 5, 17, 1, 'In-Person'
    UNION ALL SELECT 21, 5, 5, 4, 'Online'
    UNION ALL SELECT 22, 6, 18, 2, 'Hybrid'
    UNION ALL SELECT 23, 6, 7, 4, 'Online'
    UNION ALL SELECT 24, 9, 1, 1, 'In-Person'
    UNION ALL SELECT 25, 9, 2, 2, 'Hybrid'
    UNION ALL SELECT 26, 9, 13, 4, 'In-Person'
    UNION ALL SELECT 27, 10, 6, 1, 'In-Person'
    UNION ALL SELECT 28, 10, 16, 2, 'In-Person'
    UNION ALL SELECT 29, 10, 17, 4, 'Hybrid'
    UNION ALL SELECT 30, 11, 18, 1, 'Online'
    UNION ALL SELECT 31, 11, 7, 2, 'In-Person'
    UNION ALL SELECT 32, 11, 7, 4, 'Hybrid'
    UNION ALL SELECT 33, 12, 8, 2, 'In-Person'
    UNION ALL SELECT 34, 12, 19, 4, 'Online'
    UNION ALL SELECT 35, 13, 9, 1, 'In-Person'
    UNION ALL SELECT 36, 13, 20, 2, 'Hybrid'
    UNION ALL SELECT 37, 9, 15, 4, 'Hybrid'
    UNION ALL SELECT 38, 10, 5, 3, 'Online'
    UNION ALL SELECT 39, 11, 18, 3, 'Online'
    UNION ALL SELECT 40, 12, 8, 3, 'Online'
) AS mock_row
WHERE NOT EXISTS (
    SELECT 1 FROM `teaching` AS existing_row
    WHERE existing_row.`teaching_id` = mock_row.`teaching_id`
);

-- Original accounts: insert only missing IDs, preserving existing hashes.

INSERT INTO `users` (`user_id`, `email`, `username`, `password_hash`, `class_year`, `user_type`, `user_status`, `created_at`, `last_login`)
SELECT mock_row.`user_id`, mock_row.`email`, mock_row.`username`, mock_row.`password_hash`, mock_row.`class_year`, mock_row.`user_type`, mock_row.`user_status`, mock_row.`created_at`, mock_row.`last_login`
FROM (
    SELECT 1 AS `user_id`, 'aestrada@example.com' AS `email`, 'aestrada' AS `username`, '$2y$10$placeholderhashplaceholderhashplaceholderhash01' AS `password_hash`, NULL AS `class_year`, 'user' AS `user_type`, 'active' AS `user_status`, '2025-08-20 14:12:00' AS `created_at`, '2026-10-24 21:05:00' AS `last_login`
    UNION ALL SELECT 2, 'dvillanueva@example.com', 'dvillanueva', '$2y$10$placeholderhashplaceholderhashplaceholderhash02', 'Senior', 'admin', 'active', '2025-08-15 09:00:00', '2026-10-26 07:50:00'
    UNION ALL SELECT 3, 'mnuno@example.com', 'mnuno', '$2y$10$placeholderhashplaceholderhashplaceholderhash03', NULL, 'user', 'active', '2025-08-22 10:40:00', '2026-10-23 08:15:00'
    UNION ALL SELECT 4, 'gcarrillo@example.com', 'gcarrillo', '$2y$10$placeholderhashplaceholderhashplaceholderhash04', NULL, 'user', 'active', '2025-09-01 16:00:00', '2026-10-20 12:00:00'
) AS mock_row
WHERE NOT EXISTS (
    SELECT 1 FROM `users` AS existing_row
    WHERE existing_row.`user_id` = mock_row.`user_id`
);

-- Apply the public mock email values to the four named seed accounts.

UPDATE `users` SET `email` = 'aestrada@example.com' WHERE `user_id` = 1 AND `username` = 'aestrada';

UPDATE `users` SET `email` = 'dvillanueva@example.com' WHERE `user_id` = 2 AND `username` = 'dvillanueva';

UPDATE `users` SET `email` = 'mnuno@example.com' WHERE `user_id` = 3 AND `username` = 'mnuno';

UPDATE `users` SET `email` = 'gcarrillo@example.com' WHERE `user_id` = 4 AND `username` = 'gcarrillo';

-- Add users 5-20 only when absent, retaining all existing password hashes.
INSERT INTO `users` (`user_id`, `email`, `username`, `password_hash`, `class_year`,
                     `user_type`, `user_status`, `created_at`, `last_login`)
SELECT mock_user.user_id, mock_user.email, mock_user.username, seed_user.password_hash,
       NULL, 'user', 'active', '2025-08-25 09:00:00', '2026-11-16 23:00:00'
FROM (

    SELECT 5 AS `user_id`, 'student05@example.com' AS `email`, 'mock05' AS `username`
    UNION ALL SELECT 6, 'student06@example.com', 'mock06'
    UNION ALL SELECT 7, 'student07@example.com', 'mock07'
    UNION ALL SELECT 8, 'student08@example.com', 'mock08'
    UNION ALL SELECT 9, 'student09@example.com', 'mock09'
    UNION ALL SELECT 10, 'student10@example.com', 'mock10'
    UNION ALL SELECT 11, 'student11@example.com', 'mock11'
    UNION ALL SELECT 12, 'student12@example.com', 'mock12'
    UNION ALL SELECT 13, 'student13@example.com', 'mock13'
    UNION ALL SELECT 14, 'student14@example.com', 'mock14'
    UNION ALL SELECT 15, 'student15@example.com', 'mock15'
    UNION ALL SELECT 16, 'student16@example.com', 'mock16'
    UNION ALL SELECT 17, 'student17@example.com', 'mock17'
    UNION ALL SELECT 18, 'student18@example.com', 'mock18'
    UNION ALL SELECT 19, 'student19@example.com', 'mock19'
    UNION ALL SELECT 20, 'student20@example.com', 'mock20'

) AS mock_user
CROSS JOIN `users` AS seed_user
WHERE seed_user.user_id = 1
  AND NOT EXISTS (
      SELECT 1 FROM `users` AS existing_user
      WHERE existing_user.user_id = mock_user.user_id
  );

-- Original content IDs 1-18 plus new reviews/comments 19-97.

INSERT INTO `content` (`content_id`, `user_id`, `content_type`, `body`, `created_at`, `status`)
SELECT mock_row.`content_id`, mock_row.`user_id`, mock_row.`content_type`, mock_row.`body`, mock_row.`created_at`, mock_row.`status`
FROM (
    SELECT 1 AS `content_id`, 1 AS `user_id`, 'review' AS `content_type`, 'Lectures are organized and the ER modeling project really helped. Exams are hard but fair.' AS `body`, '2025-12-15 20:10:00' AS `created_at`, 'visible' AS `status`
    UNION ALL SELECT 2, 2, 'review', 'Great class if you keep up with the labs. Office hours were very helpful.', '2025-12-18 11:30:00', 'visible'
    UNION ALL SELECT 3, 3, 'review', 'Interesting material. Exams are challenging, so review the readings too.', '2026-05-20 09:05:00', 'visible'
    UNION ALL SELECT 4, 4, 'review', 'Perfect first programming class. Explains everything slowly and clearly.', '2025-12-12 16:45:00', 'visible'
    UNION ALL SELECT 5, 1, 'review', 'Lots of weekly homework, but it prepares you well for the projects.', '2026-05-22 18:20:00', 'visible'
    UNION ALL SELECT 6, 2, 'review', 'Very fast paced and quizzes every week. Go to tutoring early.', '2025-12-10 13:00:00', 'visible'
    UNION ALL SELECT 7, 3, 'review', 'Online format works well. Responds to email quickly.', '2026-05-25 21:40:00', 'visible'
    UNION ALL SELECT 8, 4, 'review', 'Easy to follow and genuinely cares whether students understand.', '2026-08-10 10:15:00', 'visible'
    UNION ALL SELECT 9, 1, 'review', 'Lab reports take a long time but lectures are clear.', '2026-05-28 15:00:00', 'visible'
    UNION ALL SELECT 10, 3, 'review', 'Selling my used textbook for this class, message me if interested.', '2025-12-20 23:55:00', 'hidden'
    UNION ALL SELECT 11, 3, 'comment', 'Agreed, the project made normalization click for me.', '2025-12-16 08:30:00', 'visible'
    UNION ALL SELECT 12, 1, 'comment', 'Same. Start the project early though.', '2025-12-16 12:00:00', 'visible'
    UNION ALL SELECT 13, 4, 'comment', 'Did the final cover scheduling algorithms?', '2026-05-21 10:10:00', 'visible'
    UNION ALL SELECT 14, 3, 'comment', 'Yes, mostly round robin and priority scheduling.', '2026-05-21 14:35:00', 'visible'
    UNION ALL SELECT 15, 1, 'comment', 'Tutoring center on the second floor helped me a lot.', '2025-12-11 09:00:00', 'visible'
    UNION ALL SELECT 16, 4, 'comment', 'Anyone selling a used parking pass?', '2025-12-11 19:20:00', 'removed'
    UNION ALL SELECT 17, 2, 'comment', 'This review does not say anything about the actual class.', '2025-12-21 10:00:00', 'visible'
    UNION ALL SELECT 18, 2, 'comment', 'Taking this online next summer, thanks for the review.', '2026-08-12 17:45:00', 'visible'
    UNION ALL SELECT 19, 5, 'review', 'The database project connects ER diagrams, normalization, and SQL. Milestone feedback has helped our group catch mistakes early.', '2026-11-06 16:19:00', 'visible'
    UNION ALL SELECT 20, 6, 'review', 'Discrete math takes steady practice. The proof examples and office hours helped, but memorizing definitions alone was not enough for the exams.', '2026-05-22 16:20:00', 'visible'
    UNION ALL SELECT 21, 7, 'review', 'Our software engineering project has clear checkpoints. Peer evaluations make it important to keep track of who completes each task.', '2026-11-08 16:21:00', 'visible'
    UNION ALL SELECT 22, 8, 'review', 'Algorithm analysis moves quickly and the proofs take time. Working through examples before lecture has been more useful than just reading my notes.', '2026-11-09 16:22:00', 'visible'
    UNION ALL SELECT 23, 9, 'review', 'Automata diagrams are explained clearly. The homework is difficult, but the practice questions show the level of reasoning expected on tests.', '2026-11-10 16:23:00', 'visible'
    UNION ALL SELECT 24, 10, 'review', 'The scheduling and memory exercises made operating systems much easier to understand. Office hours were especially helpful before the final.', '2026-05-18 16:24:00', 'visible'
    UNION ALL SELECT 25, 11, 'review', 'I need more intermediate steps during the algorithm proofs. The pace is difficult to follow if I have not already attempted the assigned problems.', '2026-11-04 16:25:00', 'visible'
    UNION ALL SELECT 26, 12, 'review', 'The hybrid programming labs are easy to follow. Small examples come before the larger assignments, which helped me build confidence with loops.', '2026-11-05 16:26:00', 'visible'
    UNION ALL SELECT 27, 13, 'review', 'Comparing the same task in different programming languages is useful. Start the assignments early because switching syntax can take longer than expected.', '2026-11-06 16:27:00', 'visible'
    UNION ALL SELECT 28, 14, 'review', 'The introductory labs were useful, and the written feedback showed where my logic went wrong. Weekly assignments still took more time than I expected.', '2025-12-14 16:28:00', 'visible'
    UNION ALL SELECT 29, 15, 'review', 'Integration techniques require a lot of practice. The review sheets helped me decide which method to use instead of guessing during the exam.', '2026-05-23 16:29:00', 'visible'
    UNION ALL SELECT 30, 16, 'review', 'Worked calculus examples include the algebra steps that are easy to forget. The exams felt fair when I completed the practice problems.', '2025-12-16 16:30:00', 'visible'
    UNION ALL SELECT 31, 17, 'review', 'Calculus II moved faster than I could comfortably manage. There was plenty of homework, but I needed additional tutoring to connect the different methods.', '2026-05-25 16:31:00', 'visible'
    UNION ALL SELECT 32, 18, 'review', 'Daily practice matters in this class. Lectures cover the material, but I learned the most by redoing problems without looking at the solutions.', '2025-12-10 16:32:00', 'visible'
    UNION ALL SELECT 33, 19, 'review', 'The matrix examples show every row operation. Office hours helped me understand why the procedures work instead of only memorizing the steps.', '2025-12-11 16:33:00', 'visible'
    UNION ALL SELECT 34, 20, 'review', 'Recorded statistics lessons are organized by topic. Questions get a quick response, and the weekly schedule leaves some flexibility for completing practice.', '2026-11-05 16:34:00', 'visible'
    UNION ALL SELECT 35, 5, 'review', 'Weekly statistics quizzes kept me studying. The examples were useful, although I wanted more explanation of why some of my answers were incorrect.', '2026-05-21 16:35:00', 'visible'
    UNION ALL SELECT 36, 6, 'review', 'Some online assignment instructions have been hard to interpret. I would find it easier to improve if feedback arrived before the next homework deadline.', '2026-11-07 16:36:00', 'visible'
    UNION ALL SELECT 37, 7, 'review', 'Revising essays after feedback improved my argument structure. Class discussions helped me notice when a paragraph needed more evidence.', '2026-05-23 16:37:00', 'visible'
    UNION ALL SELECT 38, 8, 'review', 'The writing rubrics explain how evidence and organization are graded. Draft feedback and flexible revision deadlines make the online format manageable.', '2026-11-09 16:38:00', 'visible'
    UNION ALL SELECT 39, 9, 'review', 'The readings supported interesting discussions, but several essays were due close together. Planning the research early made the workload more manageable.', '2025-12-17 16:39:00', 'visible'
    UNION ALL SELECT 40, 10, 'review', 'Some essay feedback arrived after the next draft was underway. I had trouble applying the expectations consistently and wanted more sample paragraphs.', '2026-05-18 16:40:00', 'visible'
    UNION ALL SELECT 41, 11, 'review', 'The statistics project connects calculations to research questions. Feedback on interpreting results has been more valuable than memorizing formulas.', '2026-11-04 16:41:00', 'visible'
    UNION ALL SELECT 42, 12, 'review', 'Short psychology videos and weekly examples made the summer schedule manageable. The practice questions matched the main ideas covered in each module.', '2026-08-06 16:42:00', 'visible'
    UNION ALL SELECT 43, 13, 'review', 'The research examples are useful, but the statistics homework takes time. I have needed regular practice to keep the different tests straight.', '2026-11-06 16:43:00', 'visible'
    UNION ALL SELECT 44, 14, 'review', 'The statistics course moves quickly once the project starts. Balancing the exams and group deadlines has been difficult alongside my other classes.', '2026-11-07 16:44:00', 'visible'
    UNION ALL SELECT 45, 15, 'review', 'Circuit problems build on the earlier homework, and the labs help connect equations to measurements. Expect the exams to combine several concepts.', '2026-11-08 16:45:00', 'visible'
    UNION ALL SELECT 46, 16, 'review', 'The physics problem setup is explained carefully. Drawing diagrams before choosing equations made a noticeable difference on my exams.', '2026-05-24 16:46:00', 'visible'
    UNION ALL SELECT 47, 17, 'review', 'Lab reports and exam preparation often land in the same week. The material is interesting, but I have struggled to keep up with the workload.', '2026-11-10 16:47:00', 'visible'
    UNION ALL SELECT 48, 18, 'review', 'Lectures provide a solid foundation, but the physics problems need repeated practice. The lab sessions were useful for checking my understanding.', '2026-05-18 16:48:00', 'visible'
    UNION ALL SELECT 49, 19, 'review', 'Live coding examples made the first programming course approachable. Questions were welcome, and lab feedback explained how to improve my solutions.', '2025-12-11 16:49:00', 'visible'
    UNION ALL SELECT 50, 20, 'review', 'Data structures assignments take time, especially the tree exercises. Office hours helped me debug without simply giving away the answer.', '2026-05-20 16:50:00', 'visible'
        UNION ALL SELECT 51, 5, 'review', 'The application project has useful milestones and a clear rubric. Regular group check-ins have kept the work from piling up at the end.', '2026-11-06 16:51:00', 'visible'
    UNION ALL SELECT 52, 6, 'review', 'The security labs are interesting and require careful documentation. I would like more time discussing the lab results during lecture.', '2026-11-07 16:52:00', 'visible'
    UNION ALL SELECT 53, 7, 'review', 'Starting with small programming exercises helped me learn the basics. The optional practice problems were useful before the larger assignments.', '2025-12-15 16:53:00', 'visible'
    UNION ALL SELECT 54, 8, 'review', 'I found the calculus explanations difficult to follow, and the tests moved beyond the examples I had practiced. I needed more guidance between exams.', '2025-12-16 16:54:00', 'visible'
    UNION ALL SELECT 55, 9, 'review', 'The amount of calculus homework was hard to balance with the tests. Extra practice helped somewhat, but the pace still felt too fast for me.', '2026-05-25 16:55:00', 'visible'
    UNION ALL SELECT 56, 10, 'review', 'Linear algebra lectures cover useful examples. Grading has been consistent, though I need to work through extra problems to feel ready for quizzes.', '2026-11-03 16:56:00', 'visible'
    UNION ALL SELECT 57, 11, 'review', 'The recorded summer statistics lessons were clear and the quizzes followed the examples. Flexible practice deadlines helped with the compressed schedule.', '2026-08-09 16:57:00', 'visible'
    UNION ALL SELECT 58, 12, 'review', 'I have needed more clarification on what to show in written solutions. Getting quiz feedback sooner would help me prepare for the next assessment.', '2026-11-05 16:58:00', 'visible'
    UNION ALL SELECT 59, 13, 'review', 'The online writing modules explain each stage of an argument. Specific comments on my drafts helped me make stronger connections between evidence and claims.', '2025-12-13 16:59:00', 'visible'
    UNION ALL SELECT 60, 14, 'review', 'The research paper is a lot of work, but the proposal and source checks make it easier to manage. Class discussion helped me narrow my topic.', '2026-05-22 17:00:00', 'visible'
    UNION ALL SELECT 61, 15, 'review', 'Short writing conferences have been especially helpful. The feedback explains why a revision would improve the argument instead of only marking errors.', '2026-11-08 17:01:00', 'visible'
    UNION ALL SELECT 62, 16, 'review', 'The summer writing schedule is busy, but the instructions are clear. Being able to revise a draft helped me improve without falling behind.', '2026-08-08 17:02:00', 'visible'
    UNION ALL SELECT 63, 17, 'review', 'Discussion and peer review are a large part of the writing class. The detailed feedback helped, although I preferred the individual assignments.', '2026-05-25 17:03:00', 'visible'
    UNION ALL SELECT 64, 18, 'review', 'Examples about memory and learning made the psychology concepts easier to remember. Participating in class helped me prepare for the application questions.', '2026-05-18 17:04:00', 'visible'
    UNION ALL SELECT 65, 19, 'review', 'The research statistics project includes feedback at each stage. Explaining the output in plain language has helped me understand what the tests mean.', '2026-11-04 17:05:00', 'visible'
    UNION ALL SELECT 66, 20, 'review', 'The summer psychology quizzes were manageable when I kept up with the readings. The recorded lectures mostly followed the textbook examples.', '2026-08-06 17:06:00', 'visible'
    UNION ALL SELECT 67, 5, 'review', 'The online discussion requirements have been difficult to interpret. I would like more examples of a complete statistics project before submitting each section.', '2026-11-06 17:07:00', 'visible'
    UNION ALL SELECT 68, 6, 'review', 'Applying psychology ideas to everyday situations made lectures engaging. Questions were taken seriously, and the study guides identified the main concepts.', '2026-05-22 17:08:00', 'visible'
    UNION ALL SELECT 69, 7, 'review', 'Free-body diagrams were explained step by step, and the labs reinforced the lecture material. The class was challenging but the expectations were clear.', '2025-12-15 17:09:00', 'visible'
    UNION ALL SELECT 70, 8, 'review', 'Fields and circuits took a lot of practice. Office hours helped me connect the equations to the physical situations described in the problems.', '2026-05-24 17:10:00', 'visible'
    UNION ALL SELECT 71, 9, 'review', 'The physics labs were useful, but the reports took longer than expected. I needed additional practice outside lecture to prepare for the exams.', '2025-12-17 17:11:00', 'visible'
    UNION ALL SELECT 72, 10, 'review', 'I withdrew when I could not keep up with the weekly problem sets. The course required more preparation time than I could manage that semester.', '2026-05-18 17:12:00', 'visible'
    UNION ALL SELECT 73, 11, 'review', 'I had trouble connecting the physics examples to the exam questions. More feedback on my setup and intermediate steps would have helped me study.', '2026-05-19 17:13:00', 'visible'
    UNION ALL SELECT 74, 8, 'comment', 'Did the database project include an ER diagram?', '2026-11-07 17:19:00', 'visible'
    UNION ALL SELECT 75, 5, 'comment', 'Yes, we submitted the ER diagram before building the tables.', '2026-11-08 17:19:00', 'visible'
    UNION ALL SELECT 76, 13, 'comment', 'Were the scheduling exercises done in groups?', '2026-05-19 17:24:00', 'visible'
    UNION ALL SELECT 77, 10, 'comment', 'We discussed them together, but each person turned in a solution.', '2026-05-20 17:24:00', 'visible'
    UNION ALL SELECT 78, 16, 'comment', 'Do you need to know all the languages before starting?', '2026-11-07 17:27:00', 'visible'
    UNION ALL SELECT 79, 13, 'comment', 'No. The assignments introduce the syntax before asking you to compare it.', '2026-11-08 17:27:00', 'visible'
    UNION ALL SELECT 80, 18, 'comment', 'Did the review sheets include integration by parts?', '2026-05-24 17:29:00', 'visible'
    UNION ALL SELECT 81, 15, 'comment', 'Yes, and there were several examples of choosing the two parts.', '2026-05-25 17:29:00', 'visible'
    UNION ALL SELECT 82, 6, 'comment', 'Were the matrix examples worked out during lecture?', '2025-12-12 17:33:00', 'visible'
    UNION ALL SELECT 83, 19, 'comment', 'Yes, the full row reduction steps were shown.', '2025-12-13 17:33:00', 'visible'
    UNION ALL SELECT 84, 10, 'comment', 'Could you revise the first essay after feedback?', '2026-05-24 17:37:00', 'visible'
    UNION ALL SELECT 85, 7, 'comment', 'Yes, we had a separate revision deadline after getting comments.', '2026-05-25 17:37:00', 'visible'
    UNION ALL SELECT 86, 14, 'comment', 'Which part of the statistics project took the most time?', '2026-11-05 17:41:00', 'visible'
    UNION ALL SELECT 87, 11, 'comment', 'Cleaning the data and explaining the output took longer than running the calculations.', '2026-11-06 17:41:00', 'visible'
    UNION ALL SELECT 88, 18, 'comment', 'Were the circuit problems similar to the homework?', '2026-11-09 17:45:00', 'visible'
    UNION ALL SELECT 89, 15, 'comment', 'The concepts matched, but the exam combined more than one step.', '2026-11-10 17:45:00', 'visible'
    UNION ALL SELECT 90, 8, 'comment', 'Did groups get to pick their own application idea?', '2026-11-07 17:51:00', 'visible'
    UNION ALL SELECT 91, 5, 'comment', 'Yes, as long as the idea met the requirements in the project proposal.', '2026-11-08 17:51:00', 'visible'
    UNION ALL SELECT 92, 14, 'comment', 'Were the summer lectures recorded?', '2026-08-10 17:57:00', 'visible'
    UNION ALL SELECT 93, 11, 'comment', 'Yes, I watched the recordings before completing the weekly quizzes.', '2026-08-11 17:57:00', 'visible'
    UNION ALL SELECT 94, 18, 'comment', 'Were writing conferences held during class time?', '2026-11-09 18:01:00', 'visible'
    UNION ALL SELECT 95, 15, 'comment', 'We scheduled short meetings during the conference week.', '2026-11-10 18:01:00', 'visible'
    UNION ALL SELECT 96, 10, 'comment', 'Did drawing diagrams help with exam questions?', '2025-12-16 18:09:00', 'visible'
    UNION ALL SELECT 97, 7, 'comment', 'Yes, labeling the forces first made the equations much easier to set up.', '2025-12-17 18:09:00', 'visible'
) AS mock_row
WHERE NOT EXISTS (
    SELECT 1 FROM `content` AS existing_row
    WHERE existing_row.`content_id` = mock_row.`content_id`
);

-- Original reviews 1-10 plus 55 added reviews 19-73.

INSERT INTO `review` (`review_id`, `teaching_id`, `rating`, `difficulty`, `grade`, `attendance`, `textbook`, `would_retake`)
SELECT mock_row.`review_id`, mock_row.`teaching_id`, mock_row.`rating`, mock_row.`difficulty`, mock_row.`grade`, mock_row.`attendance`, mock_row.`textbook`, mock_row.`would_retake`
FROM (
    SELECT 1 AS `review_id`, 1 AS `teaching_id`, 5 AS `rating`, 4 AS `difficulty`, 'A-' AS `grade`, 1 AS `attendance`, 0 AS `textbook`, 1 AS `would_retake`
    UNION ALL SELECT 2, 1, 4, 4, 'B+', 1, 0, 1
    UNION ALL SELECT 3, 3, 4, 5, 'B', 0, 1, 1
    UNION ALL SELECT 4, 4, 5, 2, 'A', 1, 0, 1
    UNION ALL SELECT 5, 5, 4, 3, 'A-', 1, 0, 1
    UNION ALL SELECT 6, 6, 4, 5, 'C+', 1, 1, 1
    UNION ALL SELECT 7, 7, 4, 3, 'B+', 0, 0, 1
    UNION ALL SELECT 8, 9, 5, 1, 'A', 0, 1, 1
    UNION ALL SELECT 9, 10, 3, 4, 'B-', 1, 1, 1
    UNION ALL SELECT 10, 8, 3, 3, NULL, NULL, 1, 1
    UNION ALL SELECT 19, 2, 5, 4, 'IP', 1, 0, 1
    UNION ALL SELECT 20, 13, 4, 4, 'B', 1, 1, 1
    UNION ALL SELECT 21, 19, 4, 3, 'IP', 1, 0, 1
    UNION ALL SELECT 22, 11, 3, 5, 'IP', 1, 1, 0
    UNION ALL SELECT 23, 14, 4, 5, 'IP', 1, 1, 1
    UNION ALL SELECT 24, 3, 5, 4, 'A-', 0, 1, 1
    UNION ALL SELECT 25, 11, 2, 5, 'IP', 1, 1, 0
    UNION ALL SELECT 26, 12, 5, 2, 'IP', 1, 0, 1
    UNION ALL SELECT 27, 15, 4, 4, 'IP', 1, 0, 1
    UNION ALL SELECT 28, 4, 3, 3, 'B', 1, 0, 1
    UNION ALL SELECT 29, 16, 4, 5, 'B', 1, 1, 1
    UNION ALL SELECT 30, 6, 5, 4, 'A-', 1, 1, 1
    UNION ALL SELECT 31, 16, 2, 5, 'C', 1, 1, 0
    UNION ALL SELECT 32, 6, 3, 4, 'B-', 1, 1, 0
    UNION ALL SELECT 33, 20, 5, 3, 'A', 1, 1, 1
    UNION ALL SELECT 34, 21, 4, 3, 'IP', 0, 0, 1
    UNION ALL SELECT 35, 7, 3, 3, 'B', 0, 0, 1
    UNION ALL SELECT 36, 21, 2, 4, 'IP', NULL, NULL, 0
    UNION ALL SELECT 37, 22, 4, 3, 'A-', 1, 0, 1
    UNION ALL SELECT 38, 23, 5, 2, 'IP', 0, 0, 1
    UNION ALL SELECT 39, 8, 3, 3, 'B', 1, 1, 1
    UNION ALL SELECT 40, 22, 2, 4, 'C+', 1, 0, 0
    UNION ALL SELECT 41, 17, 4, 4, 'IP', 1, 1, 1
    UNION ALL SELECT 42, 9, 5, 2, 'A', 0, 1, 1
    UNION ALL SELECT 43, 17, 3, 4, 'IP', 1, 1, 1
    UNION ALL SELECT 44, 17, 2, 5, 'IP', 1, 1, 0
    UNION ALL SELECT 45, 18, 4, 5, 'IP', 1, 1, 1
        UNION ALL SELECT 46, 10, 5, 4, 'A-', 1, 1, 1
    UNION ALL SELECT 47, 18, 2, 5, 'IP', 1, 1, 0
    UNION ALL SELECT 48, 10, 3, 4, 'B', 1, 1, 1
    UNION ALL SELECT 49, 24, 5, 2, 'A', 1, 0, 1
    UNION ALL SELECT 50, 25, 4, 4, 'B+', 1, 0, 1
    UNION ALL SELECT 51, 26, 5, 3, 'IP', 1, 0, 1
    UNION ALL SELECT 52, 37, 3, 4, 'IP', 1, 1, 1
    UNION ALL SELECT 53, 24, 4, 2, 'A-', 1, 0, 1
    UNION ALL SELECT 54, 27, 1, 5, 'D', 1, 1, 0
    UNION ALL SELECT 55, 28, 2, 5, 'C-', 1, 1, 0
    UNION ALL SELECT 56, 29, 3, 4, 'IP', 1, 1, 1
    UNION ALL SELECT 57, 38, 4, 3, 'B+', 0, 0, 1
    UNION ALL SELECT 58, 29, 2, 4, 'IP', 1, 1, 0
    UNION ALL SELECT 59, 30, 5, 2, 'A', 0, 0, 1
    UNION ALL SELECT 60, 31, 4, 3, 'B+', 1, 1, 1
    UNION ALL SELECT 61, 32, 5, 2, 'IP', 1, 0, 1
    UNION ALL SELECT 62, 39, 4, 3, 'A-', 0, 0, 1
    UNION ALL SELECT 63, 31, 3, 3, 'B', 1, 1, 1
    UNION ALL SELECT 64, 33, 4, 3, 'B+', 1, 1, 1
    UNION ALL SELECT 65, 34, 5, 4, 'IP', 0, 0, 1
    UNION ALL SELECT 66, 40, 3, 2, 'A-', 0, 1, 1
    UNION ALL SELECT 67, 34, 2, 4, 'IP', 0, 0, 0
    UNION ALL SELECT 68, 33, 4, 3, 'B+', 1, 1, 1
    UNION ALL SELECT 69, 35, 5, 4, 'A-', 1, 1, 1
    UNION ALL SELECT 70, 36, 4, 5, 'B', 1, 1, 1
    UNION ALL SELECT 71, 35, 3, 4, 'B-', 1, 1, 1
    UNION ALL SELECT 72, 36, 2, 5, 'W', 1, 1, 0
    UNION ALL SELECT 73, 36, 1, 5, 'F', 1, 1, 0
) AS mock_row
WHERE NOT EXISTS (
    SELECT 1 FROM `review` AS existing_row
    WHERE existing_row.`review_id` = mock_row.`review_id`
);

-- Original comments 11-18 plus added comments 74-97; roots precede replies.

INSERT INTO `comment` (`comment_id`, `review_id`, `parent_comment_id`)
SELECT mock_row.`comment_id`, mock_row.`review_id`, mock_row.`parent_comment_id`
FROM (
    SELECT 11 AS `comment_id`, 1 AS `review_id`, NULL AS `parent_comment_id`
    UNION ALL SELECT 12, 1, 11
    UNION ALL SELECT 13, 3, NULL
    UNION ALL SELECT 14, 3, 13
    UNION ALL SELECT 15, 6, NULL
    UNION ALL SELECT 16, 6, 15
    UNION ALL SELECT 17, 10, NULL
    UNION ALL SELECT 18, 8, NULL
    UNION ALL SELECT 74, 19, NULL
    UNION ALL SELECT 75, 19, 74
    UNION ALL SELECT 76, 24, NULL
    UNION ALL SELECT 77, 24, 76
    UNION ALL SELECT 78, 27, NULL
    UNION ALL SELECT 79, 27, 78
    UNION ALL SELECT 80, 29, NULL
    UNION ALL SELECT 81, 29, 80
    UNION ALL SELECT 82, 33, NULL
    UNION ALL SELECT 83, 33, 82
    UNION ALL SELECT 84, 37, NULL
    UNION ALL SELECT 85, 37, 84
    UNION ALL SELECT 86, 41, NULL
    UNION ALL SELECT 87, 41, 86
    UNION ALL SELECT 88, 45, NULL
    UNION ALL SELECT 89, 45, 88
    UNION ALL SELECT 90, 51, NULL
    UNION ALL SELECT 91, 51, 90
    UNION ALL SELECT 92, 57, NULL
    UNION ALL SELECT 93, 57, 92
    UNION ALL SELECT 94, 61, NULL
    UNION ALL SELECT 95, 61, 94
    UNION ALL SELECT 96, 69, NULL
    UNION ALL SELECT 97, 69, 96
) AS mock_row
WHERE NOT EXISTS (
    SELECT 1 FROM `comment` AS existing_row
    WHERE existing_row.`comment_id` = mock_row.`comment_id`
)
ORDER BY mock_row.`comment_id`;

-- Original tags 1-10 plus tags 11-20.

INSERT INTO `tag` (`tag_id`, `label`)
SELECT mock_row.`tag_id`, mock_row.`label`
FROM (
    SELECT 1 AS `tag_id`, 'Tough grader' AS `label`
    UNION ALL SELECT 2, 'Clear lectures'
    UNION ALL SELECT 3, 'Lots of homework'
    UNION ALL SELECT 4, 'Group projects'
    UNION ALL SELECT 5, 'Test heavy'
    UNION ALL SELECT 6, 'Caring'
    UNION ALL SELECT 7, 'Inspirational'
    UNION ALL SELECT 8, 'Extra credit'
    UNION ALL SELECT 9, 'Lecture heavy'
    UNION ALL SELECT 10, 'Accessible outside class'
    UNION ALL SELECT 11, 'Off-topic'
    UNION ALL SELECT 12, 'Fair grading'
    UNION ALL SELECT 13, 'Detailed feedback'
    UNION ALL SELECT 14, 'Participation matters'
        UNION ALL SELECT 15, 'Fast paced'
    UNION ALL SELECT 16, 'Flexible deadlines'
    UNION ALL SELECT 17, 'Unclear instructions'
    UNION ALL SELECT 18, 'Practice problems'
    UNION ALL SELECT 19, 'Helpful labs'
    UNION ALL SELECT 20, 'Slow feedback'
) AS mock_row
WHERE NOT EXISTS (
    SELECT 1 FROM `tag` AS existing_row
    WHERE existing_row.`tag_id` = mock_row.`tag_id`
);

-- All original and new tag links; composite keys skip existing pairs.

INSERT INTO `review_tag` (`review_id`, `tag_id`)
SELECT mock_row.`review_id`, mock_row.`tag_id`
FROM (
    SELECT 1 AS `review_id`, 2 AS `tag_id`
    UNION ALL SELECT 1, 4
    UNION ALL SELECT 2, 2
    UNION ALL SELECT 2, 10
    UNION ALL SELECT 3, 9
    UNION ALL SELECT 3, 5
    UNION ALL SELECT 4, 2
    UNION ALL SELECT 4, 6
    UNION ALL SELECT 5, 3
    UNION ALL SELECT 6, 3
    UNION ALL SELECT 6, 5
    UNION ALL SELECT 7, 10
    UNION ALL SELECT 8, 6
    UNION ALL SELECT 8, 7
    UNION ALL SELECT 9, 9
    UNION ALL SELECT 5, 18
    UNION ALL SELECT 7, 2
    UNION ALL SELECT 9, 3
    UNION ALL SELECT 10, 11
    UNION ALL SELECT 19, 2
    UNION ALL SELECT 19, 4
    UNION ALL SELECT 19, 12
    UNION ALL SELECT 20, 18
    UNION ALL SELECT 20, 10
    UNION ALL SELECT 20, 5
    UNION ALL SELECT 21, 4
    UNION ALL SELECT 21, 13
    UNION ALL SELECT 21, 3
    UNION ALL SELECT 22, 5
    UNION ALL SELECT 22, 9
    UNION ALL SELECT 22, 15
    UNION ALL SELECT 23, 2
    UNION ALL SELECT 23, 18
    UNION ALL SELECT 23, 5
    UNION ALL SELECT 24, 19
    UNION ALL SELECT 24, 10
    UNION ALL SELECT 24, 12
    UNION ALL SELECT 25, 15
    UNION ALL SELECT 25, 9
    UNION ALL SELECT 25, 5
    UNION ALL SELECT 26, 2
    UNION ALL SELECT 26, 6
    UNION ALL SELECT 26, 19
    UNION ALL SELECT 27, 18
    UNION ALL SELECT 27, 3
    UNION ALL SELECT 27, 2
    UNION ALL SELECT 28, 19
    UNION ALL SELECT 28, 3
    UNION ALL SELECT 28, 13
    UNION ALL SELECT 29, 18
    UNION ALL SELECT 29, 5
    UNION ALL SELECT 29, 10
    UNION ALL SELECT 30, 2
    UNION ALL SELECT 30, 18
    UNION ALL SELECT 30, 12
    UNION ALL SELECT 31, 15
    UNION ALL SELECT 31, 3
    UNION ALL SELECT 31, 5
    UNION ALL SELECT 32, 18
    UNION ALL SELECT 32, 9
    UNION ALL SELECT 32, 5
    UNION ALL SELECT 33, 2
    UNION ALL SELECT 33, 18
    UNION ALL SELECT 33, 10
    UNION ALL SELECT 34, 2
    UNION ALL SELECT 34, 10
    UNION ALL SELECT 34, 16
    UNION ALL SELECT 35, 5
    UNION ALL SELECT 35, 18
    UNION ALL SELECT 35, 9
    UNION ALL SELECT 36, 17
    UNION ALL SELECT 36, 20
    UNION ALL SELECT 36, 3
    UNION ALL SELECT 37, 13
    UNION ALL SELECT 37, 6
    UNION ALL SELECT 37, 14
    UNION ALL SELECT 38, 13
    UNION ALL SELECT 38, 2
        UNION ALL SELECT 38, 16
    UNION ALL SELECT 39, 9
    UNION ALL SELECT 39, 14
    UNION ALL SELECT 39, 3
    UNION ALL SELECT 40, 20
    UNION ALL SELECT 40, 17
    UNION ALL SELECT 40, 3
    UNION ALL SELECT 41, 18
    UNION ALL SELECT 41, 13
    UNION ALL SELECT 41, 4
    UNION ALL SELECT 42, 2
    UNION ALL SELECT 42, 6
    UNION ALL SELECT 42, 18
    UNION ALL SELECT 43, 5
    UNION ALL SELECT 43, 18
    UNION ALL SELECT 43, 3
    UNION ALL SELECT 44, 15
    UNION ALL SELECT 44, 5
    UNION ALL SELECT 44, 3
    UNION ALL SELECT 45, 18
    UNION ALL SELECT 45, 19
    UNION ALL SELECT 45, 5
    UNION ALL SELECT 46, 2
    UNION ALL SELECT 46, 18
    UNION ALL SELECT 46, 10
    UNION ALL SELECT 47, 3
    UNION ALL SELECT 47, 5
    UNION ALL SELECT 47, 15
    UNION ALL SELECT 48, 9
    UNION ALL SELECT 48, 18
    UNION ALL SELECT 48, 19
    UNION ALL SELECT 49, 2
    UNION ALL SELECT 49, 6
    UNION ALL SELECT 49, 19
    UNION ALL SELECT 50, 3
    UNION ALL SELECT 50, 18
    UNION ALL SELECT 50, 10
    UNION ALL SELECT 51, 4
    UNION ALL SELECT 51, 13
    UNION ALL SELECT 51, 12
    UNION ALL SELECT 52, 19
    UNION ALL SELECT 52, 3
    UNION ALL SELECT 52, 9
    UNION ALL SELECT 53, 2
    UNION ALL SELECT 53, 19
    UNION ALL SELECT 53, 18
    UNION ALL SELECT 54, 17
    UNION ALL SELECT 54, 15
    UNION ALL SELECT 54, 5
    UNION ALL SELECT 55, 3
    UNION ALL SELECT 55, 5
    UNION ALL SELECT 55, 15
    UNION ALL SELECT 56, 18
    UNION ALL SELECT 56, 9
    UNION ALL SELECT 56, 12
    UNION ALL SELECT 57, 2
    UNION ALL SELECT 57, 18
    UNION ALL SELECT 57, 16
    UNION ALL SELECT 58, 17
    UNION ALL SELECT 58, 20
    UNION ALL SELECT 58, 5
    UNION ALL SELECT 59, 13
    UNION ALL SELECT 59, 6
    UNION ALL SELECT 59, 2
    UNION ALL SELECT 60, 13
    UNION ALL SELECT 60, 3
    UNION ALL SELECT 60, 14
    UNION ALL SELECT 61, 13
    UNION ALL SELECT 61, 10
    UNION ALL SELECT 61, 6
    UNION ALL SELECT 62, 3
    UNION ALL SELECT 62, 2
    UNION ALL SELECT 62, 16
    UNION ALL SELECT 63, 14
    UNION ALL SELECT 63, 3
    UNION ALL SELECT 63, 13
    UNION ALL SELECT 64, 2
    UNION ALL SELECT 64, 14
    UNION ALL SELECT 64, 18
    UNION ALL SELECT 65, 13
    UNION ALL SELECT 65, 18
    UNION ALL SELECT 65, 4
    UNION ALL SELECT 66, 9
    UNION ALL SELECT 66, 5
    UNION ALL SELECT 66, 18
    UNION ALL SELECT 67, 3
    UNION ALL SELECT 67, 17
    UNION ALL SELECT 67, 20
    UNION ALL SELECT 68, 2
    UNION ALL SELECT 68, 6
    UNION ALL SELECT 68, 14
        UNION ALL SELECT 69, 2
    UNION ALL SELECT 69, 18
    UNION ALL SELECT 69, 19
    UNION ALL SELECT 70, 18
    UNION ALL SELECT 70, 5
    UNION ALL SELECT 70, 10
    UNION ALL SELECT 71, 19
    UNION ALL SELECT 71, 3
    UNION ALL SELECT 71, 9
    UNION ALL SELECT 72, 15
    UNION ALL SELECT 72, 3
    UNION ALL SELECT 72, 5
    UNION ALL SELECT 73, 17
    UNION ALL SELECT 73, 5
    UNION ALL SELECT 73, 20
) AS mock_row
WHERE NOT EXISTS (
    SELECT 1 FROM `review_tag` AS existing_row
    WHERE existing_row.`review_id` = mock_row.`review_id` AND existing_row.`tag_id` = mock_row.`tag_id`
);

-- Original votes 1-12 plus added votes 13-174.

INSERT INTO `vote` (`vote_id`, `content_id`, `user_id`, `value`, `created_at`)
SELECT mock_row.`vote_id`, mock_row.`content_id`, mock_row.`user_id`, mock_row.`value`, mock_row.`created_at`
FROM (
    SELECT 1 AS `vote_id`, 1 AS `content_id`, 2 AS `user_id`, 1 AS `value`, '2025-12-16 08:25:00' AS `created_at`
    UNION ALL SELECT 2, 1, 3, 1, '2025-12-17 12:00:00'
    UNION ALL SELECT 3, 1, 4, 1, '2026-01-05 09:30:00'
    UNION ALL SELECT 4, 2, 1, 1, '2025-12-19 10:00:00'
    UNION ALL SELECT 5, 3, 1, -1, '2026-05-21 11:00:00'
    UNION ALL SELECT 6, 3, 4, 1, '2026-05-21 10:05:00'
    UNION ALL SELECT 7, 6, 3, 1, '2025-12-11 08:00:00'
    UNION ALL SELECT 8, 6, 4, -1, '2026-01-15 14:00:00'
    UNION ALL SELECT 9, 10, 1, -1, '2025-12-21 09:00:00'
    UNION ALL SELECT 10, 10, 4, -1, '2025-12-21 09:30:00'
    UNION ALL SELECT 11, 11, 1, 1, '2025-12-16 11:50:00'
    UNION ALL SELECT 12, 13, 3, 1, '2026-05-21 14:30:00'
    UNION ALL SELECT 13, 1, 8, 1, '2025-12-15 21:17:00'
    UNION ALL SELECT 14, 1, 9, 1, '2025-12-15 22:17:00'
    UNION ALL SELECT 15, 2, 11, 1, '2025-12-18 12:37:00'
    UNION ALL SELECT 16, 2, 12, 1, '2025-12-18 13:37:00'
    UNION ALL SELECT 17, 3, 14, 1, '2026-05-20 10:12:00'
    UNION ALL SELECT 18, 3, 15, 1, '2026-05-20 11:12:00'
    UNION ALL SELECT 19, 4, 17, 1, '2025-12-12 17:52:00'
    UNION ALL SELECT 20, 4, 18, 1, '2025-12-12 18:52:00'
    UNION ALL SELECT 21, 5, 20, 1, '2026-05-22 19:27:00'
    UNION ALL SELECT 22, 5, 5, -1, '2026-05-22 20:27:00'
    UNION ALL SELECT 23, 6, 7, -1, '2025-12-10 14:07:00'
    UNION ALL SELECT 24, 6, 8, 1, '2025-12-10 15:07:00'
    UNION ALL SELECT 25, 7, 10, 1, '2026-05-25 22:47:00'
    UNION ALL SELECT 26, 7, 11, 1, '2026-05-25 23:47:00'
    UNION ALL SELECT 27, 8, 13, 1, '2026-08-10 11:22:00'
    UNION ALL SELECT 28, 8, 14, 1, '2026-08-10 12:22:00'
    UNION ALL SELECT 29, 9, 16, 1, '2026-05-28 16:07:00'
    UNION ALL SELECT 30, 9, 17, 1, '2026-05-28 17:07:00'
    UNION ALL SELECT 31, 10, 19, -1, '2025-12-21 01:02:00'
    UNION ALL SELECT 32, 10, 20, -1, '2025-12-21 02:02:00'
    UNION ALL SELECT 33, 11, 6, 1, '2025-12-16 09:37:00'
    UNION ALL SELECT 34, 12, 9, 1, '2025-12-16 13:07:00'
    UNION ALL SELECT 35, 13, 12, -1, '2026-05-21 11:17:00'
    UNION ALL SELECT 36, 14, 15, 1, '2026-05-21 15:42:00'
    UNION ALL SELECT 37, 15, 18, 1, '2025-12-11 10:07:00'
    UNION ALL SELECT 38, 16, 5, -1, '2025-12-11 20:27:00'
    UNION ALL SELECT 39, 17, 8, 1, '2025-12-21 11:07:00'
    UNION ALL SELECT 40, 18, 11, 1, '2026-08-12 18:52:00'
    UNION ALL SELECT 41, 19, 14, 1, '2026-11-06 17:26:00'
    UNION ALL SELECT 42, 19, 15, 1, '2026-11-06 18:26:00'
    UNION ALL SELECT 43, 20, 17, 1, '2026-05-22 17:27:00'
    UNION ALL SELECT 44, 20, 18, 1, '2026-05-22 18:27:00'
    UNION ALL SELECT 45, 21, 20, 1, '2026-11-08 17:28:00'
    UNION ALL SELECT 46, 21, 5, 1, '2026-11-08 18:28:00'
    UNION ALL SELECT 47, 22, 7, 1, '2026-11-09 17:29:00'
    UNION ALL SELECT 48, 22, 9, 1, '2026-11-09 18:29:00'
    UNION ALL SELECT 49, 23, 10, 1, '2026-11-10 17:30:00'
    UNION ALL SELECT 50, 23, 11, -1, '2026-11-10 18:30:00'
    UNION ALL SELECT 51, 24, 13, -1, '2026-05-18 17:31:00'
    UNION ALL SELECT 52, 24, 14, 1, '2026-05-18 18:31:00'
    UNION ALL SELECT 53, 25, 16, 1, '2026-11-04 17:32:00'
    UNION ALL SELECT 54, 25, 17, 1, '2026-11-04 18:32:00'
    UNION ALL SELECT 55, 26, 19, 1, '2026-11-05 17:33:00'
    UNION ALL SELECT 56, 26, 20, 1, '2026-11-05 18:33:00'
    UNION ALL SELECT 57, 27, 6, 1, '2026-11-06 17:34:00'
    UNION ALL SELECT 58, 27, 7, 1, '2026-11-06 18:34:00'
    UNION ALL SELECT 59, 28, 9, 1, '2025-12-14 17:35:00'
    UNION ALL SELECT 60, 28, 10, 1, '2025-12-14 18:35:00'
    UNION ALL SELECT 61, 29, 12, 1, '2026-05-23 17:36:00'
    UNION ALL SELECT 62, 29, 13, -1, '2026-05-23 18:36:00'
    UNION ALL SELECT 63, 30, 15, -1, '2025-12-16 17:37:00'
    UNION ALL SELECT 64, 30, 17, 1, '2025-12-16 18:37:00'
    UNION ALL SELECT 65, 31, 18, 1, '2026-05-25 17:38:00'
        UNION ALL SELECT 66, 31, 19, 1, '2026-05-25 18:38:00'
    UNION ALL SELECT 67, 32, 5, 1, '2025-12-10 17:39:00'
    UNION ALL SELECT 68, 32, 6, 1, '2025-12-10 18:39:00'
    UNION ALL SELECT 69, 33, 8, 1, '2025-12-11 17:40:00'
    UNION ALL SELECT 70, 33, 9, 1, '2025-12-11 18:40:00'
    UNION ALL SELECT 71, 34, 11, 1, '2026-11-05 17:41:00'
    UNION ALL SELECT 72, 34, 12, 1, '2026-11-05 18:41:00'
    UNION ALL SELECT 73, 35, 14, 1, '2026-05-21 17:42:00'
    UNION ALL SELECT 74, 35, 15, -1, '2026-05-21 18:42:00'
    UNION ALL SELECT 75, 36, 17, -1, '2026-11-07 17:43:00'
    UNION ALL SELECT 76, 36, 18, 1, '2026-11-07 18:43:00'
    UNION ALL SELECT 77, 37, 20, 1, '2026-05-23 17:44:00'
    UNION ALL SELECT 78, 37, 5, 1, '2026-05-23 18:44:00'
    UNION ALL SELECT 79, 38, 7, 1, '2026-11-09 17:45:00'
    UNION ALL SELECT 80, 38, 9, 1, '2026-11-09 18:45:00'
    UNION ALL SELECT 81, 39, 10, 1, '2025-12-17 17:46:00'
    UNION ALL SELECT 82, 39, 11, 1, '2025-12-17 18:46:00'
    UNION ALL SELECT 83, 40, 13, 1, '2026-05-18 17:47:00'
    UNION ALL SELECT 84, 40, 14, 1, '2026-05-18 18:47:00'
    UNION ALL SELECT 85, 41, 16, 1, '2026-11-04 17:48:00'
    UNION ALL SELECT 86, 41, 17, -1, '2026-11-04 18:48:00'
    UNION ALL SELECT 87, 42, 19, -1, '2026-08-06 17:49:00'
    UNION ALL SELECT 88, 42, 20, 1, '2026-08-06 18:49:00'
    UNION ALL SELECT 89, 43, 6, 1, '2026-11-06 17:50:00'
    UNION ALL SELECT 90, 43, 7, 1, '2026-11-06 18:50:00'
    UNION ALL SELECT 91, 44, 9, 1, '2026-11-07 17:51:00'
    UNION ALL SELECT 92, 44, 10, 1, '2026-11-07 18:51:00'
    UNION ALL SELECT 93, 45, 12, 1, '2026-11-08 17:52:00'
    UNION ALL SELECT 94, 45, 13, 1, '2026-11-08 18:52:00'
    UNION ALL SELECT 95, 46, 15, 1, '2026-05-24 17:53:00'
    UNION ALL SELECT 96, 46, 17, 1, '2026-05-24 18:53:00'
    UNION ALL SELECT 97, 47, 18, 1, '2026-11-10 17:54:00'
    UNION ALL SELECT 98, 47, 19, -1, '2026-11-10 18:54:00'
    UNION ALL SELECT 99, 48, 5, -1, '2026-05-18 17:55:00'
    UNION ALL SELECT 100, 48, 6, 1, '2026-05-18 18:55:00'
    UNION ALL SELECT 101, 49, 8, 1, '2025-12-11 17:56:00'
    UNION ALL SELECT 102, 49, 9, 1, '2025-12-11 18:56:00'
    UNION ALL SELECT 103, 50, 11, 1, '2026-05-20 17:57:00'
    UNION ALL SELECT 104, 50, 12, 1, '2026-05-20 18:57:00'
    UNION ALL SELECT 105, 51, 14, 1, '2026-11-06 17:58:00'
    UNION ALL SELECT 106, 51, 15, 1, '2026-11-06 18:58:00'
    UNION ALL SELECT 107, 52, 17, 1, '2026-11-07 17:59:00'
    UNION ALL SELECT 108, 52, 18, 1, '2026-11-07 18:59:00'
    UNION ALL SELECT 109, 53, 20, 1, '2025-12-15 18:00:00'
    UNION ALL SELECT 110, 53, 5, -1, '2025-12-15 19:00:00'
    UNION ALL SELECT 111, 54, 7, -1, '2025-12-16 18:01:00'
    UNION ALL SELECT 112, 54, 9, 1, '2025-12-16 19:01:00'
    UNION ALL SELECT 113, 55, 10, 1, '2026-05-25 18:02:00'
    UNION ALL SELECT 114, 55, 11, 1, '2026-05-25 19:02:00'
    UNION ALL SELECT 115, 56, 13, 1, '2026-11-03 18:03:00'
    UNION ALL SELECT 116, 56, 14, 1, '2026-11-03 19:03:00'
    UNION ALL SELECT 117, 57, 16, 1, '2026-08-09 18:04:00'
    UNION ALL SELECT 118, 57, 17, 1, '2026-08-09 19:04:00'
    UNION ALL SELECT 119, 58, 19, 1, '2026-11-05 18:05:00'
    UNION ALL SELECT 120, 58, 20, 1, '2026-11-05 19:05:00'
    UNION ALL SELECT 121, 59, 6, 1, '2025-12-13 18:06:00'
    UNION ALL SELECT 122, 59, 7, -1, '2025-12-13 19:06:00'
    UNION ALL SELECT 123, 60, 9, -1, '2026-05-22 18:07:00'
    UNION ALL SELECT 124, 60, 10, 1, '2026-05-22 19:07:00'
    UNION ALL SELECT 125, 61, 12, 1, '2026-11-08 18:08:00'
    UNION ALL SELECT 126, 61, 13, 1, '2026-11-08 19:08:00'
    UNION ALL SELECT 127, 62, 15, 1, '2026-08-08 18:09:00'
    UNION ALL SELECT 128, 62, 17, 1, '2026-08-08 19:09:00'
    UNION ALL SELECT 129, 63, 18, 1, '2026-05-25 18:10:00'
    UNION ALL SELECT 130, 63, 19, 1, '2026-05-25 19:10:00'
    UNION ALL SELECT 131, 64, 5, 1, '2026-05-18 18:11:00'
    UNION ALL SELECT 132, 64, 6, 1, '2026-05-18 19:11:00'
    UNION ALL SELECT 133, 65, 8, 1, '2026-11-04 18:12:00'
    UNION ALL SELECT 134, 65, 9, -1, '2026-11-04 19:12:00'
    UNION ALL SELECT 135, 66, 11, -1, '2026-08-06 18:13:00'
    UNION ALL SELECT 136, 66, 12, 1, '2026-08-06 19:13:00'
    UNION ALL SELECT 137, 67, 14, 1, '2026-11-06 18:14:00'
    UNION ALL SELECT 138, 67, 15, 1, '2026-11-06 19:14:00'
    UNION ALL SELECT 139, 68, 17, 1, '2026-05-22 18:15:00'
    UNION ALL SELECT 140, 68, 18, 1, '2026-05-22 19:15:00'
    UNION ALL SELECT 141, 69, 20, 1, '2025-12-15 18:16:00'
    UNION ALL SELECT 142, 69, 5, 1, '2025-12-15 19:16:00'
    UNION ALL SELECT 143, 70, 7, 1, '2026-05-24 18:17:00'
    UNION ALL SELECT 144, 70, 9, 1, '2026-05-24 19:17:00'
    UNION ALL SELECT 145, 71, 10, 1, '2025-12-17 18:18:00'
    UNION ALL SELECT 146, 71, 11, -1, '2025-12-17 19:18:00'
    UNION ALL SELECT 147, 72, 13, -1, '2026-05-18 18:19:00'
    UNION ALL SELECT 148, 72, 14, 1, '2026-05-18 19:19:00'
    UNION ALL SELECT 149, 73, 16, 1, '2026-05-19 18:20:00'
    UNION ALL SELECT 150, 73, 17, 1, '2026-05-19 19:20:00'
    UNION ALL SELECT 151, 74, 19, 1, '2026-11-07 18:26:00'
    UNION ALL SELECT 152, 75, 6, 1, '2026-11-08 18:26:00'
    UNION ALL SELECT 153, 76, 9, 1, '2026-05-19 18:31:00'
    UNION ALL SELECT 154, 77, 12, 1, '2026-05-20 18:31:00'
    UNION ALL SELECT 155, 78, 15, -1, '2026-11-07 18:34:00'
    UNION ALL SELECT 156, 79, 18, 1, '2026-11-08 18:34:00'
    UNION ALL SELECT 157, 80, 5, 1, '2026-05-24 18:36:00'
    UNION ALL SELECT 158, 81, 8, 1, '2026-05-25 18:36:00'
        UNION ALL SELECT 159, 82, 11, 1, '2025-12-12 18:40:00'
    UNION ALL SELECT 160, 83, 14, 1, '2025-12-13 18:40:00'
    UNION ALL SELECT 161, 84, 17, 1, '2026-05-24 18:44:00'
    UNION ALL SELECT 162, 85, 20, 1, '2026-05-25 18:44:00'
    UNION ALL SELECT 163, 86, 7, 1, '2026-11-05 18:48:00'
    UNION ALL SELECT 164, 87, 10, 1, '2026-11-06 18:48:00'
    UNION ALL SELECT 165, 88, 13, 1, '2026-11-09 18:52:00'
    UNION ALL SELECT 166, 89, 16, 1, '2026-11-10 18:52:00'
    UNION ALL SELECT 167, 90, 19, 1, '2026-11-07 18:58:00'
    UNION ALL SELECT 168, 91, 6, -1, '2026-11-08 18:58:00'
    UNION ALL SELECT 169, 92, 9, 1, '2026-08-10 19:04:00'
    UNION ALL SELECT 170, 93, 12, 1, '2026-08-11 19:04:00'
    UNION ALL SELECT 171, 94, 15, 1, '2026-11-09 19:08:00'
    UNION ALL SELECT 172, 95, 18, 1, '2026-11-10 19:08:00'
    UNION ALL SELECT 173, 96, 5, 1, '2025-12-16 19:16:00'
    UNION ALL SELECT 174, 97, 8, 1, '2025-12-17 19:16:00'
) AS mock_row
WHERE NOT EXISTS (
    SELECT 1 FROM `vote` AS existing_row
    WHERE existing_row.`vote_id` = mock_row.`vote_id`
);

-- All three original moderation reports.

INSERT INTO `report` (`report_id`, `reporter_id`, `content_id`, `reason`, `summary`, `created_at`, `resolved_at`)
SELECT mock_row.`report_id`, mock_row.`reporter_id`, mock_row.`content_id`, mock_row.`reason`, mock_row.`summary`, mock_row.`created_at`, mock_row.`resolved_at`
FROM (
    SELECT 1 AS `report_id`, 1 AS `reporter_id`, 10 AS `content_id`, 'spam' AS `reason`, 'Selling a textbook, not a review of the class.' AS `summary`, '2025-12-21 09:05:00' AS `created_at`, NULL AS `resolved_at`
    UNION ALL SELECT 2, 2, 10, 'spam', NULL, '2025-12-21 09:35:00', NULL
    UNION ALL SELECT 3, 1, 16, 'off-topic', 'Selling a parking pass, nothing to do with the class.', '2025-12-12 08:00:00', '2025-12-12 15:30:00'
) AS mock_row
WHERE NOT EXISTS (
    SELECT 1 FROM `report` AS existing_row
    WHERE existing_row.`report_id` = mock_row.`report_id`
);

-- All four original submissions.

INSERT INTO `submission` (`submission_id`, `user_id`, `submission_type`, `submitted_prof_name`, `submitted_dept`, `submitted_class_code`, `status`, `reject_reason`, `created_at`, `reviewed_at`)
SELECT mock_row.`submission_id`, mock_row.`user_id`, mock_row.`submission_type`, mock_row.`submitted_prof_name`, mock_row.`submitted_dept`, mock_row.`submitted_class_code`, mock_row.`status`, mock_row.`reject_reason`, mock_row.`created_at`, mock_row.`reviewed_at`
FROM (
    SELECT 1 AS `submission_id`, 4 AS `user_id`, 'professor' AS `submission_type`, 'Jordan Ellis' AS `submitted_prof_name`, 'CMPS' AS `submitted_dept`, NULL AS `submitted_class_code`, 'pending' AS `status`, NULL AS `reject_reason`, '2026-10-20 13:00:00' AS `created_at`, NULL AS `reviewed_at`
    UNION ALL SELECT 2, 3, 'course', NULL, 'MATH', 'MATH 2200', 'approved', NULL, '2026-01-08 10:00:00', '2026-01-09 09:15:00'
    UNION ALL SELECT 3, 2, 'professor', 'Prof. Smith', 'PSYC', NULL, 'rejected', 'Not found in the CSUB faculty directory.', '2026-02-14 18:30:00', '2026-02-16 11:00:00'
    UNION ALL SELECT 4, 1, 'course', NULL, 'CMPS', 'CMPS 4910', 'pending', NULL, '2026-10-22 20:00:00', NULL
) AS mock_row
WHERE NOT EXISTS (
    SELECT 1 FROM `submission` AS existing_row
    WHERE existing_row.`submission_id` = mock_row.`submission_id`
);

COMMIT;

-- Read-only verification: expected counts are shown in the result.
SELECT 'professor' AS table_name, COUNT(*) AS actual_count, 13 AS expected_count FROM `professor`
UNION ALL SELECT 'teaching', COUNT(*), 40 FROM `teaching`
UNION ALL SELECT 'users', COUNT(*), 20 FROM `users`
UNION ALL SELECT 'review', COUNT(*), 65 FROM `review`
UNION ALL SELECT 'comment', COUNT(*), 32 FROM `comment`
UNION ALL SELECT 'tag', COUNT(*), 20 FROM `tag`
UNION ALL SELECT 'vote', COUNT(*), 174 FROM `vote`;

-- Each professor should have five reviews and five tagged reviews.
SELECT p.prof_id, p.first_name, p.last_name,
       COUNT(DISTINCT r.review_id) AS review_count,
       COUNT(DISTINCT rt.review_id) AS tagged_review_count
FROM `professor` AS p
LEFT JOIN `teaching` AS t ON t.prof_id = p.prof_id
LEFT JOIN `review` AS r ON r.teaching_id = t.teaching_id
LEFT JOIN `review_tag` AS rt ON rt.review_id = r.review_id
GROUP BY p.prof_id, p.first_name, p.last_name
ORDER BY p.prof_id;

-- Expected: zero non-example.com addresses and zero untagged reviews.
SELECT COUNT(*) AS non_example_emails FROM `users`
WHERE email NOT LIKE '%@example.com';
SELECT COUNT(*) AS untagged_reviews FROM `review` AS r
WHERE NOT EXISTS (SELECT 1 FROM `review_tag` AS rt WHERE rt.review_id = r.review_id);