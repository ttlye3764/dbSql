-- ● JOIN (★★★★★★★★★★★★★★★)
-- 중복을 최소화 하는 RDBMS 방식
-- 두 테이블간을 연결하는 작업

-- ○ JOIN 문법
--     1. ANSI 문법
--     2. ORACLE 문법

-- ◇ ANSI : Natural Join
-- 두 테이블간 컬럼명이 같을 때 해당 컬럼으로 연결(조인)
-- emp, dept 테이블에는 deptno라는 공통된 컬럼이 존재
SELECT *
FROM emp NATURAL JOIN dept;

SELECT emp.empno, emp.ename -- 해당 테이블.컬럼명 으로 명시적으로 입력해주는게 좋음
FROM emp NATURAL JOIN dept;

-- deptno라는 공통된 컬럼으로 조인했기 때문에 이 컬럼은 앞에 한정자를 써줄수 없다 -> 쓰면 에러남
-- 컬럼명만 기술(dept.deptno - > deptno)
SELECT emp.empno, emp.ename, dept.dname, dept.deptno 
FROM emp NATURAL JOIN dept;

-- 한정자 빼면 에러안남
SELECT emp.empno, emp.ename, dept.dname, deptno 
FROM emp NATURAL JOIN dept;

-- 테이블에 대한 별칭도 사용가능
SELECT e.empno, e.ename, d.dname, deptno 
FROM emp e NATURAL JOIN dept d;

-- ◇ ORACLE JOIN

-- FROM절에 조인할 테이블 목록을 ,로 구분하여 나열한다.
-- 조인할 테이블의 연결 조건을 WHERE절에 기술한다.
-- emp, dept 테이블에 존재하는 deptno 컬럼이 [같을 때] 조인

SELECT e.empno, e.ename
FROM emp e, dept d
WHERE e.deptno = d.deptno;

SELECT e.ename, d.dname
FROM emp e, dept d
WHERE e.deptno != d.deptno;

-- ORACLE JOIN (,) 에서는 한정자를 정확히 적어줘야함 (Naturaljoin과 차이점)
SELECT e.empno, e.ename, deptno -- 한정자를 안써줬기 때문에 에러
FROM emp e, dept d
WHERE e.deptno = d.deptno;

SELECT e.empno, e.ename, e.deptno -- 한정자를 적어줘서 실행
FROM emp e, dept d
WHERE e.deptno = d.deptno;

-- ○ join with USING
-- 조인하려는 두개의 테이블에 이름이 같은 컬럼이 두개이지만 하나의 컬럼으로만 조인을 하고자 할때
-- 조인하는 기준 컬럼을 기술

-- ◇ ANSI 문법
-- emp, dept 테이블의 공통 컬럼 : deptno
SELECT emp.ename, dept.dname, deptno
FROM emp JOIN dept USING(deptno);

-- ◇ ORACLE 문법
SELECT emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

-- 여기까지는 조인하려는 두 테이블간에 동일한 컬럼명이 같을떄

-- ○ join with ON
-- 조인하려고 하는 테이블의 컬럼의 이름이 서로 다를 때

-- ◇ ANSI 문법
SELECT emp.ename, dept.dname, emp.deptno
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

-- ◇ ORACLE 문법
SELECT emp.ename, dept.dname, emp.deptno
FROM emp, dept
WHERE emp.deptno = dept.deptno;

-- ○ SELF JOIN
-- 같은 테이블간 조인
-- 예제) emp 테이블에서 관리되는 사원의 관리자 사번을 이용하여 관리자 이름을 조회
-- 같은 테이블 두개를 각각 구분해 주기 위해 ALIES를 반드시 붙여주고 한정자를 사용해 주어야 함.

-- ◇ ANSI 문법
SELECT e.emp1no, e.ename, m.empno, m.ename
FROM emp e JOIN emp m ON (e.mgr = m.empno);

-- ◇ ORACLE 문법
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno;

-- ○ equal 조인 : =
-- ○ non - equal 조인 : !=, >, <, BETWEEN AND 등등 (논리, 범위 등)

SELECT ename, sal
FROM emp;

SELECT *
FROM salgrade;

--위의 두개 테이블을 이용해서 등급을 매겨라

-- ◇ ANSI 문법
SELECT e.ename, e.sal, s.grade
FROM emp e join salgrade s on(e.sal BETWEEN S.losal AND S.hisal);


-- e.sal 값을s.losal~s.hisal과 비교해서 사이에있는 grade를 출력

-- ◇ ORALCE 문법
SELECT e.ename, e.sal, s.grade
FROM emp e, salgrade s
WHERE e.sal BETWEEN S.losal AND S.hisal;

-- JOIN 실습
-- 1. emp, dept 테이블을 이용하여 다음과 같이 조회되도록 쿼리작성

SELECT e.empno, e.ename, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
ORDER BY deptno;

--2. 
SELECT e.empno, e.ename, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno AND d.deptno !=20 
ORDER BY deptno;

--3.
SELECT e.empno, e.ename,e.sal, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno AND e.sal >2500
ORDER BY deptno;

--4.
SELECT e.empno, e.ename,e.sal, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno AND e.sal >2500 AND e.empno >7600
ORDER BY deptno;

--5.
SELECT e.empno, e.ename,e.sal, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno AND e.sal >2500 AND e.empno >7600 AND d.Dname='RESEARCH'
ORDER BY deptno;

--새로운 테이블로
--
SELECT l.lprod_gu, l.lprod_nm, p.prod_id, p.prod_name
FROM prod p, lprod l
WHERE p.prod_lgu = l.lprod_gu;

SELECT b.buyer_id, b.buyer_name, p.prod_id, p.prod_name
FROM prod p, buyer b
WHERE P.prod_buyer = b.buyer_id;
-- 과제
SELECT *
FROM member m, cart c, prod p
WHERE (m.mem_id = c.cart_member) AND (c.cart_prod = p.prod_id);
 
SELECT *
FROM EMP;

SELECT *
FROM dept;
-----------
SELECT *
FROM prod;

SELECT *
FROM lprod;



