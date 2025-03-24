use helloworldlabs_lms;

-- INNER JOIN : 두가지 테이블에서 둘다 존재하는 값, 교집합만 보여주겠다.
SELECT
	u.username,
	r.role_name
FROM
	users u
INNER JOIN
	roles r ON u.role_id = r.role_id;


-- LEFT JOIN : 모든 사용자와 강좌를 조회
SELECT
	u.username,
	u.role_id,
	c.instructor_id
FROM users u
LEFT JOIN courses c on u.user_id = c.instructor_id
WHERE c.instructor_id IS NULL;

-- RIGHT JOIN
SELECT
	u.username,
	c.instructor_id
FROM users u
RIGHT JOIN courses c ON u.user_id = c.instructor_id;

-- 미션 1 : courses 테이블로 SQL 기본 문법 연습
-- 강사 권한 id 찾는다.
SELECT * FROM roles; -- 강사권한 2번

-- users에 신규 강사 추가한다.
SELECT * FROM users;

INSERT INTO
	users(username, email, password_hash, role_id)
VALUES
	("신규강사", "new_teacher@gmail.com", "hash1111", 2);

SELECT * FROM users WHERE username = "신규강사";

-- courses에 추가된 강사가 진행하는 2개 강좌를 추가.
SELECT * FROM courses;

INSERT INTO
	courses(title, description, instructor_id, price)
VALUES
	("수정_신규강사_강의1", "신규강사의 강의1입니다", 10003, 30.50),
	("수정_신규강사_강의2", "신규강사의 강의2입니다", 10003, 32.60);

SELECT * FROM courses WHERE instructor_id = 10003;

-- 미션 2 : courses와 users를 INNER JOIN 으로 연결
-- 조건 : 강사 이름과 강좌 제목 조회
-- 결과 : 강사가 개설한 강좌만 표시
-- 힌트 : instructor_id와 user_id 연결
SELECT
	u.username,
	c.title
FROM
	users u
INNER JOIN
	courses c ON u.user_id = c.instructor_id;

-- 미션 3: users와 enrollments를 INNER JOIN으로 연결
-- 조건 : 학생 이름과 수강 신청 날짜 조회
-- 결과 : 수강 신청한 학생만 표시
-- 힌트 : user_id로 연결
SELECT * FROM enrollments;

SELECT 
	u.username,
	e.enrolled_at
FROM
	users u
INNER JOIN
	enrollments e ON u.user_id = e.user_id;

-- 미션 4: lesson와 courses를 INNER JOIN으로 연결
-- 조건 : 강의 제목과 강좌 제목 조회
-- 결과 : 강좌에 속한 강의만 표시
-- 힌트 : course_id로 연결
SELECT * FROM lessons;
SELECT * FROM courses;

SELECT
	c.title,
	l.title
FROM 
	courses c
INNER JOIN
	lessons l ON c.course_id = l.course_id;

-- 미션 5: quizzes 와 courses를 INNER JOIN으로 연결
-- 조건 : 퀴즈 제목과 강좌 제목 조회
-- 결과 : 강좌에 속한 퀴즈만 표시
-- 힌트 : course_id로 연결
SELECT * FROM quizzes;

SELECT
	q.title,
	c.title
FROM
	quizzes q
INNER JOIN
	courses c ON q.course_id = c.course_id;

-- 미션 6: payments와 users를 INNER JOIN으로 연결
-- 조건 : 결제한 학생 이름과 결제 금액 조회
-- 결과 : 결제 기록 있는 사용자만 표시
-- 힌트 : user_id로 연결
SELECT * FROM payments;
SELECT * FROM users;

SELECT
	u.username,
	p.amount
FROM
	users u
INNER JOIN
	payments p ON p.user_id = u.user_id;

-- 미션 7: grades와 courses를 INNER JOIN으로 연결
-- 조건 : 강좌 제목과 최종 점수 조회
-- 결과 : 성적 기록 있는 강좌만 표시
-- 힌트 : course_id로 연결
SELECT * FROM grades;
SELECT * FROM courses;

SELECT
	c.title,
	g.final_score
FROM
	grades g
INNER JOIN
	courses c ON c.course_id = g.course_id;

-- 미션 8: enrollments와 courses를 LEFT JOIN으로 연결***다시 봐야함
-- 조건: 모든 수강 신청과 강좌 제목 조회(강좌 없는 경우 포함)
-- 결과 : course_id 없는 경우 null 표시
-- 힌트: enrollment_id와 course_id 연결
SELECT * FROM enrollments;
SELECT * FROM courses;

SELECT 
    c.course_id,
    c.title AS course_title, 
    e.enrollment_id
FROM courses c
LEFT JOIN 
	enrollments e ON c.course_id = e.course_id;


-- 미션 9: users와 enrollments를 LEFT JOIN으로 연결
-- 조건 : 모든 사용자와 수강 신청 날짜 조회
-- 결과: 수강 신청 없는 사용자 포함 (NULL)
-- 힌트: user_id로 연결
SELECT
	u.username,
	e.enrolled_at
FROM
	users u
LEFT JOIN
	enrollments e ON u.user_id = e.user_id;

-- 미션 10: courses와 lessons를 RIGHT JOIN으로 연결
-- 조건: 모든 강의와 강좌 제목 조회.
-- 결과: 강좌 없는 강의 포함 (NULL).
-- 힌트: course_id로 연결
SELECT * FROM lessons; -- 강의
SELECT * FROM courses; -- 강좌

SELECT
	c.title,
	l.title
FROM
	courses c
RIGHT JOIN
	lessons l ON c.course_id = l.course_id;


-- 미션11: users와 payments를 LEFT JOIN으로 연결.
-- 조건: 모든 사용자와 결제 금액 조회.
-- 결과: 결제 없는 사용자 포함 (NULL).
-- 힌트: user_id로 연결.
SELECT * FROM payments;
SELECT * FROM users;

SELECT
	u.username,
	p.amount
FROM
	users u 
LEFT JOIN
	payments p ON u.user_id = p.user_id;


-- 미션12: quizzes와 quiz_attempts를 RIGHT JOIN으로 연결.
-- 조건: 모든 퀴즈 시도와 퀴즈 제목 조회.
-- 결과: 시도 없는 퀴즈 포함 (NULL).
-- 힌트: quiz_id로 연결.
SELECT * FROM quizzes;
SELECT * FROM quiz_attempts;

SELECT 
	qa.attempt_id,
	q.quiz_id,
	q.title
FROM
	quiz_attempts qa
RIGHT JOIN
	quizzes q ON qa.quiz_id = q.quiz_id;


-- 미션13: courses와 enrollments를 LEFT JOIN으로 연결.
-- 조건: 모든 강좌와 수강 신청 상태 조회.
-- 결과: 수강 신청 없는 강좌 포함 (NULL).
-- 힌트: course_id로 연결.
SELECT * FROM courses;
SELECT * FROM enrollments;

SELECT
	c.course_id,
	c.title,
	e.enrollment_id
FROM
	courses c
LEFT JOIN
	enrollments e ON c.course_id = e.course_id;

