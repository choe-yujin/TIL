CREATE VIEW enrolled_students AS
SELECT
    u.user_id,
    u.username,
    u.email,
    e.course_id,
    c.title AS course_title
FROM users u
INNER JOIN enrollments e ON u.user_id = e.user_id
INNER JOIN courses c ON e.course_id = c.course_id;

ALTER VIEW enrolled_students AS
SELECT
    u.user_id,
    u.username,
    u.email,
    c.course_id,
    c.title AS course_title,
    e.enrolled_at
FROM users u
INNER JOIN enrollments e ON u.user_id = e.user_id
INNER JOIN courses c ON e.course_id = c.course_id;

-- view 조회하기
SELECT 
    *
FROM enrolled_students;

-- view 삭제
DROP VIEW ENROLLED_STUDENTS;

-- -------------------------------------------
-- View 활용 미션

-- 1. 퀴즈 응시자의 평균 점수보다 높은 학생만 표시하는 뷰 생성

SELECT * FROM quiz_attempts;
-- 1-1.퀴즈 응시자의 평균점수(50.045795)
SELECT avg(score) FROM quiz_attempts;

-- 1-2.퀴즈 응시자의 평균 점수보다 높은 학생
SELECT u.username, qa.score
FROM users u
JOIN quiz_attempts qa ON u.user_id = qa.user_id
WHERE qa.score > (SELECT avg(score) FROM quiz_attempts);

-- 1-3.퀴즈 응시자의 평균 점수보다 높은 학생만 표시하는 뷰 생성
CREATE VIEW quiz_score_students AS
SELECT u.username, qa.score
FROM users u
JOIN quiz_attempts qa ON u.user_id = qa.user_id
WHERE qa.score > (SELECT avg(score) FROM quiz_attempts);

-- 1-4.퀴즈 응시자의 평균 점수보다 높은 학생만 표시하는 뷰 보기
SELECT * FROM quiz_score_students;


-- 2. 특정 강좌의 결제 내역만 필터링하는 뷰 생성 (강좌 ID 3번에 해당하는 결제 내역)
SELECT * FROM payments;

-- 2-1.강좌 ID 3번의 결제 완료된 내역만 필터링하기
SELECT *
FROM payments
WHERE course_id = 3 AND payment_status='completed';

-- 2-2.특정 강좌의 결제 내역만 필터링하는 뷰 생성 (강좌 ID 3번에 해당하는 결제 내역)
CREATE VIEW payment_course3 AS 
SELECT *
FROM payments
WHERE course_id = 3 AND payment_status='completed';

-- 2-3. 3번 강좌의 결제 내역만 필터링하는 뷰 조회
SELECT * FROM payment_course3;


-- -----------------------------------------------
-- 윈도우 함수
-- 각 강좌에서 상위 3명의 학생을 'RANK()'를 이용해 조회하세요.
SELECT * FROM quiz_attempts;
SELECT * FROM courses;
SELECT * FROM quizzes ORDER BY course_id;

-- 1-1.각 강좌에 할당된 퀴즈들
SELECT c.course_id, q.quiz_id
FROM courses c
JOIN quizzes q ON c.course_id = q.course_id
ORDER BY c.course_id;

-- 1-2.각 강좌에 할당된 퀴즈의 점수들과 순위
SELECT 
	c.course_id, 
	q.quiz_id, 
	qa.score, 
	qa.user_id, 
	RANK() OVER (PARTITION BY c.course_id ORDER BY qa.score DESC) AS score_rank
FROM courses c
JOIN quizzes q ON c.course_id = q.course_id
JOIN quiz_attempts qa ON q.quiz_id = qa.quiz_id
ORDER BY c.course_id, qa.quiz_id, qa.score DESC;

-- 1-3.각 강좌에서 상위 3명의 학생만 출력(퀴즈 번호와 상관없이 각 강좌의 최상위 점수를 기준)
SELECT *
FROM (
    SELECT
        c.course_id, 
        q.quiz_id, 
        qa.score, 
        qa.user_id, 
        RANK() OVER (PARTITION BY c.course_id ORDER BY qa.score DESC) AS score_rank
    FROM courses c
    JOIN quizzes q ON c.course_id = q.course_id
    JOIN quiz_attempts qa ON q.quiz_id = qa.quiz_id
) ranked
WHERE ranked.score_rank <= 3
ORDER BY ranked.course_id, ranked.score DESC, ranked.quiz_id;

-- 각 강좌에서 상위 기준을 어디에 둘 것인가?
-- 강좌별로 퀴즈가 여러개 있고,
-- 퀴즈를 여러개 푼 학생, 하나만 푼 학생, 하나도 풀지 않은 학생이 있을 수 있음
-- 각 강좌에서 학생별 퀴즈 총점울 기준으로 상위 기준을 둔 경우
-- 1-4.
WITH course_user_scores AS ( -- 각 강좌에서 학생별 총점 계산
    SELECT 
        c.course_id, 
        qa.user_id, 
        COALESCE(SUM(qa.score), 0) AS total_score  -- 학생이 퀴즈를 하나라도 풀었다면 총점 계산
    FROM courses c
    LEFT JOIN quizzes q ON c.course_id = q.course_id
    LEFT JOIN quiz_attempts qa ON q.quiz_id = qa.quiz_id
    GROUP BY c.course_id, qa.user_id
),
ranked_users AS ( -- 강좌별로 학생 총점 기준으로 RANK 부여
    SELECT 
        course_id, 
        user_id, 
        total_score,
        RANK() OVER (PARTITION BY course_id ORDER BY total_score DESC) AS score_rank
    FROM course_user_scores
)
-- 상위 3명의 학생만 필터링
SELECT course_id, user_id, total_score, score_rank
FROM ranked_users
WHERE score_rank <= 3
ORDER BY course_id, score_rank;


-- grade 테이블을 이용해서 상위 3명의 학생을 조회하기
SELECT * FROM grades ORDER BY course_id, final_score DESC;

-- 각 강좌에서 상위 3명의 학생을 RANK()를 이용해 조회 122 / 사람 명수 우선. 3까지는 안 나옴. 3명만 나옴
SELECT
*
FROM
(SELECT
	course_id,
	user_id,
	RANK() OVER (PARTITION BY course_id ORDER BY final_score DESC) AS score_rank
FROM grades) sub
WHERE sub.score_rank <= 3;

-- DENSE_RANK() 를 이용해 상위 5명까지 출력하고 순위 차이를 비교하세요. 순위 우선. 5위까지 나옴. 5명 아닌 6명. 122345
SELECT
*
FROM
(SELECT
	course_id,
	user_id,
	DENSE_RANK() OVER (PARTITION BY course_id ORDER BY final_score DESC) AS score_rank
FROM grades) sub
WHERE sub.score_rank <= 5;

-- ROW_NUMBER()를 이용해 학생별로 최근 응시한 퀴즈 1개만 조회하세요.
SELECT * FROM quiz_attempts;

SELECT *
FROM (
SELECT 
	quiz_id,
	user_id,
	ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY attempted_at DESC) AS recent_quiz
FROM quiz_attempts
) sub
WHERE sub.recent_quiz = 1;

-- ---------------------------- 미션
-- 두개의 강좌를 결제한 후, 첫번째 결제만 유지하고 두번째 결제는 취소하세요.


