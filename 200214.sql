
REPROT GROUP FUNCTION

1. ROLLUP
2. CUBE
3. GROUPING SETS

활용도
3, 1 >>>>>>>>>>>>>>>>>>>>>>>>>>>>> CUBE


GROUPING SETS
 순서와 상관없이 서브 그룹을 사용자가 직접 선언
 사용방법 : GROUP BY GROUPING SETS(col1, col2, ...)
 
GROUP BY GROUPING SETS(col1, col2, ...)
 ==> GROUP BY col1
     UNION ALL
     GROUP BY col2 와 같다.
     
GROUP BY GROUPING SETS( (co1, co2), col3, col4)

==> GROUP BY col1, col2
    UNION ALL
    GROUP BY col3
    UNION ALL
    GROUP BY col4;
    
    
--GROUPING SETS의 경우 컬럼 기술 순서과 결과에 영향을 미치지 않는다.
--  * ROLLUP은 컬럼 기술 순서가 결과에 영향을 미친다.
  
GROUP BY  GROUPING SETS(col1, col2)
==> GROUP BY col1
    UNION 
    GROUP BY col2
    
GROUP BY  GROUPING SETS(col2, col1)
==> GROUP BY col2
    UNION 
    GROUP BY col1

--실습    
SELECT job, deptno, SUM(sal) sal
FROM emp
GROUP BY GROUPING SETS(job, deptno);
==> 동일
GROUP BY job
UNION 
GROUP BY deptno;

job, deptno로 GROUP BY한 결과와 
mgr로 GROUP BY 한 결과를 조회하는 SAQL을 GROUPING SETS로 급여합 SUM(sal) 작성

SELECT job, deptno
FROM emp
GROUP BY job, deptno;

SELECT mgr
FROM emp
GROUP BY mgr;

SELECT job, deptno, mgr, SUM(sal)
FROM emp
GROUP BY GROUPING SETS ((job,deptno),mgr);


CUBE 
가능한 모든 조합으로 컬럼을 조합한 SUB GROUP 을 생성한다.

 GROUP BY CUBE(col1, col2);
 
 (col1, col2) ==>
 
 (null, col2) == GROUP BY col2
 (null, null) == GROUP BY 전체
 (col1, null) == GROUP BY col1
 (col1, nul2) == GROUP BY col1, col2;
 
 SELECT job, deptno, SUM(sal) sal
 FROM emp
 GROUP BY CUBE(job, deptno);
 
    		29025  -> null
        10	8750   -> deptno
        20	10875
        30	9400
CLERK		4150   -> job
CLERK	10	1300   -> job, deptno
CLERK	20	1900
CLERK	30	950
ANALYST		6000
ANALYST	20	6000
MANAGER		8275
MANAGER	10	2450
MANAGER	20	2975
MANAGER	30	2850
SALESMAN		5600
SALESMAN	30	5600
PRESIDENT		5000
PRESIDENT	10	5000

SELECT job, deptno, mgr, SUM(sal) sal
FROM emp
GROUP BY job, ROLLUP(deptno), CUBE(mgr);



