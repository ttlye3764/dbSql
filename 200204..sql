
-- 
-- CROSS JOIN ==> 카티션 프로덕트(cartesian product)
-- 조인하는 두 테이블의 연결 조건이 누락되는 경우
-- 가능한 모든 조합에 대해 연결(조인)이 시도


-- dept 테이블과 emp 테이블을 조인 하기 위해 from 절에 두개의 테이블을 기술
-- 단, WHERE절에 두 테이블의 연결 조건을 누락
-- 이렇게 되면 가능한 모든 조합을 출력
SELECT dept.dname, emp.empno, emp.ename
FROM dept, emp;

-- 이게 조건 다 박은거
SELECT dept.deptno, dept.dname, emp.empno, emp.ename
FROM dept, emp
WHERE dept.deptno=10
AND dept.deptno = emp.deptno;

-- CROSS 실습 1
SELECT c.cid, c.cnm, p.pid, p.pnm
FROM customer c, product p
ORDER BY c.cid;

------------------------------------------------join 끝----------------------------------------------------------------------

-- SUBQUERY
-- 쿼리안에 다른 쿼리가 들어가 있는 경우

-- SUBQUERY가 사용된 위치에 따라 크게 3가지로 분류 가능

-- 1. SELECT 절에 들어가는 SUBQUERY : SCALAR SUBQUERY -> 하나의 행, 하나의 컬럼만 리턴해야 에러가 발생하지 않음

-- 2. FROM 절 : INLINE-VIEW (VIEW)

-- 3. WHERE절 : SUBQUERY QUERY




-- 구하고자 하는것
-- SMITH가 속한 부서에 속하는 직원들의 리스트 정보를 조회

-- 1. SMITH가 속하는 부서 번호를 구한다.
SELECT deptno
FROM emp
WHERE ename= 'SMITH';

-- 2. 1번에서 구한 부서 번호에 속하는 직원들 정보를 조회한다.
SELECT *
FROM emp
WHERE deptno = 20;

-- -> 원하는 결과를 얻고자 두번의 쿼리문을 작성했는데 SUBQUERY를 이용하면 한개의 쿼리로 가능
SELECT *
FROM emp
WHERE deptno =  (SELECT deptno
                FROM emp
                WHERE ename= 'SMITH');
                

-- SUBQEURY 실습 2
-- 평균 급여보다 높은 급여를 받는 직원의 수를 조회
-- 1. 평균 급여 얼마 ?
SELECT AVG(sal)
FROM emp;

-- 2. 구한 평균 급여보다 높은 급여를 받는사람 ?
SELECT COUNT(*)
FROM emp
WHERE sal > 2073;

-- 3. 하나로 합치면?
SELECT COUNT(*)
FROM emp
WHERE sal > (SELECT avg(sal)
            FROM emp);
            
            
-- 다중행 연산자   
-- IN : 서브 쿼리의 여러행중 일치하는 값이 존재 할 때
-- ANY [*활용도가 좀 떨어짐 LIKE 용춘] : 서브쿼리의 여러행중 한 행이라도 조건을 만족할 때
-- ALL [*활용도가 좀 떨어짐 LIKE 용춘] : 서브쿼리의 여러행중 모든 행에 대해 조건을 만족할 때

-- 실습 1
-- SMITH가 속하는 부서의 모든 직원을 조회
-- SMITH와 WARD가 속하는 부서의 모든 직원을 조회

-- 1. SMITH와 WARD가 속한 부서번호 조회
SELECT deptno
FROM emp
WHERE ename in('SMITH', 'WARD');

-- 2. 20,30에 해당하는 직원들 조회
SELECT *
FROM emp
WHERE deptno in(20,30);

SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                FROM emp
                WHERE ename in('SMITH', 'WARD'));

-- 실습 3
-- SMITH, WARD 사원의 급여보다 급여가 작은 직원을 조회(SMITH, WARD의 급여중 아무거나)

-- 1. 두 사원 급여 얼마?
SELECT sal
FROM emp
WHERE ename IN('SMITH','WARD');

--2. 비교
SELECT *
FROM emp
WHERE sal < ANY(800,1250);

--3. 합쳐
SELECT *
FROM emp
WHERE sal < ANY(SELECT sal
                FROM emp
                WHERE ename IN('SMITH','WARD'));
               
-- 이번엔 SMITH,WARD 사원의 급여보다 급여가 높은 직원을 조회(SMITH, WARD의 급여 2가지 모두에 대해 높을 때)
-- SMITH  800 
-- WARD : 1250 
--  ==> 1250보다 높은사람
SELECT *
FROM emp
WHERE sal > ALL(SELECT sal
                FROM emp
                WHERE ename IN('SMITH','WARD'));

-- 직원의 관리자 사번이 7902 이거나 null;
SELECT *
FROM emp
WHERE mgr IN(7902) OR mgr IS NULL;

-- 사원 번호가 7902이 아니면서 NULL이 아닌 데이터 == > AND
SELECT *
FROM emp
WHERE mgr NOT IN(7902) AND mgr IS NOT NULL;

