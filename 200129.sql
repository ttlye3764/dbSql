--DATE : TO_DATE 문자열 -> 날짜 
--       TO_CHAR 날짜 -> 문자열
-- JAVA에서는 날짜 포맷의 대소문자를 가린다(MM / mm -> 월 / 분)
SELECT TO_CHAR(SYSDATE, 'YYYY-MM/DD HH24:MI:SS')  -- HH24 시간 / MI 분 / SS 초 (표기법)
FROM dual;

-- date 형식
-- YYYY : 4자리 연도
-- MM : 2자리 월
-- DD : 2자리 일자

SELECT TO_CHAR(SYSDATE, 'YYYY-MM/DD HH24:MI:SS')  ,
        TO_CHAR(SYSDATE, 'D'),   -- D : 주간 일자(1~7), 일요일 1, 월요일 2, ..., 토요일 7
        TO_CHAR(SYSDATE, 'IW'),  -- IW : 주차 (ISO 표준 - 해당 주의 목요일을 기준으로 주차를 산정) 
        TO_CHAR(TO_DATE('2019/12/31','YYYY/MM/DD'), 'IW')
FROM dual;

SELECT TO_DATE('19941011 09:50:10','YYYYMMDD HH24:MI:SS') 
FROM dual;

SELECT TO_DATE('19941024') 
FROM dual;

SELECT TO_CHAR(TO_DATE('2019/12/31 01:01:01','YYYY/MM/DD HH24:MI:SS'), 'YYYY/MM/DD HH24:MI:SS') --TO_CHAR에서는 시분초가 나오는데 TO_DATE에서는 시분초가 안나와염 -> 환경설정-NLS에서 설정하니까 되염
FROM dual; 

-- emp 테이블의 hiredate(입사일자) 컬럼의 년 월 일 시:분:초
SELECT ename, hiredate,
       TO_CHAR(hiredate, 'YYYY-MM-DD HH24:MI:SS'),
       TO_CHAR(hiredate + 1, 'YYYY-MM-DD HH24:MI:SS'),  -- 1일씩 +
       TO_CHAR(hiredate + 1/24, 'YYYY-MM-DD HH24:MI:SS')  -- 1시간씩 +
FROM emp;

--실습 fn2
-- 오늘 날짜를 다음과 같은 포맷으로 조회
-- 1.년-월-일
-- 2.년-월-일 시간(24)-분-초
-- 3. 일-월-년
SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD') DT_DASH, 
       TO_CHAR(SYSDATE,'YYYY-MM-DD HH24-MI-SS') DT_DASH_WITH_TIME,
       TO_CHAR(SYSDATE,'DD-MM-YYYY') DT_DD_MM_YYYY
FROM dual;

--date 
--날짜 조작
--ROUND(DATE, format) : 반올림
--TRUN(DATE, format) : 절삭

SELECT ename, hiredate, 
       MONTHS_BETWEEN(SYSDATE, hiredate), -- MONTHS_BETWEEN(DATE,DATE) : 두 날짜 사이의 개월수
       MONTHS_BETWEEN(TO_DATE('2020-01-17','YYYY-MM-DD'), hiredate)
FROM emp
WHERE ename ='SMITH';

--                    * 유 용 *

SELECT ADD_MONTHS(SYSDATE, 5),    -- ADD_MONTHS(DATE, 정수-가감할 개월수) : NUMBER개월 이후의 날짜
       ADD_MONTHS(SYSDATE, -5)
FROM dual;

-- NEXT_DAY(DATE, 주간일자) : DATE 다음 weekday EX) NEXT_DAY(SYSDATE, 5) -> SYSDATE 이후 처음 등장하는 5에 해당하는 일자
--                                                 SYSDATE 2020/01/29(수)    
SELECT NEXT_DAY(SYSDATE, 3)
FROM dual;

SELECT NEXT_DAY(SYSDATE, '화') -- 문자로도 가능(일 - 1, 월 -2, ...토 - 6)
FROM dual;