==> GROUP BY job, deptno, mgr == GROUP BY job, deptno, mgr
==> GROUP BY job, deptno == GROUP BY job, deptno = 
==> GROUP BY job, null, mgr == GROUP BY job, mgr
==> GROUP BY null, null == GROUP BY job


 서브쿼리 UPDATE
 1. emp_test 테이블 DROP
 2. emp 테이블을 이용해서 emp_test테이블 생성(모든 행에 대해 CTAS)
 3. emp_test 테이블에 dname VARCHAR2(14) 컬럼추가
 4. emp_test.dname 컬럼을 dept 테이블을 이용해서 부서명을 업데이트;
 
 -- emp_test 테이블 삭제
 DROP TABLE emp_test;
 
 -- emp테이블에서 CTAS로 emp_test테이블 생성
 CREATE TABLE emp_test AS
 SELECT *
 FROM emp;
 
 -- 테이블 조회
 SELECT *
 FROM emp_test;
 
 -- emp_test 테이블에 dname VARCHAR2(14) 삽입
 ALTER TABLE emp_test ADD(dname VARCHAR2(14));
 
 -- emp_test 테이블에 dname 데이터 삽입 (dept테이블 이용)
 UPDATE emp_test SET dname = (SELECT dname
                              FROM dept
                              WHERE dept.deptno = emp_test.deptno);
                              
 
 --dept 테이블을 삭제
 DROP  TABLE dept_test;
 --dept 테이블을 이용하여 dept_test 테이블생성
 CREATE TABLE dept_test AS
 SELECT *
 FROM dept;
 -- 컬럼 삽입
 ALTER TABLE dept_test ADD(dmpcnt NUMBER);
 -- 데이터 업데이트
 UPDATE dept_test SET dmpcnt = (SELECT count(deptno)
                                FROM emp
                                WHERE emp.deptno = dept_test.deptno);
                                
sub_a2;
dept_test 테이블에 있는 부서중에 직원이 속하지 않은 부서정보를 삭제
 *dept_test.dmpcnt 컬럼은 사용하지 않고
INSERT INTO dept_test VALUES(99, 'it1' ,'daejeon',0);
INSERT INTO dept_test VALUES(98, 'it1' ,'daejeon',0);

--ALTER TABLE dept_test DROP COLUMN (
SELECT *
FROM dept_test
WHERE deptno NOT IN (SELECT deptno
                FROM emp
                WHERE dept_test.deptno = emp.deptno));
                
DELETE FROM dept_test
WHERE IN(
        SELECT deptno
        FROM dept_test
        WHERE deptno NOT IN (SELECT deptno
                            FROM emp
                            WHERE dept_test.deptno = emp.deptno));
                


SELECT ename
FROM emp
WHERE deptno != (SELECT deptno
                FROM dept_test
                WHERE emp.deptno = dept_test.deptno);



                SELECT *
                FROM dept_test;
                
                SELECT *
                FROM EMP;
                

emp 테이블을 이용하여 emp_test 테이블 생성
SUBQUERY를 이용하여 emp_test 테이블에서 본인이 속한 부서의 평균 급여보다 급여가 작은
직원의 급여를 현 급여에서 200을 추가해서 업데이트 하는 쿼리를 작성하세요

UPDATE emp_test SET sal = sal + 200
WHERE emp_test.empno in
(SELECT empno
FROM emp_test a
WHERE sal  <(
            SELECT ROUND(AVG(sal),2)
            FROM emp_test b
            WHERE a.deptno = b.deptno
            GROUP BY deptno));
SELECT *
FROM EMP_TEST;


MERGE INTO emp_test a
    USING (SELECT empno
          FROM emp_test a
          WHERE sal  <(
                       SELECT ROUND(AVG(sal),2)
                         FROM emp_test b
                        WHERE a.deptno = b.deptno
                        GROUP BY deptno)) b
    ON (a.empno = b.empno)
    WHEN MATCHED THEN
        UPDATE SET a.sal = a.sal+200;
        
        SELECT *
        FROM EMP_TEST;
        

SELECT *
FROM EMP_TEST;
 
-- ○ WITH절
-- 하나의 쿼리에서 반복되는 서브쿼리가 있을 때 해당 SUBQUERY를 별도로 선언해여 재사용
-- MAIN쿼리가 실행될 때 WITH 선언한 쿼리 블럭이 메모리에 임시적으로 저장
--  ==> MAIN 쿼리가 종료되면 메모리 해제

-- SUBQUERY 작성시에는 해당 SUBQUERY의 결과를 조회하기 위해서 I/O가 반복적으로 일어나지만
-- WITH절을 통해 선언하면 한번만 SUBQUERY가 실행되고 그 결과를 메모리에 저장해 놓고 재사용
-- 단, 하나의 쿼리에서 동일한 SUBQUERY가 반복적으로 나오는 것은 잘못 작성한 쿼리일 가능성이 높음

