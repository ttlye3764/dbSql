--INDEX 실습
--1. TABLE FULL
--2. idx1 : empno
--2. idx2 : job

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

SELECT *
FROM TABLE(dbms_xplan.display);

--------------------------------------------------------------------------------------------
| Id  | Operation                   | Name         | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |              |     1 |    38 |     2   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS BY INDEX ROWID| EMP          |     1 |    38 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_N_EMP_02 |     3 |       |     1   (0)| 00:00:01 |
--------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("ENAME" LIKE 'C%')
   2 - access("JOB"='MANAGER');
-- 두개의 컬럼에 인덱스 생성

CREATE INDEX idx_n_emp_03 ON emp (job, ename);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job ='MANAGER' 
AND ename LIKE 'C%';

SELECT *
FROM TABLE(dbms_xplan.display);

--------------------------------------------------------------------------------------------
| Id  | Operation                   | Name         | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |              |     1 |    38 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP          |     1 |    38 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_N_EMP_03 |     1 |       |     1   (0)| 00:00:01 |
--------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("JOB"='MANAGER' AND "ENAME" LIKE 'C%')
       filter("ENAME" LIKE 'C%');
       
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job ='MANAGER' 
AND ename LIKE '%C';

-- %가 맨앞에 나오면 인덱스가 맨 처음 데이터부터 읽어야 해서 인덱스의 의미가 크게 없다.

SELECT *
FROM TABLE(dbms_xplan.display);


--1.TABLE FULL
--2.idx1 : empno
--3.idx2 : job
--4.idx3 : job + ename
--5.idx4 : ename + job

CREATE INDEX idx4_n_emp_O4 ON emp(ename,job);

-- 인덱스 생성 모양은 요로케 생겼다
SELECT ename, job, ROWID
FROM emp
ORDER BY ename, job; 

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'J%';

SELECT *
FROM TABLE(dbms_xplan.display);
       
-- 조건절에 부합하는 인덱스가 이싿고해서 항상 인덱스를 사용하는 것은 아님

-- DBMS의 옵티마이저에 판단에 의해 인덱스 스캔을 할 수도 있고 테이블 전체 스캔을 할 수도 있음

-- 옵티마이저가 상황에 맞게 쿼리를 실행할 실행계획을 작성
-- HINT를 통해 개발자가 원하는 실행계획 작성가능



-- JOIN

사용할 수 있는 경우의 수
emp - TABLE FULL, PK_empa(empno)
dept - - TABLE FULL, PK_dept(deptno)

emp - TABLE FULL, dept-TABLE FULL
dept-TABLE FULL, emp - TABLE FULL

emp - TABLE FULL, dept - PK_dept
dept - PK_dept, emp - TABLE FULL

emp - PK_emp, dept - TABLE FULL
dep - TABLE FULL, emp - PK_emp

emp - PK_emp, dept - PK_dept
dept - PK_dept, emp - PK_emp

--1.순서
--ORACLE - 실시간 응답 OLTP (ON LINE TRANSACTION PROCESSING) (실시간 응답이 중요)

--       - 전체 처리시간 : OLAP (ON LINE ANALYSIS PROCESSING) - 복잡한 쿼리의 실행계획을 세우는데 30분~1시간까지 걸리기도함
--                 * 사용자가 몰라도 되는 것들 .. BACK JOB으로 돌아감 (전체 처리시간이 우선, 즉시 처리가 중요한게 아님, 모든 실행계획을 검토해서 실행)

--2. N개 테이블 조인
--   만약 각각의 테이블에 인덱스가 5개씩 있다면
--   한 테이블에 접근 전략 : 6개
--   총 경우의 수 : 6 * N * 2 

-- 조인했을 때 emp부터 읽을까 dept 부터 읽을까??
EXPLAIN PLAN FOR
SELECT ename, dname, loc
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.empno = 7788;

SELECT *
FROM TABLE(dbms_xplan.display);

Plan hash value: 3315830739

4 - 3 - 5 - 2 - 6 - 1 - 0
 
----------------------------------------------------------------------------------------------
| Id  | Operation                     | Name         | Rows  | Bytes | Cost (%CPU)| Time     |
----------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT              |              |     1 |    33 |     3   (0)| 00:00:01 |
|   1 |  NESTED LOOPS                 |              |       |       |            |          |
|   2 |   NESTED LOOPS                |              |     1 |    33 |     3   (0)| 00:00:01 |   
|   3 |    TABLE ACCESS BY INDEX ROWID| EMP          |     1 |    13 |     2   (0)| 00:00:01 |   
|*  4 |     INDEX RANGE SCAN          | IDX_N_EMP_01 |     1 |       |     1   (0)| 00:00:01 |   
|*  5 |    INDEX UNIQUE SCAN          | PK_DEPTA     |     1 |       |     0   (0)| 00:00:01 |   
|   6 |   TABLE ACCESS BY INDEX ROWID | DEPT         |     1 |    20 |     1   (0)| 00:00:01 |
----------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   4 - access("EMP"."EMPNO"=7788)
   5 - access("EMP"."DEPTNO"="DEPT"."DEPTNO")