-- LAST_DAY(DATE) : DATE가 속한 월의 마지막 날짜
SELECT LAST_DAY(SYSDATE),
        -- DATE가 속한 월의 첫번째 날짜 구하는 법
       LAST_DAY(ADD_MONTHS(SYSDATE,-1))+1,
       TO_DATE('01','DD'),
       ADD_MONTHS(LAST_DAY(SYSDATE)+1,-1),
       TO_DATE(TO_CHAR(SYSDATE, 'YYYY-MM') || '-01', 'YYYY-MM-DD')
FROM dual;

-- hiredate 값을 이용하여 해당 월의 첫번째 일자로 표현
SELECT ename, hiredate,
       LAST_DAY(ADD_MONTHS(hiredate, -1))+1,
       TO_DATE(TO_CHAR(hiredate, 'YYYY-MM') || '-01', 'YYYY-MM-DD')
FROM emp;

--형 변환
-- 1. 명시적 형변환 (지금까지 배운거)
-- 2. 묵시적 형변환

--empno는 NUMBER 타입, 인자는 문자열로 비교
-- 타입이 맞지 않기 때문에 묵시적 형변환이 일어남
-- 테이블 컬럼에 맞게 올바른 인자 값을 주는게 중요
SELECT *
FROM emp
WHERE empno='7369';

-- hiredate의 경우 DATE타입, 인자는 문자열로 주어졌기 때문에 묵시적 형변환이 발생
-- 날짜 문자열 보다 날짜 타입으로 명시적으로 기술하는 것이 좋음
SELECT *
FROM emp
WHERE hiredate = '19801217';

SELECT *
FROM emp
WHERE hiredate = TO_DATE('19801217','YYYYMMDD');

-- 실행 계획 확인하기
-- 1. EMPLAIN PLAN FOR 실행
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno='7369';

-- 2. 특수함수 table(dbms_xplan.display) 실행
-- 위에서 아래로 실행, 들여쓰기가 있으면 자식이라는 소리 (자식->부모 순서)
SELECT *
FROM table(dbms_xplan.display);


-- 숫자를 문자로 형변환
-- 숫자를 문자열로 변경하는 경우 : 포맷
-- 천단위 구분자 
-- 한국 : 1,000.55
-- 독일 : 1.000,55

-- emp sal 컬럼(NUMBER 타입)을 포맷팅
SELECT ename, sal, TO_CHAR(sal, '9,999'), -- 9 : 숫자 천자리에서 콤마(,)로 표시하겠다
       TO_CHAR(sal, '009,999'), -- 0 :강제 자리 맞춤(0으로 표기)
       TO_CHAR(sal, 'L009,999') -- L : 통화단위
FROM emp;

-- 국제화
-- EXERD

-- NULL 함수
-- 1. NVL
-- 2. NVL2
-- 3. NULLIF

-- NULL에 대한 연산의 결과는 항상 NULL

-- emp 테이블의 sal 컬럼에는 null 데이터가 존재하지 않음(14건의 데이터에 대해)
-- emp 테이블의 comm 컬럼에는 null 데이터가 존재(14건의 데이터에 대해)
-- sal + comm --> comm이 null인 행에 대해서는 결과가 null로 나옴
SELECT ename, sal, comm, sal + comm
FROM emp;

-- 이 때, 요구사항이 comm이 null이면 sal컬럼의 값만 조회할때?

-- NVL(타겟, 대체값)
-- 타겟의 값이 NULL이면 대체값을 반환하고
-- 타겟의 값이 NULL이 아니면 타겟 값을 반환
SELECT ename, sal, comm, 
       NVL(sal + comm, sal),
       NVL(comm , 0),
       sal + NVL(comm, 0),
       NVL(sal+comm, 0)
FROM emp;

-- NVL2(expr1, expr2, expr3)

-- if(expr1 != null)
--  return expr2;
-- else
--  return expr3;

SELECT ename, sal, comm,
       NVL2(comm, 10000, 0)
FROM emp;

--NULLIF(expr1, expr2)

--if(expr1 == expr2)
--   return null;
--else
--   return expr1;
SELECT ename, sal, comm, NULLIF(sal, 1250) -- sal가 1250인 사원은 1250을 return, 1250이 아닌 사람은 sal을 리턴
FROM emp;


