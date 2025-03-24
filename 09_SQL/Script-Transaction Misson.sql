
-- 미션 두개의 강좌를 결제한 후, 첫번째 결제만 유지하고 두번째 결제는 취소
/*
 * rollback & save point
 * */
SELECT * FROM payments;
SELECT * FROM users ORDER BY user_id DESC;
SELECT * FROM courses WHERE course_id = 2;

START TRANSACTION;

INSERT INTO payments(user_id, course_id, amount, payment_status)
VALUES (10002, 1, 297.36, "pending");
SAVEPOINT pay1;

INSERT INTO payments(user_id, course_id, amount, payment_status)
VALUES (10002, 2, 60.9, "pending");

SELECT * FROM payments p WHERE user_id = 10002;

ROLLBACK TO SAVEPOINT pay1;

SELECT * FROM payments p WHERE user_id = 10002; -- 2번 강좌 결제는 취소됨