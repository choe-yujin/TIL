use helloworldlabs_lms;

-- GROUP BY
-- group by를 사용하지 않는 경우
-- 강좌별 학생의 숫자를 보고자 하여 아래와 같이 조회를 해보자.
SELECT
	c.title "제목",
	c.course_id AS "강좌 번호",
	e.user_id "학번"
FROM courses c
INNER JOIN
	enrollments e ON c.course_id = e.course_id;

-- SQL함수
-- 1. 단일행 함수 : sum, count같은 전체에 대한 result를 하나만 반환. 한 행 반환
-- 2. 다중행 함수 : concat같은 강좌번호와 제목을 합쳐서. 여러 행 반환
-- 단일행 함수와 다중행 함수를 같이 쓸 수 없다.

-- group by
-- group by는 쿼리에서 지정한 필드에 대해 같은 값을 가진 행들을 그룹화 하는 기능이다.
-- 이를 통해 각 그룹마다 집계 함수 (예 : count, sum, avg)를 사용하여 그룹화된 데이터의 통계 정보를 계산할 수 있다.
-- group by 구문을 사용하면, 동일한 값을 가진 행들이나 하나의 결과로 묶여 데이터 분석에 유용하게 사용할 수 있다.

-- 그룹 함수는 여러 개의 행을 하나의 결과로 반환하기 때문에 1:n 관계의 값을 직접 사용할 수 없다.
-- 예를 들어, count와 sum과 같은 집계 함수는 입력한 필드 전체를 대상으로 1개의 결과를 반환한다.
-- 따라서 그룹화된 결과는 1(그룹) : 1(결과1) 관계가 형성된다.

-- 그러나 concat과 같은 문자열 함수는 개별 행의 값을 결합하므로, 그룹 함수와 함께 사용할 경우
-- 예상치 못한 결과가 발생할 수 있다. 이 경우 1(그룹) : n(결과) 관계가 형성되어 결과 테이블의 행 수가 맞지 않아 오류가 발생할 수 있다.


-- WHERE 절은 쿼리가 실행될 때 원래의 데이터 행을 필터링하는 데 사용된다.
-- 이 절은 GROUP BY 절이 "실행되기 전"에 적용되기 때문에,
-- 집계 함수인 COUNT(e.user_id)의 결과인 student_count를 참조할 수 없다.
-- 따라서 WHERE 절에서 student_count를 사용할 수 없다.

-- 반면 HAVING 절은 GROUP BY 절이 실행된 후에 적용되기 때문에
-- 이 절은 집계 함수의 결과를 기반으로 필터링할 수 있으며,
-- 따라서 COUNT(e.user_id)로 계산된 student_count를 참조할 수 있다.
-- 이는 HAVING 절이 그룹화된 데이터에 대한 조건을 설정할 수 있게 해준다.


-- group by 사용하는 경우
SELECT
	c.course_id AS "강좌 번호",
	c.title AS "제목",
	COUNT(e.user_id) AS "학생수"
FROM courses c
LEFT JOIN
	enrollments e ON c.course_id = e.course_id
GROUP BY
	c.course_id;
-- INNER JOIN으로 하면 1001,1002 는 0명이므로 안 보임
-- LEFT JOIN으로 해야 0명인 강좌도 보임
-- SELECT DISTINCT 는 중복 제거

SELECT * FROM courses;

-- 학생수 60명 이상인거만 출력(WHERE 쓰면 안됨, HAVING 쓰기)
SELECT
	c.course_id AS "강좌 번호",
	c.title AS "제목",
	COUNT(e.user_id) AS "학생수"
FROM courses c
LEFT JOIN
	enrollments e ON c.course_id = e.course_id
GROUP BY
	c.course_id
HAVING 
	학생수 >= 60;

-- WHERE 절은 쿼리가 실행될 때 원래의 데이터 행을 필터링하는 데 사용된다.
-- 이 절은 GROUP BY 절이 "실행되기 전"에 적용되기 때문에,
-- 집계 함수인 COUNT(e.user_id)의 결과인 student_count를 참조할 수 없다.
-- 따라서 WHERE 절에서 student_count를 사용할 수 없다.

-- 반면 HAVING 절은 GROUP BY 절이 실행된 후에 적용되기 때문에
-- 이 절은 집계 함수의 결과를 기반으로 필터링할 수 있으며,
-- 따라서 COUNT(e.user_id)로 계산된 student_count를 참조할 수 있다.
-- 이는 HAVING 절이 그룹화된 데이터에 대한 조건을 설정할 수 있게 해준다.

