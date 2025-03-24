-- View
/*
View의 정의:
하나 이상의 테이블에서 가져온 데이터를 저장하는 가상의 테이블
데이터를 실제로 저장하지 않고, 원본 테이블을 참조하여 결과를 제공한다

실생활 비유:
매일 아침 인기 뉴스를 보여주는 페이지는 뉴스 데이터베이스에서 특정 조건을 만족하는 뉴스만 보여줌
실제 뉴스 기사를 따로 저장하는 것이 아니라, 특정 기준으로 필터링된 기사 목록만 보여줌

View를 사용하는 이유:
- 복잡한 쿼리 단순화
join, group by, 서브 쿼리 등 복잡한 쿼리를 매번 직접할 필요 없이 View를 생성하면 재사용이 가능함

- 보안성 강화
특정 컬럼만 노출하여 민감한 데이터 보호 가능

- 읽기 전용 데이터복사본 활용 가능
직접 데이터를 수정할 수 없도록 막고, 조회만 가능하도록 설정 가능

- 성능 최적화
자주 실행하는 복잡한 쿼리를 미리 정의하여 성능 향상 가능
*/

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