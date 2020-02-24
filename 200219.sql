쿼리 실행 결과 11건
페이징 처리(페이지당 10건의 게시글)
1페이지 : 1~10
2페이지 : 11~20
바인드변수 :page, :pageSize;
rn (page-1)*pagesize+1 ~ page * pagesize;

SELECT *
FROM(
     SELECT rownum rn,seq, LPAD(' ', (LEVEL-1)*4) || title title, DECODE(parent_seq, NULL, seq, parent_seq) root
     FROM board_test
     START WITH parent_seq IS NULL
     CONNECT BY PRIOR seq = parent_seq
     ORDER SIBLINGS BY root DESC, seq ASC)
WHERE rn between (:page-1)*:pageSize +1 and :page * :pageSize;




-------과제 랭킹부여하기-------
SELECT b.ename, b.sal, a.lv
FROM
(SELECT a.*, rownum rm
FROM
(SELECT *
FROM
(   SELECT LEVEL lv
    FROM dual
    CONNECT BY LEVEL <=14) a,
(   SELECT deptno, COUNT(*) cnt
    FROM emp
    GROUP BY deptno) b
WHERE b.cnt >= a.lv
ORDER BY b.deptno, a.lv) a) a 
JOIN
(SELECT b.*, rownum rm
FROM
(SELECT ename, sal, deptno
FROM emp
ORDER BY deptno, sal desc)b) b ON(a.rm = b.rm);

위에 쿼리를 분석함수를 사용해서 표현하면...;

SELECT ename, sal, deptno, ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal DESC) rank
FROM emp;

분석함수 문법
분석함수명([인자]) OVER([PARTITION BY 컬럼] [ORDER BY 컬럼] [WINDOWING])
PARTITION BY 컬럼 : 해당 컬럼이 같은 ROW 끼리 하나의 그룹으로 묶는다. 
ORDER BY 컬럼 : PARTITION BY에 의해 묶인 그룹 내에서 ORDER BY 컬럼으로 정렬

ROW_NUMBER() OVER(PARTITION BY deptno ORDER BY sal DESC) rank;

순위 관련 분석함수
RANK : 같은 값을 가질때 중복 순위를 인정, 후순위는 중복 값만큼 떨어진 값부터 시작
       2등이 2명이면 3등은 없고 4등부터 후순위가 생성된다.
DENSE_RANK() : 같은 값을 가질때 중복 순위를 인정, 후순위는 중복순위 다음부터 시작
               2등이 2명이더라도 후순위는 3등부터 시작
ROW_NUMBER() : ROWNUM과 유사, 중복된 값을 허용하지 않음;

부서별, 급여 순위를 3개의 랭킹 관련함수를 적용;

SELECT ename, sal, deptno,
        RANK() OVER (PARTITION BY deptno ORDER BY sal) sal_rank,
        DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal) sla_dense_rank,
        ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal) sla_row_number
FROM emp;


SELECT ename, sal, deptno,
        RANK() OVER (ORDER BY sal, empno) sal_rank,
        DENSE_RANK() OVER (ORDER BY sal,empno) sla_dense_rank,
        ROW_NUMBER() OVER (ORDER BY sal, empno) sla_row_number
FROM emp;



SELECT *
FROM emp;

ALTER TABLE emp ADD (EN NUMBER);
SELECT *
FROM EMP;
UPDATE emp SET EN = 1
WHERE EN IS NULL;

COMMIT;


SELECT A.empno, A.ename, A.deptno, B.count
FROM(
        SELECT empno, ename, deptno
        FROM emp) A,

        (SELECT deptno, COUNT(*) count
        FROM emp
        GROUP BY deptno) B
WHERE A.deptno =  B.deptno
ORDER BY A.deptno;

통계관련 분석함수(GROUP 함수에서 제공하는 함수 종류와 동일)

SUM(컬럼)
COUNT(*), COUNT(컬럼)
MIN(컬럼)
MAX(컬럼)
AVG(컬럼)

no_ana2를 분석함수를 사용하여 작성
부서별 직원 수

SELECT empno, ename, deptno,
       COUNT(*) OVER(PARTITION BY deptno) cnt
FROM emp;

--모든 직원을 대상으로 그사람이 속한 부서의 급여 평균을 조회
SELECT empno, ename, deptno, sal,
        AVG(sal) OVER(PARTITION BY DEPTNO) AVG_SAL
