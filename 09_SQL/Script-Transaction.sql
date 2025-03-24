/*
 * 트랜잭션
 * 여러 개의 SQL 작업을 하나의 논리적인 단위로 묶는 것
 * 모든 작업이 성공하면 적용(Commit), 실패하면 취소(Rollback)
 * 데이터 무결성을 보장하는 핵심 기능
 * 
 * 트랜잭션의 4가지 특성(기사 시험 및 면접 출제)
 * Atomicity(원자성) 트랜잭션 내 모든 작업이 성공하거나 실패해야함
 * Consistency(일관성) 트랜잭션 전후 데이터 무결성을 유지해야 함
 * Isolation(격리성) 동시에 실행되는 트랜잭션 간 영향 최소화
 * Durability(지속성) 트랜잭션이 Commit이 되면 데이터가 영구 저장됨
 * 
 * 결제(결제_id) -> 주문서 생성(주문_id) -> 주방 빌지 생성(빌지_id)
 * 결제는 써드파티 외부 시스템 활용, 결제 완료되면 승인 번호 가지고 주문서 생성, 주문서의 아이템으로 주방 빌지 생성
 * 
 * */

/*
 * 모듈 2 : commit & Rollback
 * 학생이 강의를 결제했을 때 결제 테이블(payments)와 수강 신청 테이블(enrollments)를 동시에 업데이트한다.
 * 만약 한쪽에서 오류가 발생하면 모든 작업을 워낼 상태로 되돌려야 한다.
 * */
-- 트랜잭션 시작
START TRANSACTION;
SELECT * FROM users WHERE user_id = 10003;
SELECT * FROM courses WHERE course_id = 1;
SELECT * FROM payments;
-- 결제 내역 추가
INSERT INTO payments(user_id, course_id, amount, payment_status)
VALUES (10003, 1, 297.36, "pending");

-- 수강 신청 추가
INSERT INTO enrollments (user_id, course_id, status)
VALUES (10003, 1, "active");

COMMIT;

SELECT * FROM payments WHERE user_id = "10003";
SELECT * FROM enrollments WHERE user_id = "10003";

/*
 * rollback (에러 발생시 되돌리기)
 * */
START TRANSACTION;

INSERT INTO payments(user_id, course_id, amount, payment_status)
VALUES (10003, 1, 297.36, "pending");

SELECT * FROM payments p WHERE user_id = 10003;

-- 오류 만들기
INSERT INTO enrollments (user_id, course_id, status)
VALUES (10003, 999999, "active");

ROLLBACK; -- payment_id 30002 가 취소됨

SELECT * FROM payments p WHERE user_id = 10003;


/*
 * SAVE POINT
 * 트랜잭션 내에서 부분적으로 저장할 수 있는 포인트를 설정
 * 특정 지점까지만 Rollback 가능 (save point 이후 실행된 SQL만 취소됨)
 * */

START TRANSACTION;

-- 첫번째 결제
INSERT INTO payments(user_id, course_id, amount, payment_status)
VALUES (10003, 4, 37.78, "pending");
SAVEPOINT payment1;

SELECT * FROM payments p WHERE user_id = 10003;

-- 두번째 결제
INSERT INTO payments(user_id, course_id, amount, payment_status)
VALUES (10003, 99, 37.78, "pending");


-- 세번째 결제
INSERT INTO payments(user_id, course_id, amount, payment_status)
VALUES (10003, 999, 37.78, "pending");

-- 네번째 결제
INSERT INTO payments(user_id, course_id, amount, payment_status)
VALUES (10003, 99999, 37.78, "pending");

-- 조회
SELECT * FROM payments p WHERE user_id = 10003;

ROLLBACK TO SAVEPOINT payment1; -- 첫번째 결제 세이브 포인트로 돌아감

COMMIT;


