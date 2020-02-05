-- SUBQUERY
-- dept 테이블에는 5건의 데이터가 존재
-- emp 테이블에는 14명의 직원이 있고, 직원은 하나의 부서에 속해 있다.(deptno)
-- 부서중 직원이 속해 있지 않은 부서 정보를 조회;

-- 서브쿼리에서 데이터의 조건이 맞는지 확인자 역할을 하는 서브쿼리 작성


SELECT *
FROM dept
WHERE deptno NOT IN(SELECT deptno
                    FROM emp);

SELECT deptno
FROM emp;

SELECT *
FROM dept
WHERE deptno NOT IN(SELECT DISTINCT deptno
                    FROM emp);

SELECT *
FROM cycle;

SELECT *
FROM product;
-- SUBQUERY 5번
SELECT *
FROM product
WHERE pid  in(  SELECT pid
                 FROM cycle
                 WHERE cid = 1);
                 
--SUBQUERY 6

SELECT *
FROM cycle;

-- cid=2인 고객이 애음하는 제품
-- 위의 결과에서 cid=1인 고객도 이용하는 제품
SELECT *
FROM cycle
WHERE cid = 1 and pid  in (SELECT pid
                            FROM cycle
                            WHERE cid = 2);

-- customer, cycle, product 테이블을 이용하여 cid=2인 고객이 애음하는 제품중 cid=1 인 고객도 애음하는 제품의 애음정보를
-- 조회하고 고객명과 제품명 까지 포함하는 쿼리를 작성하세요
SELECT *
FROM customer;

-------- 해보자
SELECT a.cid, a.pid,  a.day, a.cnt
FROM (SELECT *
            FROM cycle c
            WHERE cid = 1 and pid  in (SELECT pid
                                        FROM cycle
                                    WHERE cid = 2)) a, customer, product
WHERE a.cid = customer.cid
AND a.pid = product.pid;


        
---  CROSS 조인사용
SELECT cycle.cid, customer.cnm, cycle.pid, product.pnm, cycle.day, cycle.cnt
FROM cycle, customer, product
WHERE cycle.cid = 1
AND cycle.pid in(SELECT pid
            FROM cycle
            WHERE cid = 2)
AND cycle.cid = customer.cid
AND cycle.pid = product.pid;






SELECT *
FROM cycle c
WHERE cid = 1 and pid  in (SELECT pid
                            FROM cycle
                            WHERE cid = 2);

-- CID=2인 고객이 애음하는 제품


SELECT *
FROM ;

select *
from emp;

--  SUBQUERY 
-- 매니저가 존재하는 직원을 조회 KING을 제외한 13명의 데이터가 조회

SELECT *
FROM emp
WHERE mgr IS NOT NULL;

-- ○ 서브 쿼리 EXISTS연산자

-- EXSITS 조건에 만족하는 행이 존재 하는지 확인하는 연산자
-- 다른 연산자와 다르게 WHERE절에 컬럼을 기술하지 않는다.
-- WHERE = empno = 7369
-- WHERE EXISTS (SELECT 'X'
--               FORM ..)

-- 매니저가 존재하는 직원을 EXISTS 연산자를 통해 조회
-- 매니저도 직원

SELECT *
FROM emp e
WHERE EXISTS(SELECT 'X'
             FROM emp m
             where e.mgr = m.empno);
             
-- SUBQUERY 실습 9번

-- cycle, product 테이블을 이용하여 cid=1인 고객이 애음하는 제품을 조회하는 쿼리를 exists 연산자를 이용하여 작성
-- cid=1인 고객이 애음하는 제품
SELECT pid
FROM cycle
WHERE cid =1;

SELECT *
FROM product
WHERE pid IN (SELECT pid
            FROM cycle
            WHERE cid =1) ;
            
SELECT *
FROM product
WHERE EXISTS (SELECT 'X'
             FROM cycle
             WHERE cid =1 
             AND product.pid = cycle.pid) ;

--SUBQUERY 실습 10번
SELECT *
FROM product
WHERE NOT EXISTS (SELECT 'X'
             FROM cycle
             WHERE cid =1 
             AND product.pid = cycle.pid) ;

-------------------------------------------------------------
-- ● 집합연산

-- 합집합 : UNION - 중복제거 / UNION ALL 중복제거하지 않음
-- 교집합 : INTERSECT 
-- 차집합 : MINUS (집합개념)
-- 집합연산 공통사항
-- 두 집합의 컬럼 개수, 타입이 일치해야 하낟.

SELECT empno, ename
FROM emp
WHERE empno IN(7566,7698)

UNION ALL -- 중복 허용

SELECT empno, ename
FROM emp
WHERE empno IN(7566,7698);

-------------------교집합

SELECT empno, ename
FROM emp
WHERE empno IN(7566,7698,7369)

INTERSECT

SELECT empno, ename
FROM emp
WHERE empno IN(7566,7698);

-------------------차집합

