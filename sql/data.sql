-- data.sql  --  CSUB Rate My Professor (database: csubryp)
-- Departments, course numbers and course titles are real, taken from the
-- CSUB course catalog (catalog.csub.edu/course-descriptions). Professors,
-- users, reviews, comments, votes, reports and submissions are fictional.
-- IDs are explicit so foreign keys line up.

INSERT INTO department (dept_id, code, name) VALUES
    (1, 'CMPS', 'Computer Science'),
    (2, 'MATH', 'Mathematics'),
    (3, 'ENGL', 'English'),
    (4, 'PSYC', 'Psychology'),
    (5, 'PHYS', 'Physics');

-- Professors are real CSUB faculty, taken from the public department
-- directories (cs.csub.edu/faculty.php and the Math, English, Psychology
-- and Physics & Engineering faculty pages). Which sections they teach and
-- every review about them below are mock data.
INSERT INTO professor (prof_id, dept_id, first_name, last_name, title) VALUES
    (1, 1, 'Melissa', 'Danforth', 'Professor'),
    (2, 1, 'Nick',    'Toothman', 'Assistant Professor'),
    (3, 1, 'Jay',     'Manibo',   'Lecturer'),
    (4, 2, 'Charles', 'Lam',      'Professor'),
    (5, 2, 'Eduardo', 'Montoya',  'Professor'),
    (6, 3, 'Emerson', 'Case',     'Professor'),
    (7, 4, 'Tyler',   'Ensor',    'Associate Professor'),
    (8, 5, 'Yize',    'Li',       'Professor');

INSERT INTO course (course_id, dept_id, subject, course_number, title) VALUES
    (1,  1, 'CMPS', '2010', 'Programming I: Programming Fundamentals'),
    (2,  1, 'CMPS', '2020', 'Programming II: Data Structures and Algorithms'),
    (3,  1, 'CMPS', '3420', 'Database Systems'),
    (4,  1, 'CMPS', '3600', 'Operating Systems'),
    (5,  2, 'MATH', '2200', 'Introduction to Statistical Concepts and Methods'),
    (6,  2, 'MATH', '2510', 'Single Variable Calculus I'),
    (7,  3, 'ENGL', '1109', 'Writing and Research'),
    (8,  4, 'PSYC', '1018', 'Explorations in Psychology'),
    (9,  5, 'PHYS', '2210', 'Physics for Scientists and Engineers I'),
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

INSERT INTO term (term_id, season, term_year) VALUES
    (1, 'Fall',   2025),
    (2, 'Spring', 2026),
    (3, 'Summer', 2026),
    (4, 'Fall',   2026);

INSERT INTO teaching (teaching_id, prof_id, course_id, term_id, modality) VALUES
    (1,  1, 3,  1, 'In-Person'),   -- Danforth,  CMPS 3420, Fall 2025
    (2,  1, 3,  4, 'In-Person'),   -- Danforth,  CMPS 3420, Fall 2026
    (3,  2, 4,  2, 'Hybrid'),      -- Toothman,  CMPS 3600, Spring 2026
    (4,  3, 1,  1, 'In-Person'),   -- Manibo,    CMPS 2010, Fall 2025
    (5,  3, 2,  2, 'In-Person'),   -- Manibo,    CMPS 2020, Spring 2026
    (6,  4, 6,  1, 'In-Person'),   -- Lam,       MATH 2510, Fall 2025
    (7,  5, 5,  2, 'Online'),      -- Montoya,   MATH 2200, Spring 2026
    (8,  6, 7,  1, 'In-Person'),   -- Case,      ENGL 1109, Fall 2025
    (9,  7, 8,  3, 'Online'),      -- Ensor,     PSYC 1018, Summer 2026
    (10, 8, 9,  2, 'In-Person'),   -- Li,        PHYS 2210, Spring 2026
    (11, 2, 10, 4, 'In-Person'),   -- Toothman,  CMPS 3120, Fall 2026
    (12, 3, 1,  4, 'Hybrid'),      -- Manibo,    CMPS 2010, Fall 2026
    (13, 1, 11, 2, 'In-Person'),   -- Danforth,  CMPS 2120, Spring 2026
    (14, 2, 12, 4, 'In-Person'),   -- Toothman,  CMPS 3140, Fall 2026
    (15, 3, 14, 4, 'In-Person'),   -- Manibo,    CMPS 3500, Fall 2026
    (16, 4, 16, 2, 'In-Person'),   -- Lam,       MATH 2520, Spring 2026
    (17, 7, 19, 4, 'Hybrid'),      -- Ensor,     PSYC 2018, Fall 2026
    (18, 8, 20, 4, 'In-Person');   -- Li,        PHYS 2220, Fall 2026