-- COALESCE(expr1, expr2, ...)
-- 인자중에 가장 처음으로 등장하는 null이 아닌 인자를 반환
-- 가변인자
-- if(expr1 != null)
--    return expr1;
-- else
--    return COALESCE(expr2, expr3....)

-- comm이 null이 아니면 comm, comm이 null이면 sal
SELECT ename, sal, comm, COALESCE(comm, sal)
FROM emp;

-- 실습 4
-- emp 테이블의 정보를 다음과 같이 조회
-- NVL, NVL2, COALESCE이용
SELECT empno, ename, mgr,
       NVL(mgr,9999),
       NVL2(mgr,mgr,9999),
       COALESCE(mgr,9999)
FROM emp;

-- 실습5
-- users 테이블의 정보를 다음과 같이 조회
-- reg_dt가 null일 경우 sysdate를 적용
SELECT userid, usernm, reg_dt, NVL(reg_dt, SYSDATE) n_reg_dt 
FROM users
WHERE usernm != '브라운';

--function
-- 1. 싱글
-- 2. 멀티

-- Condition : 조건절
-- 1. CASE
-- 2. DECODER

-- CASE : Java의 if - else if - else 절과 비슷한 느낌

-- CASE
--    WHEN 조건 THAN 리턴값1 
--    WHEN 조건2 THAN 리턴값2
--    ELSE 기본값
-- END

-- 예제) emp테이블에서 JOB 컬럼의 값이 SALMESMAN 이면 SAL * 1.05 리턴
--                                  MANAGER 이면 SAL * 1.1 리턴
--                                  PRESIDENT 이면 SAL * 1.2 리턴
--                                  그 밖의 사람들은 SAL 리턴
SELECT ename, job, sal,
       CASE
            WHEN job = 'SALESMAN' THEN sal* 1.05
            WHEN job = 'MANAGER' THEN sal* 1.1
            WHEN job = 'PRESIDENT' THEN sal* 1.2
            ELSE sal
       END bonus_sal
FROM emp
ORDER BY job;



-- DECODE함수 : CASE절과 유사
--다른점 : CASE절 - WHEN 절에 조건비교가 자유롭다
--        DECODE 함수 : 하나의 값에 대해서 = 비교만 허용
-- 가변인자(인자의 개수가 상황에 따라서 늘어날 수 있음)
-- DECODE(col | expr, 첫번째 인자와 비교할 값1, 첫번째 인자와 두번째 인자가 같을 경우 반환 값,
--                    첫번째 인자와 비교할 값2, 첫번째 인자와 네번째 인자가 같을 경우 반환 값, ...
--                    option - else 최종적으로 반환할 기본값)

-- 예제) emp테이블에서 JOB 컬럼의 값이 SALMESMAN 이면 SAL * 1.05 리턴
--                                  MANAGER 이면 SAL * 1.1 리턴
--                                  PRESIDENT 이면 SAL * 1.2 리턴
--                                  그 밖의 사람들은 SAL 리턴

SELECT ename, job, sal,
        DECODE(job, 'SALESMAN', sal*1.05,
                    'MANAGER', sal*1.1,
                    'PRESIDENT', sal*1.2, sal) bonus_sal
FROM emp
ORDER BY job;

-- 예제) emp테이블에서 JOB 컬럼의 값이 SALMESMAN 이면서 sal가 1400보다 크면 SAL * 1.05 리턴
--                                  MANAGER 이면서 SAL가 1400보다 작으면 SAL * 1.1 리턴
--                                  PRESIDENT 이면 SAL * 1.2 리턴
--                                  그 밖의 사람들은 SAL 리턴

SELECT ename, job, sal,
        CASE
            WHEN job = 'SALESMAN' AND sal>1400 THEN sal* 1.05
            WHEN job = 'MANAGER' AND sal <1400 THEN sal* 1.1
            WHEN job = 'PRESIDENT' THEN sal* 1.2
            ELSE sal
       END bonus_sal
FROM emp
ORDER BY job;

-- 

SELECT ename, job, sal
FROM emp;







             