SELECT empno, ename
FROM emp
WHERE empno IN(7566,7698,7369)

MINUS

SELECT empno, ename
FROM emp
WHERE empno IN(7566,7698);

-- 집합의 기술 순서가 영향이 가는 집합연산자

-- A UNION B       B UNION A --> 같음
-- A UNION ALL B   B UNION ALL A --> 같음(집합 개념한정)
-- A INTERSECT B   B INTERSECT A  --> 같음
-- A MIUNS B       B MINUS A   --> 다름]


-- 집합연산의 결과 컬럼 이름은 첫번째 집합의 컬럼명을 따른다
SELECT 'X' fir, 'b' sec
FROM dual

UNION

SELECT 'X' t, 'b' f
FROM dual;


--정렬(ORDER BY)는 집합연산 가장 마지막 집합 다음에 기술

SELECT deptno, dname, loc
FROM dept 
WHERE deptno IN (10,20)

UNION

SELECT *
FROM dept
WHERE deptno IN (30,40)

ORDER BY deptno;


-- 시도 시군구, 버거지수
SELECT f.sido, f.sigungu, f.gb
FROM fastfood f, tax t
WHERE concat(f.SIDO, f.sigungu)  = concat(t.sido, t.sigungu)
ORDER BY f.id;

-- 버거킹 + kfc + 맥도날드 / 롯데리아


-- 최종

SELECT a.sido, A.sigungu, gb, COUNT(*)
FROM (SELECT f.sido, f.sigungu, f.gb
    FROM fastfood f, tax t
    WHERE concat(f.SIDO, f.sigungu)  = concat(t.sido, t.sigungu)) A
GROUP BY a. sido, a.sigungu, A.gb
ORDER BY SIGUNGU;

SELECT B.sido, B.sigungu
FROM (
        SELECT a.sido, A.sigungu, gb, COUNT(*)
        FROM (SELECT f.sido, f.sigungu, f.gb
                FROM fastfood f, tax t
                WHERE concat(f.SIDO, f.sigungu)  = concat(t.sido, t.sigungu)) A
        GROUP BY a. sido, a.sigungu, A.gb
        ORDER BY SIGUNGU) B;






SELECT a.sido, A.sigungu, COUNT(*)
FROM (SELECT f.sido, f.sigungu, f.gb
    FROM fastfood f, tax t
    WHERE concat(f.SIDO, f.sigungu)  = concat(t.sido, t.sigungu)) A
GROUP BY a. sido, a.sigungu
ORDER BY SIGUNGU;


SELECT A.SIDO, A.SIGUNGU, ROUND(B.AA/A.AA, 1) "지수"
FROM
    (SELECT f.sido, f.sigungu, COUNT(*) AA
    FROM fastfood f, tax t
    WHERE concat(f.SIDO, f.sigungu)  = concat(t.sido, t.sigungu)
    AND f.gb ='롯데리아'
    GROUP BY f.sido, f.sigungu
    ORDER BY SIGUNGU)A,

    (SELECT f.sido, f.sigungu, COUNT(*)AA
    FROM fastfood f, tax t
    WHERE concat(f.SIDO, f.sigungu)  = concat(t.sido, t.sigungu)
    AND f.gb IN ('KFC','맥도날드','버거킹')
    GROUP BY f.sido, f.sigungu
    ORDER BY SIGUNGU) B
WHERE concat(A.SIDO, A.sigungu)  = concat(B.sido, B.sigungu);






SELECT f.sido, f.sigungu, COUNT(*)/(SELECT f.sido, f.sigungu, COUNT(*)
                                    FROM fastfood f, tax t
                                    WHERE concat(f.SIDO, f.sigungu)  = concat(t.sido, t.sigungu)
                                    AND f.gb ='롯데리아'
                                    GROUP BY f.sido, f.sigungu
                                    ORDER BY SIGUNGU)
FROM fastfood f, tax t
WHERE concat(f.SIDO, f.sigungu)  = concat(t.sido, t.sigungu)        
AND f.gb !='롯데리아'
GROUP BY f.sido, f.sigungu
ORDER BY SIGUNGU;






SELECT f.sido, f.sigungu, COUNT(*)/(SELECT SELECT f.sido, f.sigungu, COUNT(*)/(SELECT )
                                    FROM fastfood f, tax t
                                    WHERE concat(f.SIDO, f.sigungu)  = concat(t.sido, t.sigungu)        
                                    AND f.gb ='롯데리아'
                                    GROUP BY f.sido, f.sigungu
                                    ORDER BY SIGUNGU)
FROM fastfood f, tax t
WHERE concat(f.SIDO, f.sigungu)  = concat(t.sido, t.sigungu)
AND f.gb !='롯데리아'
GROUP BY f.sido, f.sigungu
ORDER BY SIGUNGU;





SELECT COUNT(*)
FROM fastfood
ㅈGB ='롯데리아';

SELECT *
FROM fastfood;

SELECT *
FROM TAX;