-- SUBQUERY 
-- MULTI COLUNM 
-- pairwise(순서쌍) 방법 : 여러 컬럼에 대해 조사
-- 순서쌍의 결과를 동시에 만족 시킬때
-- 실습
-- mgr 7698이면서 deptno 30, mgr이 7839이면서 deptno이 10인 데이터 조회 
SELECT *
FROM emp
WHERE (mgr, deptno) IN (SELECT mgr, deptno
                        FROM emp
                        WHERE empno IN(7499,7782));


SELECT mgr, deptno
FROM emp
WHERE empno IN(7499,7782);

-- 위의 쿼리를 non-pairwise로 만들면
-- mgr 7698이면서 deptno 30, mgr이 7839이면서 deptno이 10인 데이터 조회  --> 앞에보고 수정
SELECT *
FROM emp
WHERE mgr IN (SELECT mgr
              FROM emp
              WHERE empno IN(7499,7782))
AND  deptno IN (SELECT deptno
                FROM emp
                WHERE empno IN(7499,7782));

-- 스칼라 서브쿼리 : SELECT절에 기술, 1개의 ROW, 1개의 COL을 조회하는 쿼리
-- 스칼라 서브쿼리는 MAIN 쿼리의 컬럼을 사용하는게 가능하다.
SELECT (SELECT SYSDATE
        FROM dual), dept.*
FROM dept;

SELECT empno, ename, deptno, (SELECT dname
                              FROM dept
                              WHERE deptno = emp.deptno) dname
FROM emp;


-- INLINE VIEW : FROM 절에 기술되는 서브쿼리
-- 전에 했음

-- 지금까지는 서브쿼리에 등장하는 위치에 따른 분류

-- MAIN 쿼리의 컬럼을 SUBQUERY에서 사용하는지 유무에 따른 분류

-- 1. 사용할 경우 : correalted subquery(상호 연관 쿼리), 서브쿼리만 단독으로 실행 하는게 불가
--           실행 순서가 정해져있다 (main -> sub)

-- 2. 사용하지 않을 경우 : non-correalted subquery, 서브쿼리만 단독으로 실행하는게 가능
--            실행 순서가 정해져 있지 않다 (main -> sub, sub -> main ) 

-- 모든 직원의 급여 평균보다 급여가 높은 사람을 조회
SELECT *
FROM emp
WHERE sal > (SELECT AVG(sal)
             FROM emp);
             
-- 직원이 속한 부서의 급여 평균보다 급여가 높은 사람을 조회
-- 1.직원이 속한 부서번호
SELECT *
FROM EMP;

SELECT *
FROM TAB;




FROM emp
GROUP BY deptno;
-- 2. 구한 부서번호의 급여 평균
SELECT AVG(sal)
FROM emp
GROUP BY deptno;
--3. 급여가 높은사람

SELECT *
FROM emp e, emp m 
WHERE e.deptno = m.deptno AND sal > SELECT AVG(sal)
                                     FROM emp
                                     GROUP BY deptno;
                                     
                                     SELECT AVG(sal)
                                     FROM emp
                                     GROUP BY deptno;
SELECT *
FROM emp e
WHERE sal > (SELECT AVG(sal)
            FROM emp m
            WHERE e.deptno = m.deptno);
-----------------------------------------------------------
SELECT e.empno, e.ename, e.sal, round(m.A,0) AVG
FROM emp e,(SELECT AVG(sal) A, deptno
        FROM emp
        GROUP BY deptno) m
WHERE e.deptno = m.deptno AND SAL > A;


SELECT *
FROM (SELECT *
FROM emp e
WHERE sal > (SELECT AVG(sal)
            FROM emp m
            WHERE e.deptno = m.deptno)) B,
(SELECT e.empno, e.ename, e.sal, round(m.A,0) AVG
FROM emp e,(SELECT AVG(sal) A, deptno
        FROM emp
        GROUP BY deptno) m
WHERE e.deptno = m.deptno AND SAL > A) C
WHERE B.empno = C.empno ;


--------------------------------------------------------------------------------------------
-- INSERT (데이터 추가)
-- INSERT INTO 테이블 VALUES (데이터값)

--INSER INTO dept VALUES(99,'ddit','daejeon');
-- ROLLBACK -> 트랜잭션 취소
-- COMMIT -> 트랜잭션 확정

INSERT INTO dept VALUES(99,'ddit','daejeon');

COMMIT;

-- SUBQUERY실습 4
-- dept 테이블에는 신규 등록된 99번 부서에 속한 사람은 없음 직원이 속하지 않은 부서를 조회하는 쿼리를 작성해보세요
SELECT *
FROM dept
where deptno NOT IN(SELECT deptno
                     FROM emp);
                     
SELECT *
FROM (SELECT d.deptno deptnod, d.dname dname, d.loc loc, e.deptno deptnoe
      FROM dept d, emp e
      WHERE d.deptno = e.deptno (+))a
WHERE deptnoe is null;
                     





    
    









