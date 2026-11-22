-- data.sql - CSUB Rate My Professor (csubryp)
-- Expanded mock seed: 65 reviews TOTAL, including the original 10.
-- 13 professors, 40 teaching assignments, 20 users, 32 comments, 20 tags.
--
-- Run the project's schema first, then load this file into EMPTY tables:
--     mariadb -u YOUR_USER -p csubryp < sql/data.sql
-- This is a complete replacement seed, not a patch for an already seeded DB.
-- It does not drop, truncate, delete, or create any permanent tables.
-- Use a personal development database before any shared-database reload.
--
-- Original department, course, term, professor, and content IDs are retained.
-- Professor IDs 1-8 are the names supplied in the original seed; IDs 9-13
-- are fictional additions. All teaching assignments, reviews, comments,
-- users, and votes are mock data, not factual evaluations of any person.
-- Original reports, submissions, hidden review, and removed comment remain.
--
-- All mock email addresses use @example.com. The original four password_hash
-- strings are retained exactly as provided (they are placeholders).
-- If Danny has replaced those four hashes, retain his current values when
-- merging the users INSERT below. New users copy user 1's existing hash,
-- so no additional literal hashes need to be edited. No working password
-- is introduced by this file.
--
-- Content IDs 1-10 and 19-73 are reviews; 11-18 and 74-97 are comments.
-- review.review_id / comment.comment_id MUST match their content.content_id.
-- All 13 professors have five reviews. 64 reviews are visible and one is
-- the original hidden moderation example. Every review has at least one tag.
-- Ratings/difficulty: 1-5; booleans: 0/1; unknown optional answers: NULL.
-- Grades for new reviews in the ongoing Fall 2026 term are IP.

SET NAMES utf8mb4;
START TRANSACTION;

INSERT INTO `department` (`dept_id`, `code`, `name`) VALUES
    (1, 'CMPS', 'Computer Science'),
    (2, 'MATH', 'Mathematics'),
    (3, 'ENGL', 'English'),
    (4, 'PSYC', 'Psychology'),
    (5, 'PHYS', 'Physics');



-- Fictional additions are professor IDs 9-13.

INSERT INTO `professor` (`prof_id`, `dept_id`, `first_name`, `last_name`, `title`) VALUES
    (1, 1, 'Melissa', 'Danforth', 'Professor'),
    (2, 1, 'Nick', 'Toothman', 'Assistant Professor'),
    (3, 1, 'Jay', 'Manibo', 'Lecturer'),
    (4, 2, 'Charles', 'Lam', 'Professor'),
    (5, 2, 'Eduardo', 'Montoya', 'Professor'),
    (6, 3, 'Emerson', 'Case', 'Professor'),
    (7, 4, 'Tyler', 'Ensor', 'Associate Professor'),
    (8, 5, 'Yize', 'Li', 'Professor'),
    (9, 1, 'Elena', 'Marquez', 'Lecturer'),
    (10, 2, 'Adrian', 'Brooks', 'Assistant Professor'),
    (11, 3, 'Priya', 'Bennett', 'Lecturer'),
    (12, 4, 'Nolan', 'Reyes', 'Associate Professor'),
    (13, 5, 'Maya', 'Chen', 'Assistant Professor');



INSERT INTO `course` (`course_id`, `dept_id`, `subject`, `course_number`, `title`) VALUES
    (1, 1, 'CMPS', '2010', 'Programming I: Programming Fundamentals'),
    (2, 1, 'CMPS', '2020', 'Programming II: Data Structures and Algorithms'),
    (3, 1, 'CMPS', '3420', 'Database Systems'),
    (4, 1, 'CMPS', '3600', 'Operating Systems'),
    (5, 2, 'MATH', '2200', 'Introduction to Statistical Concepts and Methods'),
    (6, 2, 'MATH', '2510', 'Single Variable Calculus I'),
    (7, 3, 'ENGL', '1109', 'Writing and Research'),
    (8, 4, 'PSYC', '1018', 'Explorations in Psychology'),
    (9, 5, 'PHYS', '2210', 'Physics for Scientists and Engineers I'),
    (10, 1, 'CMPS', '3120', 'Algorithm Analysis'),
    (11, 1, 'CMPS', '2120', 'Discrete Structures'),
    (12, 1, 'CMPS', '3140', 'Theory of Computation'),
    (13, 1, 'CMPS', '3350', 'Software Engineering'),
    (14, 1, 'CMPS', '3500', 'Programming Languages'),
    (15, 1, 'CMPS', '4620', 'Network and Computer Security'),
    (16, 2, 'MATH', '2520', 'Single Variable Calculus II'),
    (17, 2, 'MATH', '2610', 'Linear Algebra I'),
    (18, 3, 'ENGL', '1100', 'Critical Reading and Writing'),
    (19, 4, 'PSYC', '2018', 'Introduction to Statistical Methods in Psychological Research'),
    (20, 5, 'PHYS', '2220', 'Physics for Scientists and Engineers II');



INSERT INTO `term` (`term_id`, `season`, `term_year`) VALUES
    (1, 'Fall', 2025),
    (2, 'Spring', 2026),
    (3, 'Summer', 2026),
    (4, 'Fall', 2026);



-- Teaching IDs 1-18 are retained; 19-40 are new mock assignments.