FROM emp;

--모든 직원을 대상으로 그사람이 속한 부서의 최대급여를 조회
SELECT empno, ename, deptno, sal,
        MAX(sal) OVER(PARTITION BY DEPTNO) AVG_SAL
FROM emp;

--모든 직원을 대상으로 그사람이 속한 부서의 최소 급여를 조회
SELECT empno, ename, deptno, sal,
        MIN(sal) OVER(PARTITION BY DEPTNO) AVG_SAL
FROM emp;

급여를 내림차순 정렬하고, 급여가 같을 때는 입사일자가 빠른 사람이 높은 우선순위가 되도록 정렬하여
현재행의 다음행(LEAD)의 sal 컬럼을 구하는 쿼리 작성

SELECT empno, ename, hiredate, sal, LEAD(sal) OVER(ORDER BY SAL DESC, hiredate) lead_sal
FROM emp; -- 1단계 밑 SAL

SELECT empno, ename, hiredate, sal, LEAD(sal) OVER(ORDER BY SAL , hiredate) lead_sal
FROM emp; -- 1단계 위 SAL

SELECT empno, ename, hiredate, sal, LAG(sal) OVER(ORDER BY SAL DESC, hiredate) lead_sal
FROM emp; -- 1단계 위 SAL

SELECT empno, ename, hiredate, job, sal, LAG(sal) OVER(PARTITION BY JOB ORDER BY sal desc) lag_sal
FROM emp; -- 1단계 위 SAL

모든 사원에 대해, 담당업무별 급여 순위가 1단계 높은 사람 (급여가 같을 경우 입사일이 빠른 사람이 높은 순위)



SAL로 정렬하고 자신보다 급여가 낮은사람들 급여 + 자신의 급여 구하기
SELECT A.ENAME, A.SAL, SUM(B.SAL)
FROM(
SELECT ROWNUM RM, A.*
FROM
(SELECT *
FROM emp
ORDER BY sal, empno) a) A
,
(SELECT ROWNUM RM, B.*
FROM
(SELECT *
FROM emp
ORDER BY sal, empno) B) B
WHERE A.RM >= B.RM 
GROUP BY A.ENAME, A.SAL
ORDER BY SAL;

--> 위의 쿼리를 분석함수를 이용하여 SQL

SELECT empno, ename, sal, SUM(sal) OVER( ORDER BY sal,empno ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) cumm_sal
FROM emp;

현재행을 기준으로 이전 한행부터 이후 한행까지 총 3개행의 sal 합계 구하기

SELECT empno, ename, sal, SUM(sal) OVER(ORDER BY sal,empno ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING ) C_SUM
FROM emp;

실습
SELECT empno, ename, sal, SUM(sal) OVER(PARTITION BY deptno ORDER BY sal, empno ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) C
FROM emp;

--ORDER BY 기술후 WINDOWING 절을 기술하지 않을 경우 다음 WINDOWING 이 기본 값으로 적용된다.
--RANGE UNBOUNDED PRECEDING = RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW;

SELECT empno, ename, sal, SUM(sal) OVER(PARTITION BY deptno ORDER BY sal, empno ) C
FROM emp;    

-- WINDOWING 의 RANGE, ROWS 비교
-- RANGE : 논리적인 행의 단위, 같은 값을 가지는 컬럼까지 자신의 행으로 취급  
-- ROWS : 물리적인 행의 단위, 같은 값을 가지는 컬럼은 자신의 행으로 취급하지 않음

SELECT empno, ename, sal, 
       SUM(sal) OVER(PARTITION BY deptno ORDER BY sal ROWS UNBOUNDED PRECEDING ) ROW_,   --> 다음 ROW가 현재 ROW와 값이 같을 경우 자신의 ROW라고 생각하고 값을 더 해주지 않는다.
       SUM(sal) OVER(PARTITION BY deptno ORDER BY sal RANGE UNBOUNDED PRECEDING ) RANGE,
       SUM(sal) OVER(PARTITION BY deptno ORDER BY sal) DEFAULT_
FROM emp;    
        
-------------------------
| RATIO_TO_REPORT       |
| PERCENT_RANK          |
| CUME_DIST             |
| NTILE                 |
-------------------------                                                                                                                                                                                               






