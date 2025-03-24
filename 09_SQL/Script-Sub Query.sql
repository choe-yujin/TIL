use helloworldlabs_lms;

-- 수강 신청한 학생 조회(in 활용)
SELECT
	username
FROM
	users
WHERE user_id IN(
	SELECT user_id FROM enrollments
);


-- 수강 신청하지 않은 학생 조회(not in 활용)
SELECT
	username
FROM
	users
WHERE user_id NOT IN (
	SELECT user_id FROM enrollments
);

-- 수강 신청한 학생이 있는지 확인(exists 활용)
SELECT
	username
FROM
	users
WHERE EXISTS (
	SELECT user_id FROM enrollments
);

-- select절에 sub query
-- 학생별 결제 내역과 강좌 평균 가격 조회
SELECT
	u.username,
	p.amount,
	(SELECT 
		AVG(p2.amount)
		FROM payments p2
		WHERE p2.course_id = p.course_id
	) AS avg_course_payment
FROM 
	users u
INNER JOIN
	payments p ON u.user_id = p.user_id;

-- from 절에서 서브쿼리 사용
SELECT
	sub.course_id,
	sub.avg_amount
FROM (
	SELECT
		course_id,
		avg(amount) AS avg_amount
	FROM 
		payments
	GROUP BY
		course_id
) AS sub
WHERE sub.avg_amount > 100;


-- ----------------------------------------------
-- WHERE 미션
-- 1 결제한 학생 목록 조회(IN 활용)
SELECT
	username
FROM 
	users
WHERE user_id IN(
	SELECT user_id 
	FROM payments p
	WHERE p.payment_status = 'completed'
);

-- 2 퀴즈에 응시하지 않은 학생 목록 조회
SELECT 
	username
FROM 
	users
WHERE user_id NOT IN (
    SELECT user_id 
    FROM quiz_attempts
    WHERE user_id IS NOT NULL
);


-- 3 과제가 있는 강의 목록 조회
SELECT * FROM lessons;
SELECT * FROM assignments;

SELECT 
	title
FROM 
	lessons l
WHERE EXISTS (
    SELECT 1 -- 단순히 T/F 여부만 판단하여 불필요한 데이터 로드X
    FROM assignments a 
    WHERE a.lesson_id = l.lesson_id
);


-- SELECT 미션
-- 1 퀴즈 점수와 퀴즈별 평균 점수 비교
SELECT * FROM quiz_attempts;

SELECT
    qa.user_id,
    qa.quiz_id,
    qa.score,
    (SELECT AVG(qa2.score) 
     FROM quiz_attempts qa2 
     WHERE qa2.quiz_id = qa.quiz_id) AS avg_quiz_score
FROM 
    quiz_attempts qa
ORDER BY quiz_id, score;

-- 2 결제 금액과 해당 강좌의 수강생 수 출력
SELECT * FROM payments;

SELECT sum(amount) AS amount, count(user_id) AS cnt_user
FROM payments 
WHERE payment_status = 'completed'
GROUP BY course_id
ORDER BY cnt_user DESC, amount DESC 
;

-- 3 학생별 평균 결제 금액 조회
SELECT user_id, avg(amount) AS amount
FROM payments
WHERE payment_status = 'completed'
GROUP BY user_id;

-- ------------------------------------------
-- FROM 미션
-- 1 평균 점수보다 높은 퀴즈 조회
SELECT * FROM quiz_attempts;
SELECT * FROM quizzes;

SELECT qa.score, qa.quiz_id, qa.attempt_id, q.title
FROM quizzes q
JOIN quiz_attempts qa ON q.quiz_id = qa.quiz_id;
GROUP BY qa.quiz_id;

SELECT sub.score, sub.attempt_id
FROM (
    SELECT qa.score, qa.quiz_id, qa.attempt_id, q.title, AVG(qa.score) OVER(PARTITION BY q.quiz_id) AS avg_score
    FROM quizzes q
    JOIN quiz_attempts qa ON q.quiz_id = qa.quiz_id
) AS sub
WHERE sub.score >= sub.avg_score;


-- 2 결제 총액 평균보다 큰 강좌 조회
SELECT avg(amount) FROM payments WHERE payment_status = 'completed'; -- 결제 총액 평균

-- 강좌별 평균 결제 금액
SELECT course_id, avg(amount) AS avg_amount
FROM payments
GROUP BY course_id
HAVING avg_amount >= (SELECT avg(amount) FROM payments WHERE payment_status = 'completed');


-- 3 평균 과제 수보다 많은 강의 조회
SELECT * FROM assignments ORDER BY lesson_id;

-- 강의 별 과제 수
SELECT 
	count(a.assignment_id), 
	l.lesson_id 
FROM assignments a
LEFT JOIN lessons l ON l.lesson_id = a.lesson_id
GROUP BY l.lesson_id;

-- 강의 별 과제 수(과제수 0인 강의도 포함)
SELECT 
	l.lesson_id,
	count(a.assignment_id)
FROM lessons l
LEFT JOIN assignments a ON l.lesson_id = a.lesson_id
GROUP BY l.lesson_id;

-- 평균 과제수(null 제외, 1.3251)
SELECT
	avg(sub.cnt) AS avg_subcnt
FROM (
	SELECT count(assignment_id) AS cnt, lesson_id AS l_id 
	FROM assignments 
	GROUP BY lesson_id
) AS sub;

-- 평균 과제수(null도 포함, 0.4018)
SELECT
	avg(sub.cnt) AS avg_subcnt
FROM (
	SELECT 
		l.lesson_id,
		count(a.assignment_id) AS cnt
	FROM lessons l
	LEFT JOIN assignments a ON l.lesson_id = a.lesson_id
	GROUP BY l.lesson_id
) AS sub;

-- 평균 과제 수보다 많은 강의 조회
SELECT 
	l.lesson_id,
	count(a.assignment_id) AS cnt
FROM lessons l
LEFT JOIN assignments a ON l.lesson_id = a.lesson_id
GROUP BY l.lesson_id
HAVING cnt > (SELECT
	avg(sub.cnt) AS avg_subcnt
FROM (
	SELECT 
		l.lesson_id,
		count(a.assignment_id) AS cnt
	FROM lessons l
	LEFT JOIN assignments a ON l.lesson_id = a.lesson_id
	GROUP BY l.lesson_id
) AS sub);