INSERT INTO `teaching` (`teaching_id`, `prof_id`, `course_id`, `term_id`, `modality`) VALUES
    (1, 1, 3, 1, 'In-Person'),
    (2, 1, 3, 4, 'In-Person'),
    (3, 2, 4, 2, 'Hybrid'),
    (4, 3, 1, 1, 'In-Person'),
    (5, 3, 2, 2, 'In-Person'),
    (6, 4, 6, 1, 'In-Person'),
    (7, 5, 5, 2, 'Online'),
    (8, 6, 7, 1, 'In-Person'),
    (9, 7, 8, 3, 'Online'),
    (10, 8, 9, 2, 'In-Person'),
    (11, 2, 10, 4, 'In-Person'),
    (12, 3, 1, 4, 'Hybrid'),
    (13, 1, 11, 2, 'In-Person'),
    (14, 2, 12, 4, 'In-Person'),
    (15, 3, 14, 4, 'In-Person'),
    (16, 4, 16, 2, 'In-Person'),
    (17, 7, 19, 4, 'Hybrid'),
    (18, 8, 20, 4, 'In-Person'),
    (19, 1, 13, 4, 'Hybrid'),
    (20, 5, 17, 1, 'In-Person'),
    (21, 5, 5, 4, 'Online'),
    (22, 6, 18, 2, 'Hybrid'),
    (23, 6, 7, 4, 'Online'),
    (24, 9, 1, 1, 'In-Person'),
    (25, 9, 2, 2, 'Hybrid'),
    (26, 9, 13, 4, 'In-Person'),
    (27, 10, 6, 1, 'In-Person'),
    (28, 10, 16, 2, 'In-Person'),
    (29, 10, 17, 4, 'Hybrid'),
    (30, 11, 18, 1, 'Online'),
    (31, 11, 7, 2, 'In-Person'),
    (32, 11, 7, 4, 'Hybrid'),
    (33, 12, 8, 2, 'In-Person'),
    (34, 12, 19, 4, 'Online'),
    (35, 13, 9, 1, 'In-Person'),
    (36, 13, 20, 2, 'Hybrid'),
    (37, 9, 15, 4, 'Hybrid'),
    (38, 10, 5, 3, 'Online'),
    (39, 11, 18, 3, 'Online'),
    (40, 12, 8, 3, 'Online');



-- Keep the current password_hash values from your working branch here.

INSERT INTO `users` (`user_id`, `email`, `username`, `password_hash`, `class_year`, `user_type`, `user_status`, `created_at`, `last_login`) VALUES
    (1, 'aestrada@example.com', 'aestrada', '$2y$10$placeholderhashplaceholderhashplaceholderhash01', NULL, 'user', 'active', '2025-08-20 14:12:00', '2026-10-24 21:05:00'),
    (2, 'dvillanueva@example.com', 'dvillanueva', '$2y$10$placeholderhashplaceholderhashplaceholderhash02', 'Senior', 'admin', 'active', '2025-08-15 09:00:00', '2026-10-26 07:50:00'),
    (3, 'mnuno@example.com', 'mnuno', '$2y$10$placeholderhashplaceholderhashplaceholderhash03', NULL, 'user', 'active', '2025-08-22 10:40:00', '2026-10-23 08:15:00'),
    (4, 'gcarrillo@example.com', 'gcarrillo', '$2y$10$placeholderhashplaceholderhashplaceholderhash04', NULL, 'user', 'active', '2025-09-01 16:00:00', '2026-10-20 12:00:00');

-- Additional fictional accounts inherit user 1's hash without changing it.
INSERT INTO `users` (`user_id`, `email`, `username`, `password_hash`, `class_year`,
                     `user_type`, `user_status`, `created_at`, `last_login`)
SELECT mock_user.user_id, mock_user.email, mock_user.username, seed_user.password_hash,
       NULL, 'user', 'active', '2025-08-25 09:00:00', '2026-11-16 23:00:00'
