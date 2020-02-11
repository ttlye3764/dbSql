--제약 조건 확인 방법
--1. tool
--2. dictionsary view
--
--제약 조건 : USER_CONSTRAINTS
--제약조건 컬럼 : USER_CONS_COLUMNS
----> 나눠놓은 이유 : 제약조건이 몇개의 컬럼에 관련되어 있는지 알 수 없기 때문에 테이블을 별도로 분리하여 설계
--
--1. 정규형

SELECT *
FROM USER_CONSTRAINTS
WHERE table_name IN('EMP', 'DEPT', 'EMP_TEST', 'DEPT_TEST');

emp, dept pk, fk 제약조건이 없음

emp : pk (empno)
      fk (deptno) -> (dept.deptno) : (fk 제약을 생성하기 위해서는 참조하는 테이블 컬럼에 인덱스가 존재해야 한다.)
      
dept : pk(deptno)

SELECT *
FROM emp;
ALTER TABLE emp ADD CONSTRAINTS PK_empa PRIMARY KEY (empno);
ALTER TABLE dept ADD CONSTRAINTS PK_depta PRIMARY KEY (deptno);
ALTER TABLE emp ADD CONSTRAINTS FK_emp_depta FOREIGN KEY (deptno) REFERENCES dept (deptno);


-- ERD
-- 포워드 엔지니어링
-- 코멘트 생성

-- 테이블, 컬럼 주석 확인 : DICTIONARY를 통해 확인가능
-- 테이블 주석 : USER_TAB_COMMENTS;
-- 컬럼 주석 : USER_COL_COMMENTS;
SELECT *
FROM USER_TAB_COMMENTS
WHERE TABLE_NAME IN('CUSTOMER', 'PRODUCT', 'CYCLE', 'DAILY');

SELECT *
FROM USER_COL_COMMENTS
WHERE TABLE_NAME IN('CUSTOMER', 'PRODUCT', 'CYCLE', 'DAILY');



-- 주석생성
-- 테이블 주석 : COMMENT ON TABLE 테이블명 IS '주석';
-- 컬럼 주석 : COMMENT ON COLUMN 테이블.컬럼명 IS '주석';

COMMENT ON TABLE emp IS '직원';
COMMENT ON TABLE dept IS '부서';

COMMENT ON COLUMN dept.deptno IS '부서번호';
COMMENT ON COLUMN dept.dname IS '부서명';
COMMENT ON COLUMN dept.loc IS '부서번호';
COMMENT ON COLUMN emp.empno IS '직원 번호';
COMMENT ON COLUMN emp.ename IS '직원 이름';
COMMENT ON COLUMN emp.job IS '담당업무';
COMMENT ON COLUMN emp.mgr IS '매니저 직원번호';
COMMENT ON COLUMN emp.hiredate IS '입사일자';
COMMENT ON COLUMN emp.sal IS '급여';
COMMENT ON COLUMN emp.comm IS '성과급';
COMMENT ON COLUMN emp.deptno IS '소속부서번호';

-- comments 실습
-- USER_TAB_COMMENTS, USER_COL_COMMENTS VIEW를 이용하여
-- customer, product, cycle, daily 테이블과 컬럼의 주석 정보를 조회하는 쿼리를 작성하라.

SELECT A.TABLE_NAME, A.TABLE_TYPE, A.COMMENTS TAB_COMMENT, B.COLUMN_NAME, B.COMMENTS COL_COMMENT
FROM 
(SELECT *
FROM USER_TAB_COMMENTS
WHERE TABLE_NAME IN('CUSTOMER', 'PRODUCT', 'CYCLE', 'DAILY')) A,
(SELECT *
FROM USER_COL_COMMENTS
WHERE TABLE_NAME IN('CUSTOMER', 'PRODUCT', 'CYCLE', 'DAILY')) B
WHERE A.TABLE_NAME = B.TABLE_NAME;


-- DDL(VIEW)
-- 급여 정보는 개발자한테 노출 시키고 싶지 않은데..
-- 1. 컬럼제한
-- 자주 사용하는 결과물의 재활용
-- 쿼리 길이 단축

-- VIEW = QUERY 
-- TABLE처럼 미리 DMBS에 미리 작성한 객체
-- ==> 작성하지 않고 QUERY에서 바로 작성한 VIEW : IN-LINEVIEW(이름이 없기 때문에 재활용이 불가)
-- VIEW는 테이블이다 (X)