-- WITH 쿼리블록이름 AS(
--    서브쿼리
-- )
-- SELECT *
-- FROM 쿼리블록 이름

직원의 부서별 급여 평균을 조회하는 쿼리블록을 WITH절을 통해 선언

WITH sal_avg_dept AS(
    SELECT deptno, ROUND(AVG(sal), 2) sal
    FROM emp
    GROUP BY deptno
),
   dept_empcnt AS(
    SELECT deptno, COUNT(*) empcnt
    FROM emp
    GROUP BY deptno)

SELECT *
FROM sal_avg_dept a, dept_empcnt b
WHERE a.deptno = b.deptno;

--사용 예
--가짜 데이터를 만들때 사용
WITH temp AS (
    SELECT sysdate - 1 FROM dual UNION ALL
    SELECT sysdate - 2 FROM dual UNION ALL
    SELECT sysdate - 3 FROM dual)
SELECT *
FROM temp;


-- 달력 만들기
SELECT *
FROM dual;  --> 1개 행

--CONNECT BY LEVEL <[=] 정수
--해당 테이블의 행을 정수만큼 복제하고, 복제된 행을 구별하기 위해서 LEVEL을 부여
--LEVEL은 1부터 시작

SELECT dummy, LEVEL
FROM dual  
CONNECT BY LEVEL <=10 ;

SELECT dept.*, LEVEL
FROM dept
CONNECT BY LEVEL <=5
ORDER BY LEVEL;

2020년 2월의 달력을 생성
:dt = 202002, 202003
1.해당 월의 일자만큼 LEVEL생성

SELECT TO_DATE('202003','YYYYMM') + (LEVEL-1)
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY( TO_DATE('202003','YYYYMM')),'DD');

2. 일 월 화 수 목 금 토


SELECT TO_DATE('202003','YYYYMM') + (LEVEL-1),
       TO_CHAR(TO_DATE('202003','YYYYMM') + (LEVEL-1),'D'),
       DECODE(TO_CHAR(TO_DATE('202003','YYYYMM') + (LEVEL-1),'D'), 1,TO_DATE('202003','YYYYMM') + (LEVEL-1)) s,
       DECODE(TO_CHAR(TO_DATE('202003','YYYYMM') + (LEVEL-1),'D'), 2,TO_DATE('202003','YYYYMM') + (LEVEL-1)) s,
       DECODE(TO_CHAR(TO_DATE('202003','YYYYMM') + (LEVEL-1),'D'), 3,TO_DATE('202003','YYYYMM') + (LEVEL-1)) s,
       DECODE(TO_CHAR(TO_DATE('202003','YYYYMM') + (LEVEL-1),'D'), 4,TO_DATE('202003','YYYYMM') + (LEVEL-1)) s,
       DECODE(TO_CHAR(TO_DATE('202003','YYYYMM') + (LEVEL-1),'D'), 5,TO_DATE('202003','YYYYMM') + (LEVEL-1)) s,
       DECODE(TO_CHAR(TO_DATE('202003','YYYYMM') + (LEVEL-1),'D'), 6,TO_DATE('202003','YYYYMM') + (LEVEL-1)) s,
       DECODE(TO_CHAR(TO_DATE('202003','YYYYMM') + (LEVEL-1),'D'), 7,TO_DATE('202003','YYYYMM') + (LEVEL-1)) s
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY( TO_DATE('202003','YYYYMM')),'DD');



SELECT TO_CHAR(LAST_DAY( TO_DATE('202003','YYYYMM')),'DD')
FROM dual;

D : 요일
SELECT TO_CHAR(LAST_DAY( TO_DATE('202003','YYYYMM')),'D')
FROM dual;

-- 중요점 : 행을 열로 바꾸는것
-- 레포트 쿼리에서 많이 사용됌

사전 지식 : 




    
    