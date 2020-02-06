
-- insert
 -- 컬럼명을 기술하면 해당 컬럼에 들어갈 데이터값 하나가 들어감 ( 컬럼과 데이터를 정확히 매칭해주어야함)
 -- 컬럼명을 기술하지 않으면 해당 테이블의 모든 데이터 값을 VALUES안에 넣어줘야함
 
-- NOT NULL로 NULL값이 들어가지 않게 설정가능 
--     ->   데이터 무결성 : 사용자가 의도한대로 정확히 들어갈 장치를 마련한게  
-- 

DESC EMP;

-- empno 컬럼은 not null 제약조건이 있다 - insert시 반드시 값이 존재해야 정상적으로 입력된다.
-- empno 컬럼을 제외한 나머지 컬럼은 NULLABLE이다( NULL값이 저장될 수 있다.) 

INSERT INTO emp (empno, ename, job)
VALUES(9999,'brown', NULL);

SELECT *
FROM emp;

-- empno 는 NOT NULL제약 조건이 있기때문에 반드시 empno의 값을 넣어주어야함 (NULL값 제외한)
INSERT INTO emp(ename, job)
VALUES ('sally', 'SALESMAN');

-- 문자열 : ''
-- 숫자 : 
-- 날짜 : TO_DATE('20200206', 'YYYYMMDD'), SYSDATE

-- emp 텐이블의 hiredate컬럼은 date 타입
-- emp 테이블의 8개 컬럼에 값을 입력

DESC emp;
INSERT INTO emp VALUES(9998, 'sally', 'SALESMAN', NULL, SYSDATE, 1000, NULL,99);
ROLLBACK;

-- 여러건의 데이터를 한번에 INSERT : 
-- INSERT INTO 테이블명 [COL1, COL2, ...]
-- SELECT ...
-- FROM ;W

INSERT INTO emp -- 테이블 컬럼 순서대로 데이터를 맞춰주었기 때문에 컬럼을 기술 안해줘도 됌
SELECT 9998, 'sally', 'SALESMAN', NULL, SYSDATE, 1000, NULL,99 
FROM dual
UNION ALL  --두 테이블이 중복이 없는걸 우리가 아니까 굳이 UNION을 쓰지않는다 -> 효율성
SELECT 9999, 'brown', 'CLERK', NULL, TO_date('20200205','YYYYMMDD'), 1100,NULL,99
FROM dual;

SELECT *
FROM emp;


-- 99번 부서번호를 갖는 부서 정보가 DEPT 테이블에 있는 상황
INSERT INTO dept VALUES (99,'ddit', '');
-- 99번 부서번호를 갖는 부서의 dname 컬럼의 값을 '대덕IT', loc 컬럼의 값을 '영민빌딩'으로 업데이트

UPDATE dept SET dname = '대덕IT', loc = '영민빌딩'
WHERE deptno = 99;

SELECT *
FROM dept
WHERE deptno = 99;

-- 실수로 WHERE절을 기술하지 않았을 경우