--사용목적 
--1. 보안 목적(특정 컬럼을 제외하고 나머지 결과만 개발자에게 제공)
--2. INLINE-VIEW를 VIEW로 생성해서 재활용 -> 쿼리 길이 단축
--
--생성 방법
--CREATE [OR REPLACE] VIEW 뷰명칭 [(col1, col2. ...)] AS          OR REPLACE가 있으면 DROP하지않고 수정가능 
--SBUQUERY;
--
--emp 테이블에서 8개 컬럼중 sal, comm컬럼을 제외한 6개 컬럼을 제공하는 v_emp VIEW 생성

CREATE OR REPLACE VIEW v_emp AS
SELECT empno,ename, job, mgr, hiredate, deptno
FROM emp;
--> "insufficient privileges" 오류 '불충분한 권한'
--> 개발자가 view를 직접생성하는건 사실 바람직하진 않음 dba가 하는게 올바름

-- 시스템 계정에서 jaeho 계정으로 view 생성 권한 추가;
GRANT CREATE VIEW TO JAEHO;

--기존 인라인 뷰로 작성시
SELECT *
FROM (SELECT empno, ename, job, mgr, hiredate, deptno
     FROM emp);
     
    -- view 사용
    select *
    from v_emp;
    
emp 테이블에는 부서명이 없음 == > dept 테이블과 조인을 빈번하게 진행
조인된 결과를 view로 생성 해놓으면 코드를 간결하게 작성하는게 가능;

VIEW : V_emp_dept;
dname(부서명), empno(직원번호), ename(직원이름), job(담당업무), hiredate(입사일자)

CREATE OR REPLACE VIEW V_emp_dept AS
SELECT dept.dname, emp.empno, emp.ename, emp.job, emp.hiredate
FROM emp, dept
WHERE emp.deptno = dept.deptno;

-- 인라인뷰 사용시
SELECT *
FROM (
SELECT dept.dname, emp.empno, emp.ename, emp.job, emp.hiredate
FROM emp, dept
WHERE emp.deptno = dept.deptno);

-- 뷰 사용시
SELECT *
FROM V_emp_dept;

-- 기존 데이터가 변하면 view도 변할까?
-- SMITH직원 삭제 후 V_emp_dept_ view 건수 변화를 확인;


-- 삭제된게 반영된다
--  -> 쿼리를


--그룹 함수 사용 x -> simple view
--dml 실행 일반적으로 가능 -> 근데 잘안함
--
--그룹 함수 사용 - > complex view
--dml 실행 불가능
--group by
--distance
--rownum 이 세개사용하면 dml불가능
--
---- squence
--데이터에 key 컬럼은 값이 유일해야 함
--유일한 값을 만드는 방법
--1. key table(미리 값을 정의 해둔 테이블)
--
--2. uuid / 혹은 별도의 라이브러리
--
--3. sequence
--유일한 정수 값을 생성해주는 오라클 객체
-- - pk 컬럼에 저장할 임의의 값 생성
 
--CREATE SEQUENCE squence_name 

-- SEQUENCE : 시퀀스 - 중복되지 않은 정수값을 리턴해주는 오라클 객체
--생성방법
--CREATE SEQUENCE 시퀀스_이름;
--[OPTION ... ] ;  -> 검색해서 찾아보자
--명명규칙 :  SEQ_사용할 테이블명; (일반적인 명명규칙)
--
--EMP 테이블에서 사용한 시퀀스 생성
CREATE SEQUENCE seq_emp;

--시퀀스 제공 함수
--1. NEXTVAL : 시퀀스에서 다음 값을 가져올 때 사용
--2. CURRVAL : NEXTVAL를 사용하고나서 현재 읽어 들인 값을 재확인

SELECT seq_emp.NEXTVAL
FROM dual;

SELECT seq_emp.CURRVAL
FROM dual;

-- 시퀀스 결과 값을 테이블에 삽입 가능

INSERT INTO emp_test VALUES (seq_emp.NEXTVAL, 'james', 99, '017') ;

SELECT *
FROM emp_test;

여러대의 서버에서 사용할 때 동기화할때 필요함
           MASTER 

SALVE1     SLAVE2    SLAVE3
1 - 100  101 - 200  201 -300


-- DDL(INDEX) 중요
-- 정렬해놓고 색인 마냥 찾아가는 개념
-- 테이블의 일부 컬럼을 기준으로 데이터를 정렬한 객체
-- 테이블의 ROW를 가리키는 주소를 가지고 있다.(ROWID)
    -- ROWID 는 테이블의 주소
    SELECT ROWID, emp.*
    FROM emp;
    -- 주소를 알면 바로 접근 가능
    SELECT *
    FROM EMP
    WHERE ROWID = 'AAAE5dAAFAAAACLAAD';