FROM (

    SELECT 5 AS user_id, 'student05@example.com' AS email, 'mock05' AS username
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
WHERE seed_user.user_id = 1;



-- Reviews and comments share this parent table and its primary key.

INSERT INTO `content` (`content_id`, `user_id`, `content_type`, `body`, `created_at`, `status`) VALUES
    (1, 1, 'review', 'Lectures are organized and the ER modeling project really helped. Exams are hard but fair.', '2025-12-15 20:10:00', 'visible'),
    (2, 2, 'review', 'Great class if you keep up with the labs. Office hours were very helpful.', '2025-12-18 11:30:00', 'visible'),
    (3, 3, 'review', 'Interesting material. Exams are challenging, so review the readings too.', '2026-05-20 09:05:00', 'visible'),
    (4, 4, 'review', 'Perfect first programming class. Explains everything slowly and clearly.', '2025-12-12 16:45:00', 'visible'),
    (5, 1, 'review', 'Lots of weekly homework, but it prepares you well for the projects.', '2026-05-22 18:20:00', 'visible'),
    (6, 2, 'review', 'Very fast paced and quizzes every week. Go to tutoring early.', '2025-12-10 13:00:00', 'visible'),
    (7, 3, 'review', 'Online format works well. Responds to email quickly.', '2026-05-25 21:40:00', 'visible'),
    (8, 4, 'review', 'Easy to follow and genuinely cares whether students understand.', '2026-08-10 10:15:00', 'visible'),
    (9, 1, 'review', 'Lab reports take a long time but lectures are clear.', '2026-05-28 15:00:00', 'visible'),
    (10, 3, 'review', 'Selling my used textbook for this class, message me if interested.', '2025-12-20 23:55:00', 'hidden'),
    (11, 3, 'comment', 'Agreed, the project made normalization click for me.', '2025-12-16 08:30:00', 'visible'),
    (12, 1, 'comment', 'Same. Start the project early though.', '2025-12-16 12:00:00', 'visible'),
    (13, 4, 'comment', 'Did the final cover scheduling algorithms?', '2026-05-21 10:10:00', 'visible'),
    (14, 3, 'comment', 'Yes, mostly round robin and priority scheduling.', '2026-05-21 14:35:00', 'visible'),
  (15, 1, 'comment', 'Tutoring center on the second floor helped me a lot.', '2025-12-11 09:00:00', 'visible'),
    (16, 4, 'comment', 'Anyone selling a used parking pass?', '2025-12-11 19:20:00', 'removed'),
    (17, 2, 'comment', 'This review does not say anything about the actual class.', '2025-12-21 10:00:00', 'visible'),
    (18, 2, 'comment', 'Taking this online next summer, thanks for the review.', '2026-08-12 17:45:00', 'visible'),
    (19, 5, 'review', 'The database project connects ER diagrams, normalization, and SQL. Milestone feedback has helped our group catch mistakes early.', '2026-11-06 16:19:00', 'visible'),
    (20, 6, 'review', 'Discrete math takes steady practice. The proof examples and office hours helped, but memorizing definitions alone was not enough for the exams.', '2026-05-22 16:20:00', 'visible'),
    (21, 7, 'review', 'Our software engineering project has clear checkpoints. Peer evaluations make it important to keep track of who completes each task.', '2026-11-08 16:21:00', 'visible'),
    (22, 8, 'review', 'Algorithm analysis moves quickly and the proofs take time. Working through examples before lecture has been more useful than just reading my notes.', '2026-11-09 16:22:00', 'visible'),
    (23, 9, 'review', 'Automata diagrams are explained clearly. The homework is difficult, but the practice questions show the level of reasoning expected on tests.', '2026-11-10 16:23:00', 'visible'),
    (24, 10, 'review', 'The scheduling and memory exercises made operating systems much easier to understand. Office hours were especially helpful before the final.', '2026-05-18 16:24:00', 'visible'),
    (25, 11, 'review', 'I need more intermediate steps during the algorithm proofs. The pace is difficult to follow if I have not already attempted the assigned problems.', '2026-11-04 16:25:00', 'visible'),
    (26, 12, 'review', 'The hybrid programming labs are easy to follow. Small examples come before the larger assignments, which helped me build confidence with loops.', '2026-11-05 16:26:00', 'visible'),
    (27, 13, 'review', 'Comparing the same task in different programming languages is useful. Start the assignments early because switching syntax can take longer than expected.', '2026-11-06 16:27:00', 'visible'),
    (28, 14, 'review', 'The introductory labs were useful, and the written feedback showed where my logic went wrong. Weekly assignments still took more time than I expected.', '2025-12-14 16:28:00', 'visible'),
    (29, 15, 'review', 'Integration techniques require a lot of practice. The review sheets helped me decide which method to use instead of guessing during the exam.', '2026-05-23 16:29:00', 'visible'),
    (30, 16, 'review', 'Worked calculus examples include the algebra steps that are easy to forget. The exams felt fair when I completed the practice problems.', '2025-12-16 16:30:00', 'visible'),
    (31, 17, 'review', 'Calculus II moved faster than I could comfortably manage. There was plenty of homework, but I needed additional tutoring to connect the different methods.', '2026-05-25 16:31:00', 'visible'),
    (32, 18, 'review', 'Daily practice matters in this class. Lectures cover the material, but I learned the most by redoing problems without looking at the solutions.', '2025-12-10 16:32:00', 'visible'),
    (33, 19, 'review', 'The matrix examples show every row operation. Office hours helped me understand why the procedures work instead of only memorizing the steps.', '2025-12-11 16:33:00', 'visible'),
    (34, 20, 'review', 'Recorded statistics lessons are organized by topic. Questions get a quick response, and the weekly schedule leaves some flexibility for completing practice.', '2026-11-05 16:34:00', 'visible'),
    (35, 5, 'review', 'Weekly statistics quizzes kept me studying. The examples were useful, although I wanted more explanation of why some of my answers were incorrect.', '2026-05-21 16:35:00', 'visible'),
    (36, 6, 'review', 'Some online assignment instructions have been hard to interpret. I would find it easier to improve if feedback arrived before the next homework deadline.', '2026-11-07 16:36:00', 'visible'),
    (37, 7, 'review', 'Revising essays after feedback improved my argument structure. Class discussions helped me notice when a paragraph needed more evidence.', '2026-05-23 16:37:00', 'visible'),
    (38, 8, 'review', 'The writing rubrics explain how evidence and organization are graded. Draft feedback and flexible revision deadlines make the online format manageable.', '2026-11-09 16:38:00', 'visible'),
    (39, 9, 'review', 'The readings supported interesting discussions, but several essays were due close together. Planning the research early made the workload more manageable.', '2025-12-17 16:39:00', 'visible'),
    (40, 10, 'review', 'Some essay feedback arrived after the next draft was underway. I had trouble applying the expectations consistently and wanted more sample paragraphs.', '2026-05-18 16:40:00', 'visible'),
    (41, 11, 'review', 'The statistics project connects calculations to research questions. Feedback on interpreting results has been more valuable than memorizing formulas.', '2026-11-04 16:41:00', 'visible'),
    (42, 12, 'review', 'Short psychology videos and weekly examples made the summer schedule manageable. The practice questions matched the main ideas covered in each module.', '2026-08-06 16:42:00', 'visible'),
    (43, 13, 'review', 'The research examples are useful, but the statistics homework takes time. I have needed regular practice to keep the different tests straight.', '2026-11-06 16:43:00', 'visible'),
    (44, 14, 'review', 'The statistics course moves quickly once the project starts. Balancing the exams and group deadlines has been difficult alongside my other classes.', '2026-11-07 16:44:00', 'visible'),
    (45, 15, 'review', 'Circuit problems build on the earlier homework, and the labs help connect equations to measurements. Expect the exams to combine several concepts.', '2026-11-08 16:45:00', 'visible'),
    (46, 16, 'review', 'The physics problem setup is explained carefully. Drawing diagrams before choosing equations made a noticeable difference on my exams.', '2026-05-24 16:46:00', 'visible'),
    (47, 17, 'review', 'Lab reports and exam preparation often land in the same week. The material is interesting, but I have struggled to keep up with the workload.', '2026-11-10 16:47:00', 'visible'),
    (48, 18, 'review', 'Lectures provide a solid foundation, but the physics problems need repeated practice. The lab sessions were useful for checking my understanding.', '2026-05-18 16:48:00', 'visible'),
    (49, 19, 'review', 'Live coding examples made the first programming course approachable. Questions were welcome, and lab feedback explained how to improve my solutions.', '2025-12-11 16:49:00', 'visible'),
    (50, 20, 'review', 'Data structures assignments take time, especially the tree exercises. Office hours helped me debug without simply giving away the answer.', '2026-05-20 16:50:00', 'visible'),
    (51, 5, 'review', 'The application project has useful milestones and a clear rubric. Regular group check-ins have kept the work from piling up at the end.', '2026-11-06 16:51:00', 'visible'),
    (52, 6, 'review', 'The security labs are interesting and require careful documentation. I would like more time discussing the lab results during lecture.', '2026-11-07 16:52:00', 'visible'),
    (53, 7, 'review', 'Starting with small programming exercises helped me learn the basics. The optional practice problems were useful before the larger assignments.', '2025-12-15 16:53:00', 'visible'),
    (54, 8, 'review', 'I found the calculus explanations difficult to follow, and the tests moved beyond the examples I had practiced. I needed more guidance between exams.', '2025-12-16 16:54:00', 'visible'),
    (55, 9, 'review', 'The amount of calculus homework was hard to balance with the tests. Extra practice helped somewhat, but the pace still felt too fast for me.', '2026-05-25 16:55:00', 'visible'),
    (56, 10, 'review', 'Linear algebra lectures cover useful examples. Grading has been consistent, though I need to work through extra problems to feel ready for quizzes.', '2026-11-03 16:56:00', 'visible'),
    (57, 11, 'review', 'The recorded summer statistics lessons were clear and the quizzes followed the examples. Flexible practice deadlines helped with the compressed schedule.', '2026-08-09 16:57:00', 'visible'),
    (58, 12, 'review', 'I have needed more clarification on what to show in written solutions. Getting quiz feedback sooner would help me prepare for the next assessment.', '2026-11-05 16:58:00', 'visible'),
    (59, 13, 'review', 'The online writing modules explain each stage of an argument. Specific comments on my drafts helped me make stronger connections between evidence and claims.', '2025-12-13 16:59:00', 'visible'),
    (60, 14, 'review', 'The research paper is a lot of work, but the proposal and source checks make it easier to manage. Class discussion helped me narrow my topic.', '2026-05-22 17:00:00', 'visible'),
    (61, 15, 'review', 'Short writing conferences have been especially helpful. The feedback explains why a revision would improve the argument instead of only marking errors.', '2026-11-08 17:01:00', 'visible'),
    (62, 16, 'review', 'The summer writing schedule is busy, but the instructions are clear. Being able to revise a draft helped me improve without falling behind.', '2026-08-08 17:02:00', 'visible'),
    (63, 17, 'review', 'Discussion and peer review are a large part of the writing class. The detailed feedback helped, although I preferred the individual assignments.', '2026-05-25 17:03:00', 'visible'),
    (64, 18, 'review', 'Examples about memory and learning made the psychology concepts easier to remember. Participating in class helped me prepare for the application questions.', '2026-05-18 17:04:00', 'visible'),
    (65, 19, 'review', 'The research statistics project includes feedback at each stage. Explaining the output in plain language has helped me understand what the tests mean.', '2026-11-04 17:05:00', 'visible'),
    (66, 20, 'review', 'The summer psychology quizzes were manageable when I kept up with the readings. The recorded lectures mostly followed the textbook examples.', '2026-08-06 17:06:00', 'visible'),
    (67, 5, 'review', 'The online discussion requirements have been difficult to interpret. I would like more examples of a complete statistics project before submitting each section.', '2026-11-06 17:07:00', 'visible'),
    (68, 6, 'review', 'Applying psychology ideas to everyday situations made lectures engaging. Questions were taken seriously, and the study guides identified the main concepts.', '2026-05-22 17:08:00', 'visible'),
    (69, 7, 'review', 'Free-body diagrams were explained step by step, and the labs reinforced the lecture material. The class was challenging but the expectations were clear.', '2025-12-15 17:09:00', 'visible'),
    (70, 8, 'review', 'Fields and circuits took a lot of practice. Office hours helped me connect the equations to the physical situations described in the problems.', '2026-05-24 17:10:00', 'visible'),
    (71, 9, 'review', 'The physics labs were useful, but the reports took longer than expected. I needed additional practice outside lecture to prepare for the exams.', '2025-12-17 17:11:00', 'visible'),
    (72, 10, 'review', 'I withdrew when I could not keep up with the weekly problem sets. The course required more preparation time than I could manage that semester.', '2026-05-18 17:12:00', 'visible'),
    (73, 11, 'review', 'I had trouble connecting the physics examples to the exam questions. More feedback on my setup and intermediate steps would have helped me study.', '2026-05-19 17:13:00', 'visible'),
    (74, 8, 'comment', 'Did the database project include an ER diagram?', '2026-11-07 17:19:00', 'visible'),
    (75, 5, 'comment', 'Yes, we submitted the ER diagram before building the tables.', '2026-11-08 17:19:00', 'visible'),
    (76, 13, 'comment', 'Were the scheduling exercises done in groups?', '2026-05-19 17:24:00', 'visible'),
    (77, 10, 'comment', 'We discussed them together, but each person turned in a solution.', '2026-05-20 17:24:00', 'visible'),
    (78, 16, 'comment', 'Do you need to know all the languages before starting?', '2026-11-07 17:27:00', 'visible'),
    (79, 13, 'comment', 'No. The assignments introduce the syntax before asking you to compare it.', '2026-11-08 17:27:00', 'visible'),
    (80, 18, 'comment', 'Did the review sheets include integration by parts?', '2026-05-24 17:29:00', 'visible'),
    (81, 15, 'comment', 'Yes, and there were several examples of choosing the two parts.', '2026-05-25 17:29:00', 'visible'),
    (82, 6, 'comment', 'Were the matrix examples worked out during lecture?', '2025-12-12 17:33:00', 'visible'),
    (83, 19, 'comment', 'Yes, the full row reduction steps were shown.', '2025-12-13 17:33:00', 'visible'),
    (84, 10, 'comment', 'Could you revise the first essay after feedback?', '2026-05-24 17:37:00', 'visible'),
    (85, 7, 'comment', 'Yes, we had a separate revision deadline after getting comments.', '2026-05-25 17:37:00', 'visible'),
    (86, 14, 'comment', 'Which part of the statistics project took the most time?', '2026-11-05 17:41:00', 'visible'),
    (87, 11, 'comment', 'Cleaning the data and explaining the output took longer than running the calculations.', '2026-11-06 17:41:00', 'visible'),
    (88, 18, 'comment', 'Were the circuit problems similar to the homework?', '2026-11-09 17:45:00', 'visible'),
    (89, 15, 'comment', 'The concepts matched, but the exam combined more than one step.', '2026-11-10 17:45:00', 'visible'),
    (90, 8, 'comment', 'Did groups get to pick their own application idea?', '2026-11-07 17:51:00', 'visible'),
    (91, 5, 'comment', 'Yes, as long as the idea met the requirements in the project proposal.', '2026-11-08 17:51:00', 'visible'),
    (92, 14, 'comment', 'Were the summer lectures recorded?', '2026-08-10 17:57:00', 'visible'),
    (93, 11, 'comment', 'Yes, I watched the recordings before completing the weekly quizzes.', '2026-08-11 17:57:00', 'visible'),
    (94, 18, 'comment', 'Were writing conferences held during class time?', '2026-11-09 18:01:00', 'visible'),
    (95, 15, 'comment', 'We scheduled short meetings during the conference week.', '2026-11-10 18:01:00', 'visible'),
    (96, 10, 'comment', 'Did drawing diagrams help with exam questions?', '2025-12-16 18:09:00', 'visible'),
    (97, 7, 'comment', 'Yes, labeling the forces first made the equations much easier to set up.', '2025-12-17 18:09:00', 'visible');
-- Review IDs match the corresponding content IDs, not a separate sequence.

INSERT INTO `review` (`review_id`, `teaching_id`, `rating`, `difficulty`, `grade`, `attendance`, `textbook`, `would_retake`) VALUES
    (1, 1, 5, 4, 'A-', 1, 0, 1),
    (2, 1, 4, 4, 'B+', 1, 0, 1),
    (3, 3, 4, 5, 'B', 0, 1, 1),
    (4, 4, 5, 2, 'A', 1, 0, 1),
    (5, 5, 4, 3, 'A-', 1, 0, 1),
    (6, 6, 4, 5, 'C+', 1, 1, 1),
    (7, 7, 4, 3, 'B+', 0, 0, 1),
    (8, 9, 5, 1, 'A', 0, 1, 1),
    (9, 10, 3, 4, 'B-', 1, 1, 1),
    (10, 8, 3, 3, NULL, NULL, 1, 1),
    (19, 2, 5, 4, 'IP', 1, 0, 1),
    (20, 13, 4, 4, 'B', 1, 1, 1),
    (21, 19, 4, 3, 'IP', 1, 0, 1),
    (22, 11, 3, 5, 'IP', 1, 1, 0),
    (23, 14, 4, 5, 'IP', 1, 1, 1),
    (24, 3, 5, 4, 'A-', 0, 1, 1),
    (25, 11, 2, 5, 'IP', 1, 1, 0),
    (26, 12, 5, 2, 'IP', 1, 0, 1),
    (27, 15, 4, 4, 'IP', 1, 0, 1),
    (28, 4, 3, 3, 'B', 1, 0, 1),
    (29, 16, 4, 5, 'B', 1, 1, 1),
    (30, 6, 5, 4, 'A-', 1, 1, 1),
    (31, 16, 2, 5, 'C', 1, 1, 0),
    (32, 6, 3, 4, 'B-', 1, 1, 0),
    (33, 20, 5, 3, 'A', 1, 1, 1),
    (34, 21, 4, 3, 'IP', 0, 0, 1),
    (35, 7, 3, 3, 'B', 0, 0, 1),
    (36, 21, 2, 4, 'IP', NULL, NULL, 0),
    (37, 22, 4, 3, 'A-', 1, 0, 1),
    (38, 23, 5, 2, 'IP', 0, 0, 1),
    (39, 8, 3, 3, 'B', 1, 1, 1),
    (40, 22, 2, 4, 'C+', 1, 0, 0),
    (41, 17, 4, 4, 'IP', 1, 1, 1),
    (42, 9, 5, 2, 'A', 0, 1, 1),
    (43, 17, 3, 4, 'IP', 1, 1, 1),
    (44, 17, 2, 5, 'IP', 1, 1, 0),
    (45, 18, 4, 5, 'IP', 1, 1, 1),
    (46, 10, 5, 4, 'A-', 1, 1, 1),
    (47, 18, 2, 5, 'IP', 1, 1, 0),
    (48, 10, 3, 4, 'B', 1, 1, 1),
    (49, 24, 5, 2, 'A', 1, 0, 1),
    (50, 25, 4, 4, 'B+', 1, 0, 1),
    (51, 26, 5, 3, 'IP', 1, 0, 1),
    (52, 37, 3, 4, 'IP', 1, 1, 1),
    (53, 24, 4, 2, 'A-', 1, 0, 1),
    (54, 27, 1, 5, 'D', 1, 1, 0),
    (55, 28, 2, 5, 'C-', 1, 1, 0),
    (56, 29, 3, 4, 'IP', 1, 1, 1),
    (57, 38, 4, 3, 'B+', 0, 0, 1),
    (58, 29, 2, 4, 'IP', 1, 1, 0),
    (59, 30, 5, 2, 'A', 0, 0, 1),
    (60, 31, 4, 3, 'B+', 1, 1, 1),
    (61, 32, 5, 2, 'IP', 1, 0, 1),
    (62, 39, 4, 3, 'A-', 0, 0, 1),
    (63, 31, 3, 3, 'B', 1, 1, 1),
    (64, 33, 4, 3, 'B+', 1, 1, 1),
    (65, 34, 5, 4, 'IP', 0, 0, 1),
    (66, 40, 3, 2, 'A-', 0, 1, 1),
    (67, 34, 2, 4, 'IP', 0, 0, 0),
    (68, 33, 4, 3, 'B+', 1, 1, 1),
    (69, 35, 5, 4, 'A-', 1, 1, 1),
    (70, 36, 4, 5, 'B', 1, 1, 1),
    (71, 35, 3, 4, 'B-', 1, 1, 1),
    (72, 36, 2, 5, 'W', 1, 1, 0),
    (73, 36, 1, 5, 'F', 1, 1, 0);



-- Parent comments are inserted before replies and belong to the same review.

INSERT INTO `comment` (`comment_id`, `review_id`, `parent_comment_id`) VALUES
    (11, 1, NULL),
    (12, 1, 11),
    (13, 3, NULL),
    (14, 3, 13),
    (15, 6, NULL),
    (16, 6, 15),
    (17, 10, NULL),
    (18, 8, NULL),
    (74, 19, NULL),
    (75, 19, 74),
    (76, 24, NULL),
    (77, 24, 76),
    (78, 27, NULL),
    (79, 27, 78),
    (80, 29, NULL),
    (81, 29, 80),
    (82, 33, NULL),
    (83, 33, 82),
    (84, 37, NULL),
    (85, 37, 84),
    (86, 41, NULL),
    (87, 41, 86),
    (88, 45, NULL),
    (89, 45, 88),
    (90, 51, NULL),
     (88, 45, NULL),
    (89, 45, 88),
    (90, 51, NULL),
    (91, 51, 90),
    (92, 57, NULL),
    (93, 57, 92),
    (94, 61, NULL),
    (95, 61, 94),
    (96, 69, NULL),
    (97, 69, 96);



INSERT INTO `tag` (`tag_id`, `label`) VALUES
    (1, 'Tough grader'),
    (2, 'Clear lectures'),
    (3, 'Lots of homework'),
    (4, 'Group projects'),
    (5, 'Test heavy'),
    (6, 'Caring'),
    (7, 'Inspirational'),
    (8, 'Extra credit'),
    (9, 'Lecture heavy'),
    (10, 'Accessible outside class'),
    (11, 'Off-topic'),
    (12, 'Fair grading'),
    (13, 'Detailed feedback'),
    (14, 'Participation matters'),
    (15, 'Fast paced'),
    (16, 'Flexible deadlines'),
    (17, 'Unclear instructions'),
    (18, 'Practice problems'),
    (19, 'Helpful labs'),
    (20, 'Slow feedback');



-- Tags drive filter and similar-professor examples; no duplicate pairs.

INSERT INTO `review_tag` (`review_id`, `tag_id`) VALUES
    (1, 2),
    (1, 4),
    (2, 2),
    (2, 10),
    (3, 9),
    (3, 5),
    (4, 2),
    (4, 6),
    (5, 3),
    (6, 3),
    (6, 5),
    (7, 10),
    (8, 6),
    (8, 7),
    (9, 9),
    (5, 18),
    (7, 2),
    (9, 3),
    (10, 11),
    (19, 2),
    (19, 4),
    (19, 12),
    (20, 18),
    (20, 10),
    (20, 5),
    (21, 4),
    (21, 13),
    (21, 3),
    (22, 5),
    (22, 9),
    (22, 15),
    (23, 2),
    (23, 18),
    (23, 5),
    (24, 19),
    (24, 10),
    (24, 12),
    (25, 15),
    (25, 9),
    (25, 5),
    (26, 2),
    (26, 6),
    (26, 19),
    (27, 18),
    (27, 3),
    (27, 2),
    (28, 19),
    (28, 3),
    (28, 13),
    (29, 18),
    (29, 5),
    (29, 10),
    (30, 2),
    (30, 18),
        (30, 12),
    (31, 15),
    (31, 3),
    (31, 5),
    (32, 18),
    (32, 9),
    (32, 5),
    (33, 2),
    (33, 18),
    (33, 10),
    (34, 2),
    (34, 10),
    (34, 16),
    (35, 5),
    (35, 18),
    (35, 9),
    (36, 17),
    (36, 20),
    (36, 3),
    (37, 13),
    (37, 6),
    (37, 14),
    (38, 13),
    (38, 2),
    (38, 16),
    (39, 9),
    (39, 14),
    (39, 3),
    (40, 20),
    (40, 17),
    (40, 3),
    (41, 18),
    (41, 13),
    (41, 4),
    (42, 2),
    (42, 6),
    (42, 18),
    (43, 5),
    (43, 18),
    (43, 3),
    (44, 15),
    (44, 5),
    (44, 3),
    (45, 18),
    (45, 19),
    (45, 5),
    (46, 2),
    (46, 18),
    (46, 10),
    (47, 3),
    (47, 5),
    (47, 15),
    (48, 9),
    (48, 18),
    (48, 19),
    (49, 2),
    (49, 6),
    (49, 19),
    (50, 3),
    (50, 18),
    (50, 10),
    (51, 4),
    (51, 13),
    (51, 12),
    (52, 19),
    (52, 3),
    (52, 9),
    (53, 2),
    (53, 19),
    (53, 18),
    (54, 17),
    (54, 15),
    (54, 5),
    (55, 3),
    (55, 5),
    (55, 15),
    (56, 18),
    (56, 9),
    (56, 12),
    (57, 2),
    (57, 18),
        (57, 16),
    (58, 17),
    (58, 20),
    (58, 5),
    (59, 13),
    (59, 6),
    (59, 2),
    (60, 13),
    (60, 3),
    (60, 14),
    (61, 13),
    (61, 10),
    (61, 6),
    (62, 3),
    (62, 2),
    (62, 16),
    (63, 14),
    (63, 3),
    (63, 13),
    (64, 2),
    (64, 14),
    (64, 18),
    (65, 13),
    (65, 18),
    (65, 4),
    (66, 9),
    (66, 5),
    (66, 18),
    (67, 3),
    (67, 17),
    (67, 20),
    (68, 2),
    (68, 6),
    (68, 14),
    (69, 2),
    (69, 18),
    (69, 19),
    (70, 18),
    (70, 5),
    (70, 10),
    (71, 19),
    (71, 3),
    (71, 9),
    (72, 15),
    (72, 3),
    (72, 5),
    (73, 17),
    (73, 5),
    (73, 20);



-- Each user votes at most once on a content item; no self-votes.

INSERT INTO `vote` (`vote_id`, `content_id`, `user_id`, `value`, `created_at`) VALUES
    (1, 1, 2, 1, '2025-12-16 08:25:00'),
    (2, 1, 3, 1, '2025-12-17 12:00:00'),
    (3, 1, 4, 1, '2026-01-05 09:30:00'),
    (4, 2, 1, 1, '2025-12-19 10:00:00'),
    (5, 3, 1, -1, '2026-05-21 11:00:00'),
    (6, 3, 4, 1, '2026-05-21 10:05:00'),
    (7, 6, 3, 1, '2025-12-11 08:00:00'),
    (8, 6, 4, -1, '2026-01-15 14:00:00'),
    (9, 10, 1, -1, '2025-12-21 09:00:00'),
    (10, 10, 4, -1, '2025-12-21 09:30:00'),
    (11, 11, 1, 1, '2025-12-16 11:50:00'),
    (12, 13, 3, 1, '2026-05-21 14:30:00'),
    (13, 1, 8, 1, '2025-12-15 21:17:00'),
    (14, 1, 9, 1, '2025-12-15 22:17:00'),
    (15, 2, 11, 1, '2025-12-18 12:37:00'),
    (16, 2, 12, 1, '2025-12-18 13:37:00'),
    (17, 3, 14, 1, '2026-05-20 10:12:00'),
    (18, 3, 15, 1, '2026-05-20 11:12:00'),
    (19, 4, 17, 1, '2025-12-12 17:52:00'),
    (20, 4, 18, 1, '2025-12-12 18:52:00'),
    (21, 5, 20, 1, '2026-05-22 19:27:00'),
    (22, 5, 5, -1, '2026-05-22 20:27:00'),
    (23, 6, 7, -1, '2025-12-10 14:07:00'),
    (24, 6, 8, 1, '2025-12-10 15:07:00'),
    (25, 7, 10, 1, '2026-05-25 22:47:00'),
    (26, 7, 11, 1, '2026-05-25 23:47:00'),
    (27, 8, 13, 1, '2026-08-10 11:22:00'),
    (28, 8, 14, 1, '2026-08-10 12:22:00'),
    (29, 9, 16, 1, '2026-05-28 16:07:00'),
    (30, 9, 17, 1, '2026-05-28 17:07:00'),
    (31, 10, 19, -1, '2025-12-21 01:02:00'),
    (32, 10, 20, -1, '2025-12-21 02:02:00'),
    (33, 11, 6, 1, '2025-12-16 09:37:00'),
    (34, 12, 9, 1, '2025-12-16 13:07:00'),
    (35, 13, 12, -1, '2026-05-21 11:17:00'),
        (36, 14, 15, 1, '2026-05-21 15:42:00'),
    (37, 15, 18, 1, '2025-12-11 10:07:00'),
    (38, 16, 5, -1, '2025-12-11 20:27:00'),
    (39, 17, 8, 1, '2025-12-21 11:07:00'),
    (40, 18, 11, 1, '2026-08-12 18:52:00'),
    (41, 19, 14, 1, '2026-11-06 17:26:00'),
    (42, 19, 15, 1, '2026-11-06 18:26:00'),
    (43, 20, 17, 1, '2026-05-22 17:27:00'),
    (44, 20, 18, 1, '2026-05-22 18:27:00'),
    (45, 21, 20, 1, '2026-11-08 17:28:00'),
    (46, 21, 5, 1, '2026-11-08 18:28:00'),
    (47, 22, 7, 1, '2026-11-09 17:29:00'),
    (48, 22, 9, 1, '2026-11-09 18:29:00'),
    (49, 23, 10, 1, '2026-11-10 17:30:00'),
    (50, 23, 11, -1, '2026-11-10 18:30:00'),
    (51, 24, 13, -1, '2026-05-18 17:31:00'),
    (52, 24, 14, 1, '2026-05-18 18:31:00'),
    (53, 25, 16, 1, '2026-11-04 17:32:00'),
    (54, 25, 17, 1, '2026-11-04 18:32:00'),
    (55, 26, 19, 1, '2026-11-05 17:33:00'),
    (56, 26, 20, 1, '2026-11-05 18:33:00'),
    (57, 27, 6, 1, '2026-11-06 17:34:00'),
    (58, 27, 7, 1, '2026-11-06 18:34:00'),
    (59, 28, 9, 1, '2025-12-14 17:35:00'),
    (60, 28, 10, 1, '2025-12-14 18:35:00'),
    (61, 29, 12, 1, '2026-05-23 17:36:00'),
    (62, 29, 13, -1, '2026-05-23 18:36:00'),
    (63, 30, 15, -1, '2025-12-16 17:37:00'),
    (64, 30, 17, 1, '2025-12-16 18:37:00'),
    (65, 31, 18, 1, '2026-05-25 17:38:00'),
    (66, 31, 19, 1, '2026-05-25 18:38:00'),
    (67, 32, 5, 1, '2025-12-10 17:39:00'),
    (68, 32, 6, 1, '2025-12-10 18:39:00'),
    (69, 33, 8, 1, '2025-12-11 17:40:00'),
    (70, 33, 9, 1, '2025-12-11 18:40:00'),
    (71, 34, 11, 1, '2026-11-05 17:41:00'),
    (72, 34, 12, 1, '2026-11-05 18:41:00'),
    (73, 35, 14, 1, '2026-05-21 17:42:00'),
    (74, 35, 15, -1, '2026-05-21 18:42:00'),
    (75, 36, 17, -1, '2026-11-07 17:43:00'),
    (76, 36, 18, 1, '2026-11-07 18:43:00'),
    (77, 37, 20, 1, '2026-05-23 17:44:00'),
    (78, 37, 5, 1, '2026-05-23 18:44:00'),
    (79, 38, 7, 1, '2026-11-09 17:45:00'),
    (80, 38, 9, 1, '2026-11-09 18:45:00'),
    (81, 39, 10, 1, '2025-12-17 17:46:00'),
    (82, 39, 11, 1, '2025-12-17 18:46:00'),
    (83, 40, 13, 1, '2026-05-18 17:47:00'),
    (84, 40, 14, 1, '2026-05-18 18:47:00'),
    (85, 41, 16, 1, '2026-11-04 17:48:00'),
    (86, 41, 17, -1, '2026-11-04 18:48:00'),
    (87, 42, 19, -1, '2026-08-06 17:49:00'),
    (88, 42, 20, 1, '2026-08-06 18:49:00'),
    (89, 43, 6, 1, '2026-11-06 17:50:00'),
    (90, 43, 7, 1, '2026-11-06 18:50:00'),
    (91, 44, 9, 1, '2026-11-07 17:51:00'),
    (92, 44, 10, 1, '2026-11-07 18:51:00'),
    (93, 45, 12, 1, '2026-11-08 17:52:00'),
    (94, 45, 13, 1, '2026-11-08 18:52:00'),
    (95, 46, 15, 1, '2026-05-24 17:53:00'),
    (96, 46, 17, 1, '2026-05-24 18:53:00'),
    (97, 47, 18, 1, '2026-11-10 17:54:00'),
    (98, 47, 19, -1, '2026-11-10 18:54:00'),
    (99, 48, 5, -1, '2026-05-18 17:55:00'),
    (100, 48, 6, 1, '2026-05-18 18:55:00'),
    (101, 49, 8, 1, '2025-12-11 17:56:00'),
    (102, 49, 9, 1, '2025-12-11 18:56:00'),
    (103, 50, 11, 1, '2026-05-20 17:57:00'),
    (104, 50, 12, 1, '2026-05-20 18:57:00'),
    (105, 51, 14, 1, '2026-11-06 17:58:00'),
    (106, 51, 15, 1, '2026-11-06 18:58:00'),
    (107, 52, 17, 1, '2026-11-07 17:59:00'),
    (108, 52, 18, 1, '2026-11-07 18:59:00'),
    (109, 53, 20, 1, '2025-12-15 18:00:00'),
    (110, 53, 5, -1, '2025-12-15 19:00:00'),
    (111, 54, 7, -1, '2025-12-16 18:01:00'),
    (112, 54, 9, 1, '2025-12-16 19:01:00'),
    (113, 55, 10, 1, '2026-05-25 18:02:00'),
    (114, 55, 11, 1, '2026-05-25 19:02:00'),
    (115, 56, 13, 1, '2026-11-03 18:03:00'),
    (116, 56, 14, 1, '2026-11-03 19:03:00'),
    (117, 57, 16, 1, '2026-08-09 18:04:00'),
    (118, 57, 17, 1, '2026-08-09 19:04:00'),
    (119, 58, 19, 1, '2026-11-05 18:05:00'),
    (120, 58, 20, 1, '2026-11-05 19:05:00'),
    (121, 59, 6, 1, '2025-12-13 18:06:00'),
    (122, 59, 7, -1, '2025-12-13 19:06:00'),
    (123, 60, 9, -1, '2026-05-22 18:07:00'),
    (124, 60, 10, 1, '2026-05-22 19:07:00'),
    (125, 61, 12, 1, '2026-11-08 18:08:00'),
    (126, 61, 13, 1, '2026-11-08 19:08:00'),
    (127, 62, 15, 1, '2026-08-08 18:09:00'),
    (128, 62, 17, 1, '2026-08-08 19:09:00'),
    (129, 63, 18, 1, '2026-05-25 18:10:00'),
    (130, 63, 19, 1, '2026-05-25 19:10:00'),
    (131, 64, 5, 1, '2026-05-18 18:11:00'),
    (132, 64, 6, 1, '2026-05-18 19:11:00'),
    (133, 65, 8, 1, '2026-11-04 18:12:00'),
    (134, 65, 9, -1, '2026-11-04 19:12:00'),
    (135, 66, 11, -1, '2026-08-06 18:13:00'),
    (136, 66, 12, 1, '2026-08-06 19:13:00'),
    (137, 67, 14, 1, '2026-11-06 18:14:00'),
    (138, 67, 15, 1, '2026-11-06 19:14:00'),
    (139, 68, 17, 1, '2026-05-22 18:15:00'),
    (140, 68, 18, 1, '2026-05-22 19:15:00'),
    (141, 69, 20, 1, '2025-12-15 18:16:00'),
    (142, 69, 5, 1, '2025-12-15 19:16:00'),
    (143, 70, 7, 1, '2026-05-24 18:17:00'),
    (144, 70, 9, 1, '2026-05-24 19:17:00'),
    (145, 71, 10, 1, '2025-12-17 18:18:00'),
    (146, 71, 11, -1, '2025-12-17 19:18:00'),
    (147, 72, 13, -1, '2026-05-18 18:19:00'),
    (148, 72, 14, 1, '2026-05-18 19:19:00'),
    (149, 73, 16, 1, '2026-05-19 18:20:00'),
    (150, 73, 17, 1, '2026-05-19 19:20:00'),
    (151, 74, 19, 1, '2026-11-07 18:26:00'),
    (152, 75, 6, 1, '2026-11-08 18:26:00'),
    (153, 76, 9, 1, '2026-05-19 18:31:00'),
    (154, 77, 12, 1, '2026-05-20 18:31:00'),
    (155, 78, 15, -1, '2026-11-07 18:34:00'),
    (156, 79, 18, 1, '2026-11-08 18:34:00'),
    (157, 80, 5, 1, '2026-05-24 18:36:00'),
    (158, 81, 8, 1, '2026-05-25 18:36:00'),
    (159, 82, 11, 1, '2025-12-12 18:40:00'),
    (160, 83, 14, 1, '2025-12-13 18:40:00'),
    (161, 84, 17, 1, '2026-05-24 18:44:00'),
    (162, 85, 20, 1, '2026-05-25 18:44:00'),
    (163, 86, 7, 1, '2026-11-05 18:48:00'),
    (164, 87, 10, 1, '2026-11-06 18:48:00'),
    (165, 88, 13, 1, '2026-11-09 18:52:00'),
    (166, 89, 16, 1, '2026-11-10 18:52:00'),
    (167, 90, 19, 1, '2026-11-07 18:58:00'),
    (168, 91, 6, -1, '2026-11-08 18:58:00'),
    (169, 92, 9, 1, '2026-08-10 19:04:00'),
    (170, 93, 12, 1, '2026-08-11 19:04:00'),
    (171, 94, 15, 1, '2026-11-09 19:08:00'),
    (172, 95, 18, 1, '2026-11-10 19:08:00'),
    (173, 96, 5, 1, '2025-12-16 19:16:00'),
    (174, 97, 8, 1, '2025-12-17 19:16:00');



INSERT INTO `report` (`report_id`, `reporter_id`, `content_id`, `reason`, `summary`, `created_at`, `resolved_at`) VALUES
    (1, 1, 10, 'spam', 'Selling a textbook, not a review of the class.', '2025-12-21 09:05:00', NULL),
    (2, 2, 10, 'spam', NULL, '2025-12-21 09:35:00', NULL),
    (3, 1, 16, 'off-topic', 'Selling a parking pass, nothing to do with the class.', '2025-12-12 08:00:00', '2025-12-12 15:30:00');



INSERT INTO `submission` (`submission_id`, `user_id`, `submission_type`, `submitted_prof_name`, `submitted_dept`, `submitted_class_code`, `status`, `reject_reason`, `created_at`, `reviewed_at`) VALUES
    (1, 4, 'professor', 'Jordan Ellis', 'CMPS', NULL, 'pending', NULL, '2026-10-20 13:00:00', NULL),
    (2, 3, 'course', NULL, 'MATH', 'MATH 2200', 'approved', NULL, '2026-01-08 10:00:00', '2026-01-09 09:15:00'),
    (3, 2, 'professor', 'Prof. Smith', 'PSYC', NULL, 'rejected', 'Not found in the CSUB faculty directory.', '2026-02-14 18:30:00', '2026-02-16 11:00:00'),
    (4, 1, 'course', NULL, 'CMPS', 'CMPS 4910', 'pending', NULL, '2026-10-22 20:00:00', NULL);



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
