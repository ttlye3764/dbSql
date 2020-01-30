-- emp 테이블을 이용하여 deptno에 따라 부서명으로 변경해서 조회
SELECT empno, ename,
       CASE 
            WHEN deptno=10 THEN 'ACCOUNTING'
            WHEN deptno=20 THEN 'RESEARCH'
            WHEN deptno=30 THEN 'SALES'
            WHEN deptno=40 THEN 'OPERATIONS'
            ELSE 'DDIT'
        END dname
FROM emp;

-- 올해년도가 짝수, 입사 달이 짝수 -> 건강검진 대상자
-- 올해년도가 짝수, 입사 달이 홀수 - > 비대상자
-- 올해년도가 홀수, 입사 달이 홀수 -> 대상자
-- 올해년도가 홀수, 입사 달이 짝수 - > 비대상자

-- 내가 짠거
SELECT empno, ename, hiredate,
        CASE 
            WHEN  MOD( TO_NUMBER(TO_CHAR(hiredate, 'MM')), 2) =0 AND MOD (TO_NUMBER(TO_CHAR(SYSDATE, 'yyyy')),2)=0 THEN '건강검진 대상자'
            WHEN  MOD( TO_NUMBER(TO_CHAR(hiredate, 'MM')), 2) =0 AND MOD (TO_NUMBER(TO_CHAR(SYSDATE, 'yyyy')),2)!=0 THEN '건강검진 비대상자'
            WHEN  MOD( TO_NUMBER(TO_CHAR(hiredate, 'MM')), 2) !=0 AND MOD (TO_NUMBER(TO_CHAR(SYSDATE, 'yyyy')),2)!=0 THEN '건강검진 대상자'
            WHEN  MOD( TO_NUMBER(TO_CHAR(hiredate, 'MM')), 2) !=0 AND MOD (TO_NUMBER(TO_CHAR(SYSDATE, 'yyyy')),2)=0 THEN '건강검진 비대상자'
        END contact_to_doctor
FROM emp;

--선생님이 짠거 (입사년도가 짝수, 현재년도가 짝수 -> 대상자)
SELECT empno, ename, hiredate,
        CASE 
            WHEN  MOD( TO_NUMBER(TO_CHAR(hiredate, 'yyyy')), 2) = MOD(TO_NUMBER(TO_CHAR(SYSDATE, 'yyyy')),2) THEN '건강검진 대상자'
            ELSE '건강검진 비대상자'
        END contact_to_doctor
        --DECODE로만 짜보자
FROM emp;


-- 
--
SELECT empno, ename, hiredate, 
                        case 
                            when mod(to_char(sysdate,'yy'),2) = 0 then (DECODE(to_number(mod(to_char(hiredate,'yymm'),2)),0,'건강검진 대상자',1,'건강검진 비대상자'))
                        else (DECODE(mod(to_char(hiredate,'yymm'),2),1,'건강검진 대상자',0,'건강검진 비대상자'))
                        end CONTACT_TO_DOCTOR                                                                            
FROM emp;

SELECT deptno
FROM emp;

-----------------------------------------------------------------

-- Function 
-- ● 그룹 함수
-- group function = multi row function
-- 여러개의 행이 한번에 input 되서 하나의 결과(output)로 나오는거

SELECT *
FROM emp;

SELECT *
FROM dept;

-- GROUP BY 행을 묶을 기준
-- 부서번호 같은 ROW끼리 묶는 경우 : GROUP BY deptno
-- 담당업무가 같은 ROW끼리 묶는 경우 : GROUP BY job
-- MGR이 같고 담당업무가 같은 ROW 끼리 묶는 경우 : GROUP BY mgr. job
-- 그니깨 GROUP BY deptno; 이렇게 하면  deptno이 같은 데이터들의 행은 하나의 행으로 조회 됨

-- 그룹함수의 종류
-- SUM : 합계
-- COUNT : 갯수 - NULL이 아닌 ROW의 개수
-- MAX : 최대
-- MIN : 최소
-- AVG : 평균

-- 그룹함수의 특징
-- 해당 컬럼에 NULL값을 갖는 ROW가 존재할 경우 해당 값은 무시하고 계산한다. (NULL에 대한 연산의 결과는 NULL이기 때문에 무시)

-- 부서별 급여 합
SELECT deptno, 
       SUM(sal) sum_sal, MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal, COUNT(sal) count_sal
FROM emp
GROUP BY deptno;

-- 그룹함수 주의점
-- GROUP BY절에 나온 컬럼 이외의 다른컬럼이 SELECT절에 표현되면 에러
-- 밑에가 에러인 예제
SELECT deptno, ename,
       SUM(sal) sum_sal, MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal, COUNT(sal) count_sal
FROM emp
GROUP BY deptno;

-- SELECT절에 나온 컬럼과 GROUP BY절의 컬럼을 일치 시켜줘야 한다.(그룹함수 내의 다른 컬럼은 제외)
-- 올바른 예제
SELECT deptno, ename,
       SUM(sal) sum_sal, MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal, COUNT(sal) count_sal
FROM emp
GROUP BY deptno, ename;

-- GROUP BY절이 없는 상태에서 그룹함수를 사용한 경우
-- -> 이 때는 전체 행을 하나의 행으로 묶는다는 개념 그럼 결과는 한 행으로 나온다.
-- -> 전체사원의 sal 합, 전체사원의 sal 최대값, ... 등등
SELECT SUM(sal) sum_sal, MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal, 
       COUNT(sal) count_sal, -- sal 컬럼의 값이 NULL이 아닌 ROW의 개수
       COUNT(comm), -- comm 컬럼의 값이 NULL이 아닌 ROW의 개수
       COUNT(*)  -- 몇건의 데이터가 있는지 ----> COUNT 그룹함수의 경우에만 아스타리스크(*) 사용가능
