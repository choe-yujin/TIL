-- INSERT : 데이터 추가
INSERT INTO roles (role_name)
VALUES ("test_role"); 

-- SELECT : 데이터 조회
SELECT
	role_id,
	role_name
FROM
	roles;

-- UPDATE
UPDATE 
	roles 
SET 
	role_name = "delete_role" 
WHERE 
	role_id = 4;

-- DELETE
DELETE
FROM 
	roles
WHERE 
	role_id = 4;

-- 다중 INSERT
INSERT INTO
	users(username, email, password_hash, role_id)
VALUES
	("Bob", "bob@gmail.com", "hash5454", 2),
	("Cathy", "cathy@gmail.com", "hash2323", 3);

