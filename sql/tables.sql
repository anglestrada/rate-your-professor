-- CSUB Rate Your Professor for 'csubryp' database
-- This sql file drops and recreates every table

DROP TABLE IF EXISTS department;
DROP TABLE IF EXISTS professor;
DROP TABLE IF EXISTS course;
DROP TABLE IF EXISTS term;
DROP TABLE IF EXISTS teaching;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS content;
DROP TABLE IF EXISTS review;
DROP TABLE IF EXISTS comment;
DROP TABLE IF EXISTS vote;
DROP TABLE IF EXISTS tag;
DROP TABLE IF EXISTS review_tag;
DROP TABLE IF EXISTS report;
DROP TABLE IF EXISTS submission;


-- THE CATALOG: departement, professors, course, term, teaching

CREATE TABLE department (
	dept_id   INT UNSIGNED   NOT NULL   AUTO_INCREMENT,
	code      VARCHAR(15)    NOT NULL,
	name      VARCHAR(100)   NOT NULL,
	PRIMARY KEY (dept_id),
-- UNIQUE KEY ON 'code' to enforce NO DUPLICATES
	UNIQUE KEY uq_department_code(code)
-- utf8mb4 allows for full Unicode text like(Muñoz, José)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE professor (
    prof_id     INT UNSIGNED  NOT NULL AUTO_INCREMENT,
    dept_id     INT UNSIGNED  NOT NULL,
    first_name  VARCHAR(50)   NOT NULL,
    last_name   VARCHAR(50)   NOT NULL,
    title       VARCHAR(50)   NULL,
    PRIMARY KEY (prof_id),
    CONSTRAINT fk_professor_dept FOREIGN KEY (dept_id)
        REFERENCES department (dept_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
 
CREATE TABLE course (
    course_id      INT UNSIGNED  NOT NULL AUTO_INCREMENT,
    dept_id        INT UNSIGNED  NOT NULL,
    subject        VARCHAR(10)   NOT NULL,
    course_number  VARCHAR(10)   NOT NULL,
    title          VARCHAR(150)  NOT NULL,
    PRIMARY KEY (course_id),
    UNIQUE KEY uq_course_code (subject, course_number),
    CONSTRAINT fk_course_dept FOREIGN KEY (dept_id)
        REFERENCES department (dept_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
 
CREATE TABLE term (
    term_id    INT UNSIGNED  NOT NULL AUTO_INCREMENT,
    season     ENUM('Spring','Summer','Fall','Winter') NOT NULL,
    term_year  SMALLINT UNSIGNED NOT NULL,
    PRIMARY KEY (term_id),
    UNIQUE KEY uq_term (season, term_year),
    CONSTRAINT chk_term_year CHECK (term_year BETWEEN 1970 AND 2100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
 
CREATE TABLE teaching (
    teaching_id  INT UNSIGNED  NOT NULL AUTO_INCREMENT,
    prof_id      INT UNSIGNED  NOT NULL,
    course_id    INT UNSIGNED  NOT NULL,
    term_id      INT UNSIGNED  NOT NULL,
    modality     ENUM('In-Person','Online','Hybrid') NOT NULL DEFAULT 'In-Person',
    PRIMARY KEY (teaching_id),
    UNIQUE KEY uq_teaching (prof_id, course_id, term_id),
    CONSTRAINT fk_teaching_prof   FOREIGN KEY (prof_id)   REFERENCES professor (prof_id),
    CONSTRAINT fk_teaching_course FOREIGN KEY (course_id) REFERENCES course (course_id),
    CONSTRAINT fk_teaching_term   FOREIGN KEY (term_id)   REFERENCES term (term_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
 
-- ACCOUNTS
CREATE TABLE users (
    user_id        INT UNSIGNED  NOT NULL AUTO_INCREMENT,
    email          VARCHAR(255)  NOT NULL,
    username       VARCHAR(30)   NOT NULL,
    password_hash  VARCHAR(255)  NOT NULL,   -- PHP password_hash() output
    class_year     ENUM('Freshman','Sophomore','Junior','Senior','Graduate') NULL,
    user_type      ENUM('user','admin') NOT NULL DEFAULT 'user',
    user_status    ENUM('active','suspended','banned') NOT NULL DEFAULT 'active',
    created_at     DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_login     DATETIME      NULL,
    PRIMARY KEY (user_id),
    UNIQUE KEY uq_users_email (email),
    UNIQUE KEY uq_users_username (username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
 
-- =========================================================
-- Content supertype (option 8a in our document) and its Review / Comment subtypes
-- ========================================================

CREATE TABLE content (
    content_id    INT UNSIGNED  NOT NULL AUTO_INCREMENT,
    user_id       INT UNSIGNED  NOT NULL,
    content_type  ENUM('review','comment') NOT NULL,
    body          TEXT          NOT NULL,
    created_at    DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status        ENUM('visible','hidden','removed') NOT NULL DEFAULT 'visible',
    PRIMARY KEY (content_id),
    CONSTRAINT fk_content_user FOREIGN KEY (user_id) REFERENCES users (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
 
CREATE TABLE review (
    review_id     INT UNSIGNED  NOT NULL,
    teaching_id   INT UNSIGNED  NOT NULL,
    rating        TINYINT UNSIGNED NOT NULL,
    difficulty    TINYINT UNSIGNED NOT NULL,
    grade         ENUM('A+','A','A-','B+','B','B-','C+','C','C-',
                       'D+','D','D-','F','CR','NC','W','IP') NULL,
    attendance    BOOLEAN NULL,     -- was attendance required?
    textbook      BOOLEAN NULL,     -- was a textbook required?
    would_retake  BOOLEAN NOT NULL,
    PRIMARY KEY (review_id),
    CONSTRAINT fk_review_content  FOREIGN KEY (review_id)
        REFERENCES content (content_id) ON DELETE CASCADE,
    CONSTRAINT fk_review_teaching FOREIGN KEY (teaching_id)
        REFERENCES teaching (teaching_id),
    CONSTRAINT chk_review_rating     CHECK (rating BETWEEN 1 AND 5),
    CONSTRAINT chk_review_difficulty CHECK (difficulty BETWEEN 1 AND 5)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
 
CREATE TABLE comment (
    comment_id         INT UNSIGNED NOT NULL,
    review_id          INT UNSIGNED NOT NULL,
    parent_comment_id  INT UNSIGNED NULL,     -- NULL = top-level reply
    PRIMARY KEY (comment_id),
    CONSTRAINT fk_comment_content FOREIGN KEY (comment_id)
        REFERENCES content (content_id) ON DELETE CASCADE,
    CONSTRAINT fk_comment_review  FOREIGN KEY (review_id)
        REFERENCES review (review_id) ON DELETE CASCADE,
    CONSTRAINT fk_comment_parent  FOREIGN KEY (parent_comment_id)
        REFERENCES comment (comment_id) ON DELETE CASCADE,
    CONSTRAINT chk_comment_not_self CHECK (parent_comment_id IS NULL
                                           OR parent_comment_id <> comment_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
 
-- ---------------------------------------------------------------------
-- Interaction with content: vote, tag, review_tag, report
-- ---------------------------------------------------------------------
CREATE TABLE vote (
    vote_id     INT UNSIGNED NOT NULL AUTO_INCREMENT,
    content_id  INT UNSIGNED NOT NULL,
    user_id     INT UNSIGNED NOT NULL,
    value       TINYINT      NOT NULL,
    created_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (vote_id),
    UNIQUE KEY uq_vote_once (content_id, user_id),
    CONSTRAINT fk_vote_content FOREIGN KEY (content_id)
        REFERENCES content (content_id) ON DELETE CASCADE,
    CONSTRAINT fk_vote_user    FOREIGN KEY (user_id)
        REFERENCES users (user_id),
    CONSTRAINT chk_vote_value CHECK (value IN (-1, 1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
 
CREATE TABLE tag (
    tag_id  INT UNSIGNED NOT NULL AUTO_INCREMENT,
    label   VARCHAR(40)  NOT NULL,
    PRIMARY KEY (tag_id),
    UNIQUE KEY uq_tag_label (label)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
 
CREATE TABLE review_tag (
    review_id  INT UNSIGNED NOT NULL,
    tag_id     INT UNSIGNED NOT NULL,
    PRIMARY KEY (review_id, tag_id),
    CONSTRAINT fk_review_tag_review FOREIGN KEY (review_id)
        REFERENCES review (review_id) ON DELETE CASCADE,
    CONSTRAINT fk_review_tag_tag    FOREIGN KEY (tag_id)
        REFERENCES tag (tag_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
 
CREATE TABLE report (
    report_id    INT UNSIGNED NOT NULL AUTO_INCREMENT,
    reporter_id  INT UNSIGNED NOT NULL,
    content_id   INT UNSIGNED NOT NULL,
    reason       ENUM('spam','harassment','personal attack','off-topic',
                      'false information','other') NOT NULL,
    summary      VARCHAR(500) NULL,
    created_at   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    resolved_at  DATETIME     NULL,           -- NULL = report still open
    PRIMARY KEY (report_id),
    CONSTRAINT fk_report_reporter FOREIGN KEY (reporter_id)
        REFERENCES users (user_id),
    CONSTRAINT fk_report_content  FOREIGN KEY (content_id)
        REFERENCES content (content_id) ON DELETE CASCADE,
    CONSTRAINT chk_report_resolved CHECK (resolved_at IS NULL
                                          OR resolved_at >= created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
 

-- ==========================
-- Requests to add a professor or course
-- ===============================
CREATE TABLE submission (
    submission_id         INT UNSIGNED NOT NULL AUTO_INCREMENT,
    user_id               INT UNSIGNED NOT NULL,
    submission_type       ENUM('professor','course') NOT NULL,
    submitted_prof_name   VARCHAR(100) NULL,
    submitted_dept        VARCHAR(10)  NULL,
    submitted_class_code  VARCHAR(20)  NULL,
    status                ENUM('pending','approved','rejected') NOT NULL DEFAULT 'pending',
    reject_reason         VARCHAR(255) NULL,
    created_at            DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    reviewed_at           DATETIME     NULL,
    PRIMARY KEY (submission_id),
    CONSTRAINT fk_submission_user FOREIGN KEY (user_id) REFERENCES users (user_id),
    CONSTRAINT chk_submission_fields CHECK (
        (submission_type = 'professor' AND submitted_prof_name  IS NOT NULL) OR
        (submission_type = 'course'    AND submitted_class_code IS NOT NULL)),
    CONSTRAINT chk_submission_reject CHECK (
        status <> 'rejected' OR reject_reason IS NOT NULL),
    CONSTRAINT chk_submission_reviewed CHECK (
        status = 'pending' OR reviewed_at IS NOT NULL)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