/*
 * 그룹바이의 깊은 개념
 * 그룹바이는 기본적으로 모든 행을 읽고 난 이후에 실행이 된다.
 * 이러한 이유로 인해 내부적으로 I/O가 많이 발생하며, 정렬을 진행하는 과정에서 
 * 중간 결과를 저장하는 행위가 발생하게 되고 이 과정에서 메모리와 디스크 간의 
 * 데이터 이동이 추가로 발생되어 추가적인 I/O가 발생하게 된다.
 * 
 * 그룹화 작업이 수행될 때, 데이터베이스는 원본 테이블의 모든 행을 읽어 
 * 주어진 그룹화 기준에 따라 각 행을 적절한 그룹에 배치해야 한다. 
 * 따라서 데이터의 양이 많을수록 I/O 작업이 증가하게 된다.
 * 
 * 또한, GROUP BY 절은 그룹화된 결과를 정렬해야 하므로, 정렬 작업에도 
 * I/O가 발생한다. 이 과정에서 정렬된 데이터를 메모리에 저장하고, 
 * 필요한 경우 디스크에 임시로 저장하는 과정이 추가적으로 발생할 수 있다.
 * 
 * 이러한 이유로 인해 그룹바이는 인덱스를 통해 자주 그룹화하는 값에 대해 
 * 사전 정렬을 해주는 것이 좋다. 인덱스를 활용하면 전체 테이블 스캔을 
 * 피하고 필요한 데이터에 직접 접근할 수 있어 I/O를 줄이고 
 * 쿼리 성능을 향상시킬 수 있다.
 * 
 * 마지막으로, 데이터베이스의 쿼리 최적화 기법을 활용하여 
 * 그룹화 작업을 최소화하거나 효율적으로 수행하는 것도 
 * 성능을 개선하는 데 중요한 요소이다.
 */

-- 미션1: quiz_attempts에서 퀴즈별 평균 점수 계산.
-- 조건: 평균 점수가 70 이상인 퀴즈만 조회.
-- 결과: 퀴즈 제목과 평균 점수.
-- 힌트: GROUP BY와 HAVING 사용.
SELECT * FROM quiz_attempts;
SELECT * FROM quizzes;

SELECT 
	q.title,
	AVG(qa.score) AS avg_score
FROM
	quizzes q
JOIN
	quiz_attempts qa ON q.quiz_id = qa.quiz_id
GROUP BY 
	q.quiz_id
HAVING
	avg_score >= 70;

-- 미션2: enrollments에서 강좌별 수강생 수 계산.
-- 조건: 수강생이 2명 이상인 강좌만 조회.
-- 결과: 강좌 제목과 수강생 수.
-- 힌트: course_id로 그룹화.
SELECT * FROM enrollments;
SELECT * FROM courses;

SELECT 
	c.title,
	COUNT(e.user_id) AS "학생수"
FROM
	enrollments e
LEFT JOIN
	courses c ON e.course_id = c.course_id
GROUP BY
	e.course_id
HAVING
	학생수 >= 2;

-- 미션3: quiz_attempts에서 사용자별 평균 점수 계산.
-- 조건: 평균 점수가 80 이상인 사용자만 조회.
-- 결과: 사용자 이름과 평균 점수.
-- 힌트: user_id로 그룹화
SELECT * FROM quiz_attempts;

SELECT 
	u.username,
	AVG(qa.score) AS avg
FROM
	quiz_attempts qa
JOIN
	users u ON qa.user_id = u.user_id
GROUP BY
	qa.user_id
HAVING
	avg >= 80;

-- 미션4: lessons에서 강좌별 강의 수 계산.
-- 조건: 강의가 3개 이상인 강좌만 조회.
-- 결과: 강좌 제목과 강의 수.
-- 힌트: course_id로 그룹화.
SELECT * FROM lessons;
SELECT * FROM courses;

SELECT
	c.title,
	COUNT(l.lesson_id) AS 강의수
FROM
	lessons l
LEFT JOIN
	courses c ON l.course_id = c.course_id
GROUP BY
	l.course_id
HAVING 
	강의수 >= 3;
	
-- 미션5: grades에서 강좌별 평균 점수 계산.
-- 조건: 평균 점수가 60 이상인 강좌만 조회.
-- 결과: 강좌 제목과 평균 점수.
-- 힌트: course_id로 그룹화.
SELECT * FROM grades;
SELECT
	c.title,
	AVG(final_score) AS avg
FROM
	grades g
LEFT JOIN 
	courses c ON g.course_id = c.course_id
GROUP BY
	g.course_id
HAVING
	avg >= 60;

-- 미션6: users를 가입일순으로 정렬.
-- 조건: 최신 가입자부터 표시.
-- 결과: username과 created_at.
-- 힌트: ORDER BY와 DESC 사용
SELECT 
	username,
	created_at
FROM 
	users 
ORDER BY created_at DESC;


-- 미션7: courses를 가격순으로 정렬.
-- 조건: 가장 비싼 강좌부터 표시.
-- 결과: 강좌 제목과 가격.
-- 힌트: price로 정렬.
SELECT
	title,
	price
FROM 
	courses
ORDER BY 
	price DESC;


-- 미션8: payments를 결제 금액순으로 정렬.
-- 조건: 높은 금액부터 표시.
-- 결과: course_id와 amount.
-- 힌트: amount로 정렬.
SELECT 
	course_id,
	amount
FROM 
	payments
ORDER BY
	amount DESC;

-- 미션9: quiz_attempts를 점수순으로 정렬.
-- 조건: 낮은 점수부터 표시.
-- 결과: quiz_id와 score.
-- 힌트: score로 정렬.
SELECT
	quiz_id,
	score
FROM 
	quiz_attempts
ORDER BY
	score;

-- 미션10: lessons를 생성일순으로 정렬.
-- 조건: 최신 강의부터 표시.
-- 결과: title과 created_at.
-- 힌트: created_at으로 정렬.
SELECT
	title,
	created_at
FROM 
	lessons
ORDER BY
	created_at DESC;


