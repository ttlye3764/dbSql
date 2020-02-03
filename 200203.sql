SELECT *
FROM customer;

SELECT *
FROM CYCLE;

SELECT *
FROM product;

ALL_TABLES;

SELECT *
FROM TAB;

    
-- 판매점 : 200~250
-- 고객당 2.5개 제품
-- 하루 : 500~750
-- 한달 : 15000~17500

SELECT *
FROM daily;

SELECT *
FROM batch;

-- 실습 4번 212
SELECT c1.cid, c1.cnm, c2.pid, c2.day, c2.cnt
FROM customer c1, cycle c2
WHERE c1.cid = c2.cid AND c1.cnm in('brown','sally');

-- 실습 5번 213
SELECT c1.cid, c1.cnm, c2.pid, p.pnm, c2.day, c2.cnt
FROM customer c1, cycle c2, product p
WHERE c1.cid = c2.cid AND c1.cnm in('brown','sally') AND p.pid= c2.pid;

-- 실습 6번 p214 다시한번 해보자잉
SELECT A.CID, A.CNM, A.PID, A.PNM, COUNT(A.PNM)
FROM 
(SELECT cs.cid, cs.cnm, cy.pid, p.pnm, SUM(CY.cnt)
FROM customer cs, cycle cy, product p
WHERE cs.cid = cy.cid AND p.pid= cy.pid) A
GROUP BY A.CID, A.CNM, A.PID, A.PNM, A.CNT
ORDER BY A.CID;

SELECT cs.cid, cs.cnm, cy.pid, p.pnm, CY.cnt
FROM customer cs, cycle cy, product p
WHERE cs.cid = cy.cid AND p.pid= cy.pid;

FROM custome, 

--
-- 해당 오라클 서버에 등록된 사용자(계정) 조회

--SELECT *
--FROM dba_users;
---- HR 계정의 비밀번호를 JAVA로 초기화
--ALTER USER HR IDENTIFIED BY java;
--ALTER USER HR ACCOUNT UNLOCK;

-- 7번까지과제

-- 8번부터 13번까지 hr

--● OUTER JOIN
-- 두 테이블을 조인할때 연결 조건을 만족시키지 못하는 데이터를, 기준으로 지정한 테이블의 데이터만이라도 조회 되게끔 하는 조인 방식

-- 1.조인에 실패하더라도 조회가 될 테이블을 선정
-- 2.

-- 연결조건 : e.mgr = m.empno --> KING의 매니저는 NULL 이기 때문에 조인에 실패한다.
--           emp테이블의 데이터는 총 14이지만 아래와 같은 쿼리에서는 결과가 13건이 된다.(1건이 조인 실패)
SELECT e.empno, e.ename, e.mgr, m.ename "매니저 이름"
FROM emp e, emp m
WHERE e.mgr = m.empno;

-- ○ ANSI OUTER
--조인에 실패하더라도 조회가 될 테이블을 선정(매니저 정보가 없어도 사원정보는 나오게 끔)

SELECT e.empno, e.ename, e.mgr, m.ename "매니저 이름"
FROM emp e LEFT OUTER JOIN emp m ON e.mgr = m.empno;

SELECT e.empno, e.ename, e.mgr, m.ename "매니저 이름"
FROM emp m RIGHT OUTER JOIN emp e ON e.mgr = m.empno;

-- ○ ORCALE OUTER
-- 데이터가 없는 쪽의 테이블 컬럼 뒤에 (+) 기호를 붙여준다.
SELECT e.empno, e.ename, e.mgr, m.ename "매니저 이름", m.deptno
FROM emp e, emp m
WHERE e.mgr = m.empno(+);

-- 위의 SQL을 ANSI SQL(OUTER JOIN)으로 변경

SELECT e.empno, e.ename, e.mgr, m.ename "매니저 이름", m.deptno
FROM emp e LEFT JOIN emp m ON e.mgr = m.empno AND m.deptno=10;

-- 위의 쿼리에서 매니저의 부서번호가 10번인 직원만 조회

SELECT e.empno, e.ename, e.mgr, m.ename "매니저 이름", m.deptno
FROM emp e LEFT OUTER JOIN emp m ON e.mgr = m.empno AND m.deptno = 10;

-- 아래 LEFT OUTER 조인은 실질적으로 OUTER조인이 아니다.
-- 즉, LEFT를 뺴도 결과는 동일하다 -> INNER조인과 결과가 동일
-- --> 조건을 WHERE절에 기술했는지, 
SELECT e.empno, e.ename, e.mgr, m.ename "매니저 이름", m.deptno
FROM emp e LEFT JOIN emp m ON e.mgr = m.empno
WHERE  m.deptno = 10;

SELECT e.empno, e.ename, e.mgr, m.ename "매니저 이름", m.deptno
FROM emp e JOIN emp m ON e.mgr = m.empno
WHERE  m.deptno = 10;

-- ○ 오라클 OUTER JOIN시 

-- 오라클 OUTER JOIN시 기준 테이블의 반대편 테이블의 모든 컬럼에(+)를 붙여야 정상적인 OUTER JOIN으로 동작한다.
-- 한 컬럼이라도 (+)를 누락하면 INNER조인으로 동작
-- 밑 쿼리는 INNER JOIN으로 동작
SELECT e.empno, e.ename, e.mgr, m.ename "매니저 이름", m.deptno
FROM emp e, emp m
WHERE e.mgr = m.empno(+) AND m.deptno=10;

-- 밑 쿼리는 OUTER JOIN으로 동작
SELECT e.empno, e.ename, e.mgr, m.ename "매니저 이름", m.deptno
FROM emp e, emp m
WHERE e.mgr = m.empno(+) AND m.deptno(+)=10;

-- 사원 - 매니저간 RIGHT OUTER JOIN
SELECT empno, ename, mgr
FROM emp e;

SELECT empno, ename
FROM emp m;

SELECT e.empno, e.ename, e.mgr, m.ename "매니저이름"
FROM emp e, emp m
WHERE e.mgr(+) = m.empno(+);

-- ○ FULL OUTER 
--  FULL OTHER : LEFT OUTER + RIGHT OUTER - 중복제거
SELECT e.empno, e.ename, e.mgr, m.ename "매니저 이름", m.deptno
FROM emp e FULL OUTER JOIN emp m ON e.mgr = m.empno;




SELECT *
FROM prod;

SELECT *
FROM buyprod;

-- OUTER JOIN 실습 1
SELECT bp.buy_date, bp.buy_prod, p.prod_id, p.prod_name, bp.buy_qty
FROM buyprod bp, prod p
WHERE bp.buy_prod(+) = p.prod_id 
AND bp.buy_date(+) = TO_DATE('05/01/25','YY/MM/DD');

-- ORACLE OUTER JOIN에서는 (+)를 FULL OUTER 조인에서 제공하지 않는다. ??111



-- OUTER JOIN 2 
-- NULL인 항목을 05/01/25로 채우세여
SELECT NVL(bp.buy_date, TO_DATE('05/01/25','YY/MM/DD')) BUY_DATE, bp.buy_prod, p.prod_id, p.prod_name, bp.buy_qty
FROM buyprod bp, prod p
WHERE bp.buy_prod(+) = p.prod_id 
AND bp.buy_date(+) = TO_DATE('05/01/25','YY/MM/DD');