-- index vs TABLE FULL ACCESS
-- 인덱스
-- 소수의 데이터 조회 시 유리 : 응답속도가 중요할 때
-- I/O 기준이 single block : 다량의 데이터를 인덱스로 접근하면 테이블 전체 조회보다 오히려 느리다.
-- 테이블의 각 컬럼마다 인덱스가 지정되있으면
-- 데이터 삽입시 컬럼마다 정렬작업이 이루어지기 때문에 부담이 증가한다.
-- -> SELECT 때는 유리할 수 있지만 UPDATE, INSERT, DELETE시 부하가 커진다.
-- 안만들면 좋고 조건이 많은 테이블일 경우 한 5개? 까지가 MAX
 시스템에서 실행되는 모든 쿼리를 분석하여 적정 인덱스를 설계하는 작업이 어려움 ;

-- TABLE FULL ACCESS
-- 테이블의 모든 데이터를 읽어서 처리하는 경우라면 인덱스보다 유리
-- I/O의 기준이 MULTI BLOCK 
-- 인덱스만 읽고도 만족하는 ? 




--인덱스 비교연산자 순서??
--1. cims_cd(=)
--2. cs_rcv_id(=), cs_rcv_(between)
--3. cs_rcv_(between), cs_rcv_id(=), = , =, = , LIKE

테이블에 인덱스가 많다면 PPT참고 105쪽?;

--일자 인덱스
 PPT 참고해서 하자 106쪽;
 
CREATE TABLE dept_test2 AS
SELECT *
FROM dept
WHERE 1=1;
SELECT * FROM DEPT_TEST2;



ALTER TABLE dept_test2 ADD CONSTRAINT PK_dept_test2 PRIMARY KEY (deptno);
CREATE INDEX idx_n_dept_test2_01 ON dept_test2(dname);
CREATE INDEX idx_n_dept_test2_02 ON dept_test2 (deptno, dname);

DROP INDEX idx_n_dept_test2_02;


emp  empno - PRIMARY KEY
     ename - NON-UNIQUE 
     sal, deptno - NON-UNIQUE
     empno, mgr = non-UNIQUE
     
desc dept;
CREATE TABLE emp1(
    EMPNO NUMBER(4) NOT NULL,
    ENAME VARCHAR2(10), 
    JOB VARCHAR2(9),
    MGR NUMBER(4),    
    HIREDATE DATE,         
    SAL NUMBER(7,2),
    COMM NUMBER(7,2),  
    DEPTNO NUMBER(2)    
    );
DROP TABLE dpet1;
CREATE TABLE dpet1(
    dept NUMBER(2) NOT NULL,
    dname VARCHAR2(14),
    loc VARCHAR2(13)
);

CREATE TABLE dept1 AS
SELECT *
FROM dept
WHERE 1=1;


--1.
EXPLAIN PLAN FOR
SELECT *
FROM EMP1
WHERE empno = 7369;

access pattern
empno(=)

--해결 
ALTER TABLE emp1 ADD CONSTRAINT PK_emp1 PRIMARY KEY (empno);
ALTER TABLE dept1 ADD CONSTRAINT PK_dept1 PRIMARY KEY (deptno);

--2. 
EXPLAIN PLAN FOR
SELECT *
FROM emp1
WHERE ename = 'SMITH' ;

access pattern
ename(=)
    
--해결
CREATE INDEX idx_emp1_ename ON emp1 (ename);

3.
EXPLAIN PLAN FOR
SELECT *
FROM emp1 e, dept1 d
WHERE e.deptno = d.deptno
AND e.deptno = 20
AND e.empno LIKE 7 || '%';

access pattern
deptno(=), empno(LIKE 직원번호)

-- 해결
CREATE INDEX idx_emp1_deptno_empno ON emp1(deptno);
DROP INDEX idx_emp1_deptno_empno;

SELECT *
FROM emp1;


DROP INDEX idx_emp1_deptno;

SELECT *
FROM TABLE(dbms_xplan.display);

--4번
EXPLAIN PLAN FOR
SELECT *
FROM emp1
WHERE sal BETWEEN 2000 AND 3000
AND deptno = 20;
-- 해결


--5번
EXPLAIN PLAN FOR
SELECT b.*
FROM emp1 a, emp1 b
WHERE a.mgr = b.empno
AND a.deptno = 20;


DROP INDEX idx_emp1_mgr;

--6번
EXPLAIN PLAN FOR
SELECT deptno, TO_CHAR(hiredate, 'yyyymm'), COUNT(*) cnt
FROM emp1
GROUP BY deptno, TO_CHAR(hiredate, 'yyyymm');

-- 생성 인덱스
ALTER TABLE emp1 ADD CONSTRAINT PK_emp1 PRIMARY KEY (empno);
--ALTER TABLE dept1 ADD CONSTRAINT PK_dept1 PRIMARY KEY (deptno);
CREATE INDEX idx_emp1_ename ON emp1 (ename);
CREATE INDEX idx_emp1_deptno ON emp1(deptno);




