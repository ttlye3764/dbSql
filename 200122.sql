SELECT * FROM lprod;

SELECT buyer_id, buyer_name FROM buyer;

SELECT * FROM cart;

SELECT mem_id, mem_pass, mem_name FROM member;

--users 테이블 조회
--users 에는 5건의 데이터가 존재

SELECT *
FROM users;

-- WHERE절 : 테이블에서 데이터를 조회할 때 조건에 맞는 행만 조회
-- ex) userid 컬럼의 값이 brown인 행만 조회

SELECT *
FROM users
WHERE userid = 'brown'; -- 싱글 쿼테이션을 안쓰면 user에 있는 컬럼으로 인식 -> brown 컬럼, 'brown' 문자열 상수

--userid가 brown이 아닌 행만 조회
SELECT *
FROM users
WHERE userid != 'brown';

--emp 테이블에 존재하는 컬럼을 확인 해보세요
desc emp;

SELECT *
FROM emp;

--emp 테이블에서 ename 컬럼 값이 JONES인 행만 조회
-- * SQL KEY WORD는 대소문자를 가리지 않지만
-- 컬럼의 값이나, 문자열 상수는 대소문자를 가린다.
-- 즉, 'JONES' 와 'jones'는 다른 값
SELECT *
FROM emp
WHERE ename = 'JONES' ;

-- emp테이블에서 deptno (부서번호) 가 30보다 크거나 같은 사원들만 조회
SELECT *
FROM emp
WHERE deptno >= 30;

-- 문자열 : '문자열'
-- 숫자 : 50
-- 날짜 : ??? --> 함수와 문자열을 결합해서 사용
--       문자열만 이용하여 표현 가능하지만 권장하지 않음 (국가별로 날짜 표기 방법이 다름)
--       한국 : 년도 4자리 - 월 2자리 - 일자 2자리
--       미국 : 월 2자리 - 일자 2자리 - 년도 4자리
-- 입사일자가 1980년 12월 17일 직원만 조회
SELECT ename, hiredate
FROM emp;

-- TO_DATE : 문자열을 date 타입으로 변경하는 함수 
-- TO_DATE(날짜형식 문자열, 첫번째 인자의 형식)
-- '1980/02/03'
SELECT *
FROM emp
WHERE hiredate = TO_DATE('19801217','YYYYMMDD');

-- 범위연산
-- sal 컬럼의 값이 1000에서 2000 사이인 사람
SELECT *
FROM emp;

SELECT *
FROM emp
WHERE sal >= 1000 AND sal <= 2000;

SELECT *
FROM emp
WHERE SAL BETWEEN 1000 AND 2000 ;
--emp 테이블에서 입사 일자가 1982년 1월 1일 이후부터 1983년 1월 1일 이전인 사원의 ename, hiredate를 조회하는 쿼리를 작성하시오
--연산자는 BETWEEN 사용
SELECT ename, hiredate
FROM emp
WHERE hiredate between TO_DATE('19820101','YYYYMMDD') AND TO_DATE('19830101','YYYYMMDD');

-- 테이블에 어떤 컬럼이 있는지 확인하는 방법
-- 1. SELECT * FROM users;
-- 2. TOOL의 기능 (사용자 - TABLES)
-- 3. DESC 테이블명 (DESC-DESCRIBE)
DESC users;
SELECT id
FROM users;

-- users 테이블에서 userid, usernm, reg_dt 컬럼만 조회하는 sql을 작성하세요
-- 날짜 연산 (reg_dt 컬럼은 date 정보를 담을 수 있는 타입)
-- SQL 날짜 컬럼 + (더하기 연산) 
-- 수학적인 사칙연산이 아닌 것들 (5+5)
-- String h = "hello";
-- String w = "world";
-- String hw = h+w;  -> 자바에서는 두 문자열을 결합해라 
-- SQL에서 정의된 날짜 연산 : 날짜 + 정수 = 날짜에서 정수를 일수로 취급하여 더한다.

SELECT userid u_id, usernm, reg_dt, reg_dt +5 AS reg_dt_after_5day
FROM users;

SELECT prod_id AS id, prod_name AS name
FROM prod;

SELECT lprod_gu AS gu, lprod_nm AS nm
FROM lprod;

SELECT buyer_id AS 바이어아이디, buyer_name AS 이름
FROM buyer;

-- 자바 언어에서 문자열 결합 : + ("hello" + "world")
-- SQL에서는 두 가지가 있다잉
-- SQL에서는 || ('hello' || 'world')
-- SQL에서는 concat('hello', 'world') concat이라는 함수 사용

-- userid, usernm 컬럼을 결합, 별칭 id_name

SELECT userid || usernm AS id_name
FROM users;

-- 변수, 상수
-- int a = 5; String msg = "hello World"; -> 변수
-- System.out.println(msg); -> 변수를 이용한 출력
-- System.out.println("hello World"); -> 상수를 이용한 출력
-- FINAL int a  = 5 ; -> 상수
-- SQL에서의 변수는 없음 (컬럼이 비슷한 역할, PL/SQL에서는 변수의 개념이 존재)
-- SQL에서 문자열 상수는 싱글 쿼테이션('')으로 표현
-- "Hello, World" --> 'Hello, World'

-- 문자열 상수와 컬럼간의 결합
-- user id : brown
-- user id : cony

-- AS(별칭)에는 공백이 들어갈 수 없지만 더블 쿼테이션을("") 사용하면 가능
-- AS(별칭)에는 소문자가 들어갈 수 없지만 더블 쿼테이션을("") 사용하면 가능
SELECT 'user id : ' || userid AS "user id"
FROM users;

SELECT 'SELECT * FROM ' ||TABLE_NAME || ';' AS QUERY
FROM USER_TABLES;

-- concat
SELECT concat(concat('SELECT * FROM ', TABLE_NAME),';') AS QUERY
FROM USER_TABLES;

-- int a = 5; -> java에서는 할당, 대입 연산자
-- a == 5 이게 이퀄
-- SQL에서는 = --> equal, wql에서는 대입의 개념이 없다 (PL/SQL에서는 있당)
-- where절 조건 연산자 따로 검색해서 정리하자