-- The four users are the group members. Emails and usernames follow the
-- CSUB first-initial + last-name pattern; password_hash values are
-- bcrypt-format placeholders, not real hashes.
INSERT INTO users (user_id, email, username, password_hash, class_year,
                   user_type, user_status, created_at, last_login) VALUES
    (1, 'aestrada@csub.edu',    'aestrada',    '$2y$10$placeholderhashplaceholderhashplaceholderhash01', NULL,     'user',  'active', '2025-08-20 14:12:00', '2026-10-24 21:05:00'),
    (2, 'dvillanueva@csub.edu', 'dvillanueva', '$2y$10$placeholderhashplaceholderhashplaceholderhash02', 'Senior', 'admin', 'active', '2025-08-15 09:00:00', '2026-10-26 07:50:00'),
    (3, 'mnuno@csub.edu',       'mnuno',       '$2y$10$placeholderhashplaceholderhashplaceholderhash03', NULL,     'user',  'active', '2025-08-22 10:40:00', '2026-10-23 08:15:00'),
    (4, 'gcarrillo@csub.edu',   'gcarrillo',   '$2y$10$placeholderhashplaceholderhashplaceholderhash04', NULL,     'user',  'active', '2025-09-01 16:00:00', '2026-10-20 12:00:00');

-- Content 1-10 are reviews, 11-18 are comments.
INSERT INTO content (content_id, user_id, content_type, body, created_at, status) VALUES
    (1,  1, 'review',  'Lectures are organized and the ER modeling project really helped. Exams are hard but fair.', '2025-12-15 20:10:00', 'visible'),
    (2,  2, 'review',  'Great class if you keep up with the labs. Office hours were very helpful.',                 '2025-12-18 11:30:00', 'visible'),
    (3,  3, 'review',  'Interesting material. Exams are challenging, so review the readings too.',                '2026-05-20 09:05:00', 'visible'),
    (4,  4, 'review',  'Perfect first programming class. Explains everything slowly and clearly.',                 '2025-12-12 16:45:00', 'visible'),
    (5,  1, 'review',  'Lots of weekly homework, but it prepares you well for the projects.',                      '2026-05-22 18:20:00', 'visible'),
    (6,  2, 'review',  'Very fast paced and quizzes every week. Go to tutoring early.',                            '2025-12-10 13:00:00', 'visible'),
    (7,  3, 'review',  'Online format works well. Responds to email quickly.',                                     '2026-05-25 21:40:00', 'visible'),
    (8,  4, 'review',  'Easy to follow and genuinely cares whether students understand.',                         '2026-08-10 10:15:00', 'visible'),
    (9,  1, 'review',  'Lab reports take a long time but lectures are clear.',                                     '2026-05-28 15:00:00', 'visible'),
    (10, 3, 'review',  'Selling my used textbook for this class, message me if interested.',                      '2025-12-20 23:55:00', 'hidden'),
    (11, 3, 'comment', 'Agreed, the project made normalization click for me.',                                     '2025-12-16 08:30:00', 'visible'),
    (12, 1, 'comment', 'Same. Start the project early though.',                                                    '2025-12-16 12:00:00', 'visible'),
    (13, 4, 'comment', 'Did the final cover scheduling algorithms?',                                               '2026-05-21 10:10:00', 'visible'),
    (14, 3, 'comment', 'Yes, mostly round robin and priority scheduling.',                                         '2026-05-21 14:35:00', 'visible'),
    (15, 1, 'comment', 'Tutoring center on the second floor helped me a lot.',                                     '2025-12-11 09:00:00', 'visible'),
    (16, 4, 'comment', 'Anyone selling a used parking pass?',                                                      '2025-12-11 19:20:00', 'removed'),
    (17, 2, 'comment', 'This review does not say anything about the actual class.',                                '2025-12-21 10:00:00', 'visible'),
    (18, 2, 'comment', 'Taking this online next summer, thanks for the review.',                                   '2026-08-12 17:45:00', 'visible');