FROM emp;

-- 이때 SELECT에 컬럼을 적어주면 에러
SELECT ename,
       SUM(sal) sum_sal, MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal, COUNT(sal) count_sal
FROM emp;

--GROUP BY의 기준이 empno이면 
SELECT SUM(sal) sum_sal, MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal, 
       COUNT(sal) count_sal, -- sal 컬럼의 값이 NULL이 아닌 ROW의 개수
       COUNT(comm), -- comm 컬럼의 값이 NULL이 아닌 ROW의 개수
       COUNT(*)  -- 몇건의 데이터가 있는지 ----> COUNT 그룹함수의 경우에만 아스타리스크(*) 사용가능
FROM emp
GROUP BY empno;

-- 그룹화와 관련없는 임의의 문자열, 함수, 숫자 등은 SELECT절에 나오는 것이 가능
SELECT 1, SYSDATE, 'DDD',
       SUM(sal) sum_sal, MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal, 
       COUNT(sal) count_sal, -- sal 컬럼의 값이 NULL이 아닌 ROW의 개수
       COUNT(comm), -- comm 컬럼의 값이 NULL이 아닌 ROW의 개수
       COUNT(*)  -- 몇건의 데이터가 있는지 ----> COUNT 그룹함수의 경우에만 아스타리스크(*) 사용가능
FROM emp
GROUP BY empno;

-- ○ HAVING 절
-- SINGLE ROW FUNCTION의 경우 WHERE 절에서 사용하는 것이 가능하나
-- GROUP FUNCTION의 경우 WHERE절에서 사용하는 것이 불가능 하고
-- HAVING 절에서 조건을 기술한다.


-- 예제) 부서별 급여 합 조회, 단 급여 합이 9000이상인 ROW만 조회
SELECT deptno, SUM(sal) sum_sal
FROM emp
GROUP BY deptno
HAVING SUM(sal) > 9000;

SELECT *
FROM EMP;

-- 실습1
SELECT MAX(sal), MIN(sal), ROUND(AVG(sal),2), SUM(sal), COUNT(sal), COUNT(mgr), COUNT(*)
FROM emp;

-- 실습2
-- emp테이블을 이용하여 다음을 구하시옹
-- 부서기준 
SELECT deptno,
       MAX(sal), MIN(sal), ROUND(AVG(sal),2), SUM(sal), COUNT(sal), COUNT(mgr), COUNT(*)
FROM emp
GROUP BY deptno;

--실습3
--emp 테이블을 이용하여 구해랑
-- 실습2의 쿼리를 이용하여 deptno 대신 부서명이 나오도록 해라잉
-- CASE문 이용
SELECT CASE 
            WHEN deptno = 10 THEN 'ACCOUNTING'
            WHEN deptno = 20 THEN 'RESEARCH'
            WHEN deptno = 30 THEN 'SALES'
       END deptname, 
       MAX(sal), MIN(sal), ROUND(AVG(sal),2), SUM(sal), COUNT(sal), COUNT(mgr), COUNT(*)
FROM emp
GROUP BY deptno;

-- DECODE 사용
SELECT DECODE(deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES') deptname, 
       MAX(sal), MIN(sal), ROUND(AVG(sal),2), SUM(sal), COUNT(sal), COUNT(mgr), COUNT(*)
FROM emp
GROUP BY deptno;

-- DOCODE 결과를 GROUP BY로
SELECT MAX(sal), MIN(sal), ROUND(AVG(sal),2), SUM(sal), COUNT(sal), COUNT(mgr), COUNT(*)
FROM emp
GROUP BY DECODE(deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES') ;

-- CASE 결과를 GROUP BY로
SELECT MAX(sal), MIN(sal), ROUND(AVG(sal),2), SUM(sal), COUNT(sal), COUNT(mgr), COUNT(*)
FROM emp
GROUP BY CASE 
            WHEN deptno = 10 THEN 'ACCOUNTING'
            WHEN deptno = 20 THEN 'RESEARCH'
            WHEN deptno = 30 THEN 'SALES'
       END;

-- 실습4
-- emp테이블을 이용하여 다음을 구해라
-- 직원의 입사 년월별로 몇명의 직원이 입사했는지 조회
SELECT TO_CHAR(hiredate, 'YYYY-MM') hireYYYYMM, COUNT(TO_CHAR(hiredate, 'YYYY-MM')) cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYY-MM')
ORDER BY TO_CHAR(hiredate, 'YYYY-MM');

-- 실습5
-- EMP 테이블 이용
-- 직원의 입사 년별로 몇명의 직원이 입사했는지 조회하는 쿼리
SELECT TO_CHAR(hiredate, 'YYYY') hireYYYYMM, COUNT(*) cnt -- COUNT() 안에 *를 넣어줘도 되고 GROUP BY한 값을 넣어줘도 댕
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYY')
ORDER BY TO_CHAR(hiredate, 'YYYY');

select *
from dept;

-- 실습6
-- dept 테이블 이용
-- 회사에 존재하는 부서의 개수는 몇개인지 조회
SELECT COUNT(*) "부서개수"
FROM dept;

SELECT *
FROM EMP;

--실습7
-- emp 테이블 이용
-- 직원이 속한 부서의 개수를 조회하는 쿼리
SELECT COUNT(*)
FROM
      (SELECT deptno, COUNT(deptno)
       FROM emp
       GROUP BY deptno);
        

-- ○ GROUP BY 정렬문제
-- ORACLE 9i 이전까지는 GROUP BY절에 기술한 컬럼으로 정렬을 보장
-- ORACLE 10G 이후 부터는 GROUP BY절에 기술한 컬럼으로 정렬을 보장하지 않는다.(GROUP BY 정렬 시 속도 UP)