-- 정렬된 인덱스의 기준으로 해당 ROW의 위치를 빠르게 검색하여 테이블의 원하는 행에 빠르게 접근
-- 테이블에 데이터를 입력하면 인덱스 구조도 갱신된다.

그에반해 TABLE
입력 순서대로 데이터 저장 : 비 순차적인 블록 (DELETE 등으로 비 연속적인 블록 구성)
대용량 테이블 엑세스 시 과도한 블록 읽기 발생 

-- 인덱스 사용할때
-- 최소한의 데이터 블록 읽기를 통한 성능향상
-- 방법 ?

FULL TABLE SCAN
테이블 다읽고 WHERE절에 걸리는거 버리고 -> 읽고서 버리냐
INDEX SCAN
원하는 것만 읽냐 -> 걍 필요한 거만 읽냐
FAST FULL INDEX SCAN

-- 인덱스 구조 ?

-- INDEX 실습
-- 인덱스가 없을 때 empno 값으로 조회하는 경우;
-- emp 테이블에서 pk_empa 제약조건을 삭제해서 empno컬럼으로 인덱스가 존재하지 않는 환경을 조성
ALTER TABLE emp DROP CONSTRAINT PK_empa;
-- tool가서 확인하니까 없어짐
EXPLAIN PLAN FOR
SELECT *
FROM EMP
WHERE empno = 7782; 
--> 값 잘나오는데 실행 계획을 보자

SELECT *
FROM TABLE(dbms_xplan.display);

Plan hash value: 3956160932
 
--------------------------------------------------------------------------
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |     1 |    38 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP  |     1 |    38 |     3   (0)| 00:00:01 |   -- emp 테이블 다읽고
--------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("EMPNO"=7782)                                                  -- WHERE절 조건에서 걸러서 버림
   
   
-- 인덱스가 있을 때
-- 다시 인덱스 생성하기위해 PRIMARY KEY 생성해줌
ALTER TABLE emp ADD CONSTRAINT PK_empa PRIMARY KEY (empno);
--> empno 컬럼으로 UNIQUE 인덱스가 생성

EXPLAIN PLAN FOR
SELECT *
FROM EMP
WHERE empno = 7782; 
--> 값 잘나오는데 실행 계획을 보자

SELECT *
FROM TABLE(dbms_xplan.display);

Plan hash value: 3532656865
 
---------------------------------------------------------------------------------------
| Id  | Operation                   | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
---------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |         |     1 |    38 |     1   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP     |     1 |    38 |     1   (0)| 00:00:01 |
|*  2 |   INDEX UNIQUE SCAN         | PK_EMPA |     1 |       |     0   (0)| 00:00:01 |
---------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("EMPNO"=7782)

SELECT rowid, emp.*
from emp;

SELECT empno, ROWID
FROM emp;
ORDER BY empno; --> 인덱스에 이런 구조로 되어 있음

--SELECT 조회 컬럼이 테이블 접근에 미치는 영향;
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;

EXPLAIN PLAN FOR
SELECT empno 
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE (dbms_xplan.display);

--UNIQUE VS NON-UNIQUE 인덱스 차이 확인
--1. PK_empa 삭제
--2. empno 컬럼으로 NON-UNIQUE 인덱스 생성 (CREATE INDEX idx_n_테이블_몇번째 ON 테이블명 (컬럼명));
--3. 실행계획 확인

ALTER TABLE emp DROP CONSTRAINT PK_empa;

CREATE INDEX idx_n_emp_01 ON emp (empno);
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(dbms_xplan.display);

--INDEX 실습 2
--emp 테이블에 job 컬럼을 기준으로 하는 새로운 non-unique 인덱스를 생성

CREATE INDEX idx_n_emp_02 ON emp(job);

-- 인덱스를 주면 밑 쿼리처럼 구성된다는 소리
SELECT job, ROWID
FROM emp
ORDER BY job;

-- 이런상황에서 밑에 쿼리 조건을 검색해라!
SELECT *
FROM emp
WHERE job = 'MANAGER';
--선택 가능한 상황
--1. EMP 테이블을 전체 읽기
--2. idx_n_emp_01번 인덱스 활용
--3. idx_n_emp_02번 인덱스 활용
-- 근데 우리는 위에 쿼리대로 검색할 수 밖에 없는데 오라클이 실행 계획을 세워서 젤 효율적인 쿼리로 자동 결정해줌