INSERT INTO review (review_id, teaching_id, rating, difficulty, grade,
                    attendance, textbook, would_retake) VALUES
    (1,  1,  5, 4, 'A-', TRUE,  FALSE, TRUE),
    (2,  1,  4, 4, 'B+', TRUE,  FALSE, TRUE),
    (3,  3,  4, 5, 'B',  FALSE, TRUE,  TRUE),
    (4,  4,  5, 2, 'A',  TRUE,  FALSE, TRUE),
    (5,  5,  4, 3, 'A-', TRUE,  FALSE, TRUE),
    (6,  6,  4, 5, 'C+', TRUE,  TRUE,  TRUE),
    (7,  7,  4, 3, 'B+', FALSE, FALSE, TRUE),
    (8,  9,  5, 1, 'A',  FALSE, TRUE,  TRUE),
    (9,  10, 3, 4, 'B-', TRUE,  TRUE,  TRUE),
    (10, 8,  3, 3, NULL, NULL,  TRUE,  TRUE);

INSERT INTO comment (comment_id, review_id, parent_comment_id) VALUES
    (11, 1,  NULL),
    (12, 1,  11),
    (13, 3,  NULL),
    (14, 3,  13),
    (15, 6,  NULL),
    (16, 6,  15),
    (17, 10, NULL),
    (18, 8,  NULL);

INSERT INTO tag (tag_id, label) VALUES
    (1,  'Tough grader'),
    (2,  'Clear lectures'),
    (3,  'Lots of homework'),
    (4,  'Group projects'),
    (5,  'Test heavy'),
    (6,  'Caring'),
    (7,  'Inspirational'),
    (8,  'Extra credit'),
    (9,  'Lecture heavy'),
    (10, 'Accessible outside class');

INSERT INTO review_tag (review_id, tag_id) VALUES
    (1, 2), (1, 4), (2, 2), (2, 10), (3, 9), (3, 5),
    (4, 2), (4, 6), (5, 3), (6, 3),  (6, 5), (7, 10),
    (8, 6), (8, 7), (9, 9);

INSERT INTO vote (vote_id, content_id, user_id, value, created_at) VALUES
    (1,  1,  2,  1, '2025-12-16 08:25:00'),
    (2,  1,  3,  1, '2025-12-17 12:00:00'),
    (3,  1,  4,  1, '2026-01-05 09:30:00'),
    (4,  2,  1,  1, '2025-12-19 10:00:00'),
    (5,  3,  1, -1, '2026-05-21 11:00:00'),
    (6,  3,  4,  1, '2026-05-21 10:05:00'),
    (7,  6,  3,  1, '2025-12-11 08:00:00'),
    (8,  6,  4, -1, '2026-01-15 14:00:00'),
    (9,  10, 1, -1, '2025-12-21 09:00:00'),
    (10, 10, 4, -1, '2025-12-21 09:30:00'),
    (11, 11, 1,  1, '2025-12-16 11:50:00'),
    (12, 13, 3,  1, '2026-05-21 14:30:00');

INSERT INTO report (report_id, reporter_id, content_id, reason, summary,
                    created_at, resolved_at) VALUES
    (1, 1, 10, 'spam',            'Selling a textbook, not a review of the class.',          '2025-12-21 09:05:00', NULL),
    (2, 2, 10, 'spam',            NULL,                                                       '2025-12-21 09:35:00', NULL),
    (3, 1, 16, 'off-topic',       'Selling a parking pass, nothing to do with the class.',  '2025-12-12 08:00:00', '2025-12-12 15:30:00');

INSERT INTO submission (submission_id, user_id, submission_type, submitted_prof_name,
                        submitted_dept, submitted_class_code, status, reject_reason,
                        created_at, reviewed_at) VALUES
    (1, 4, 'professor', 'Jordan Ellis', 'CMPS', NULL,        'pending',  NULL,                                    '2026-10-20 13:00:00', NULL),
    (2, 3, 'course',    NULL,           'MATH', 'MATH 2200', 'approved', NULL,                                    '2026-01-08 10:00:00', '2026-01-09 09:15:00'),
    (3, 2, 'professor', 'Prof. Smith',  'PSYC', NULL,        'rejected', 'Not found in the CSUB faculty directory.', '2026-02-14 18:30:00', '2026-02-16 11:00:00'),
    (4, 1, 'course',    NULL,           'CMPS', 'CMPS 4910', 'pending',  NULL,                                    '2026-10-22 20:00:00', NULL);
