-- emp테이블에서 10번, 30번 부서에 속하는 사람 중 급여가 1500이 넘는 사람들만 조회하고
-- 이름으로 내림차순 정렬해라
SELECT *
FROM emp
WHERE deptno IN(10,30) AND sal > 1500
ORDER BY ename desc;

-- tool에서 정해주는 행의 번호를 컬럼으로 가져오기
-- ROWNUM : 행 번호를 나타내는 컬럼
-- 페이징 혹은 정렬과 관련된 응용 쿼리에서 중요하게 사용
-- 1.
SELECT ROWNUM, empno, ename
FROM emp;
WHERE deptno IN(10,30) AND sal > 1500;

-- 2.ROWNUM alies주기
SELECT ROWNUM rn, empno, ename
FROM emp;

-- 3. WHERE 절에서 사용
-- 동작하는거 : ROWNUM = 1 (1은 되고 2는 안됨)  
--             ROWNUM <= 2 (>=는 안됨)
--  -->  동작 가능 : ROWNUM = 1, ROWNUM <= N, ROWNUM >= 1
--  -->  동작 불가능 : ROWNUM = N(N이 1이 아닌 정수), ROWNUM >= N (N은 1이 아닌 정수)
SELECT ROWNUM rn, empno, ename
FROM emp
WHERE ROWNUM >= 1;

-- ROWNUM은 이미 읽은 데이터에 순서를 부여
-- **유의점1) 읽지 않은 상태의 값들(ROWNUM이 부여되지 않은 행)은 조회할 수 없다.
-- **유의점2) ORDER BY 절은 SELECT절 이후에 실행
-- 사용용도 : 1. 페이징 처리
--           2. 다른 행과 구분되는 유일한 가상의 컬럼 생성/활용
-- 테이블에 있는 모든 행을 조회하는 것이 아니라 우리가 원하는 페이지에 해당하는 행 데이터만 조회한다.
-- 페이징 처리시 고려사항 : 1페이지당 건수, 정렬 기준
-- EX)
-- EMP 테이블 총 ROW 건수 : 14
-- 페이징당 5건의 데이터를 조회
-- 1page = 1~5, 2page = 6~10, 3page = 11~15

SELECT ROWNUM rn, empno, ename
FROM emp
ORDER BY ename;

--이렇게하면 rn이 뒤죽박죽 섞임

--그래서 정렬된 결과에 ROWNUM을 부여 하기 위해서는 IN LINE VIEW를 사용한다.
-- 여기까지 요점 정리 : 1. 정렬,2.괄호로 묶기 3. ROWNUM부여
--1.정렬
SELECT empno, ename
FROM emp
ORDER BY ename; 

--2.괄호로 묶기 (IN LINE VIEW)
-- 괄호로 묶으면 해당 결과를 가지고 있는 테이블(데이터 셋)이라고 생각하면 됨
-- 즉 괄호로 묶으면 FROM 테이블 <- 테이블에 넣을수 있음
(SELECT empno, ename
FROM emp
ORDER BY ename); 

-- 3. 밖에 SELECT ,FROM절 입력
-- 유의점 : SELECT *을 기술할 경우 다름 EXPRESSTION을 표기 하기 위해서 테이블명 .*, 테이블명칭.*로 표현해야 한다.
SELECT ROWNUM, * -- 여기서 *만 썼을떄 에러나오는 이유는 테이블에서 검색된 컬럼의 숫자와 *로 검색했을 때 나오는 컬럼의 수가 다르기 때문
FROM
    (SELECT empno, ename
    FROM emp
    ORDER BY ename);  
    
--a 테이블이라는 별칭을 만들어주고 테이블.*로 검색
SELECT ROWNUM, a.* 
FROM
    (SELECT empno, ename
    FROM emp
    ORDER BY ename) a;

    
SELECT ROWNUM, emp.*
FROM emp;

-- 한번더 괄호로 묶어주면 RN이라는 게 컬럼으로 취급 됌
-- 즉, 처음에 동작 불가능 했던 ROWNUM = 2,3,4,...  , ROWNUM >= 5 등등 동작 가능
SELECT *
FROM
(SELECT ROWNUM rn, a.* 
FROM
    (SELECT empno, ename
    FROM emp
    ORDER BY ename) a)
WHERE rn =2;

-- 1page : 1~5 , 2page : 6~10, 3page : 11~15
-- ROWNUM -> rn
-- * pageSize : 5, 정렬 기준은 ename
-- 1 page : rn 1~5 
-- 2 page : rn 6~10
-- 3 page : rn 11~15
-- 공식화 :  n page : rn (n-1)*pagesize + 1 ~ n * pageSize

--1page
SELECT *
FROM
(SELECT ROWNUM rn, a.* 
FROM
    (SELECT empno, ename
    FROM emp
    ORDER BY ename) a)
WHERE rn >=1 AND rn <=5;

--2page
SELECT *
FROM
(SELECT ROWNUM rn, a.* 
FROM
    (SELECT empno, ename
    FROM emp
    ORDER BY ename) a)
WHERE rn BETWEEN 6 AND 10;

-- n page : rn (n-1)*pagesize + 1 ~ n * pageSize
SELECT *
FROM
(SELECT ROWNUM rn, a.* 
FROM
    (SELECT empno, ename
    FROM emp
    ORDER BY ename) a)
WHERE rn BETWEEN (1-1)*5 AND 1*5; 

--실습 1
-- emp 테이블에서 ROWNUM 값이 1~10인 값만 조회하는 쿼리를 작성(정렬 없이)
-- IN LINE VIEW 안써서
SELECT ROWNUM rn, empno, ename
FROM emp
WHERE ROWNUM BETWEEN 1 AND 10;

-- emp 테이블에서 ROWNUM 값이 1~10인 값만 조회하는 쿼리를 작성(정렬 없이)
-- IN LINE VIEW써서
SELECT *
FROM
    (SELECT ROWNUM rn, empno, ename
    FROM emp)
WHERE rn BETWEEN 1 AND 10;

--실습 2
SELECT *
FROM
    (SELECT ROWNUM rn, empno, ename
    FROM emp)
WHERE rn BETWEEN 11 AND 20;

--실습3
--emp 테이블의 사원 정보를 이름컬럼으로 오름차순 적용 했을 때의 11~14번째 행을 다음과 같이 조회
SELECT *
FROM
    (SELECT ROWNUM rn, a.empno, a.ename
     FROM
      (SELECT *
       FROM emp
       ORDER BY ename) a)
WHERE rn BETWEEN 11 AND 14;

-- 바인딩 변수 사용하기  - : 사용 -
SELECT *
FROM
(SELECT ROWNUM rn, a.* 
FROM
    (SELECT empno, ename
    FROM emp
    ORDER BY ename) a)
WHERE rn BETWEEN (:page-1)*:pageSize+1 AND :page* :pageSize;

-- 메소드 : 함수(Function)
-- INPUT X -> FUNCTION F -> OUTPUT F(X) 과정
-- INPUT이 한개 : Single row
-- INPUT이 두개 :  

-- character 함수 * 검색해서 알아보자
-- 대소문자 : 1. 등등
-- 문자열 조작 : 1.concat, 2/substr,  등등



--  DUAL table 
-- 1. sys 계정에 있는 테이블
-- 2. 누구나 사용가능
-- 3. DUMMY 컬럼 하나만 존재, 값은 X, 데이터는 한 행만 존재

-- 사용용도
-- 1. 데이터와 관련없이 함수 실행, 시퀀스 실행 등 (함수를 테스트 해볼 목적)
SELECT *
FROM dual;

-- TEST의 문자열의 길이
SELECT LENGTH('TEST')
FROM dual;

-- 문자열의 대소문자
-- LOWER, UPPER, INITCAP
SELECT LOWER('Hello, World'), UPPER('Hello, World'), INITCAP('Hello, World')
FROM dual;

SELECT LOWER('Hello, World'), UPPER('Hello, World'), INITCAP('Hello, World')
FROM emp;

-- 함수는 WHERE절에서도 사용가능
-- 사원 이름이 SMITH인 사원만 조회

-- 함수 안쓰고, 바인딩 변수 사용
SELECT *
FROM emp
WHERE ename = :ename;

-- 함수 쓰고 바인딩 변수 사용
SELECT *
FROM emp
WHERE ename = UPPER(:ename);

--SQL작성시 아래 형태는 지양 해야 한다.
--WHY? 테이블의 컬럼을 가공하지 않는 형태로 SQL문을 작성해야 하기 때문에.
-- 여기서 ename의 데이터 수만큼 LOWER함수 실행됨
SELECT *
FROM emp
WHERE LOWER(ename) = :ename;

-- 엔코아 : 오라클 
-- 개발자들이 하지 않아야 할 철거지악 검색해서 공부하자


SELECT CONCAT('Hello', ', World') CONCAT, --문자열 결합
       SUBSTR('Hello, World', 1, 5) SUB, --  oralce에서는 1번부터 5번까지 출력, java에서는 1번부터 4번까지 출력
       LENGTH('Hello, World') LEN,
       INSTR('Hello, World', 'o') INS, -- o가 처음 나오는 문자열의 인덱스 검색
       INSTR('Hello, World', 'o', 6) INS2, -- 6번째 문자열부터 o의 위치 인덱스 검색
       LPAD('Hello, World', 15, '*') LP, -- 문자열을 15개까지 채운다, 채울 문자열은 *, 왼쪽부터 채움
       RPAD('Hello, World', 15, '*') RP, -- 문자열을 15개까지 채운다, 채울 문자열은 *, 오른쪽부터 채움
       REPLACE('Hello, World', 'H', 'T') REP, -- H문자열을 T로 교체
       TRIM('               Hello, World               ') TR, -- 문자열의 앞, 뒤 공백을 제거
       TRIM('d' FROM 'Hello, World') TR2, -- 공백이 아닌 소문자 d 제거
       TRIM('오' FROM '오늘의 용춘이는 바보') TR3,
       TRIM('오' FROM '오늘의 용춘이오는 바보') TR3
FROM dual;

--숫자 함수
-- ROUND : 반올림 (10.6을 소수점 첫째 자리에서 반올림) -> 11
-- TRUNC : 절삭(버림) (10.6을 소수점 첫째 자리에서 절삭) -> 10
-- ROUND, TURNC : 몇번째 자리에서 반올림/ 절삭
-- MOD : 나머지 (몫이 아니라 나누기 연산을 한 나머지 값) (13/5 -> 몫 2, 나머지 3)

--ROUND (대상 숫자, 최종 결과 자리)
SELECT ROUND(105.54,1) ROD,--반올림 결과가 소수점 첫번째 자리까지 나오도록 --> 두번째 자리에서 반올림
       ROUND(105.55,1) ROD2,
       ROUND(105.55,0) ROD3,  -- 반올림 결과가 정수부까지 --> 소수점 첫번째 자리에서 반올림
       ROUND(105.55,-1) ROD4, -- 일의 자리에서 반올림
       ROUND(105.55) ROD5  -- ROD3과 값이 동일 즉, dafult값이 0
FROM dual;

SELECT TRUNC(105.54,1) TRU, -- 절삭의 결과가 소수점 첫번째 자리까지 나오도록 --> 두번째 자리에서 절삭
       TRUNC(105.55,1) TRU2, -- 절삭이기 때문에 TRU와 동일
       TRUNC(105.55,0) TRU3, --절삭의 결과가 정수부(일의 자리) 까지 나오도록 --> 소수점 첫번째 자리에서 절삭
       TRUNC(105.55,-1) TRU4, --절삭의 결과가 십의 자리까지 나오도록 --> 일의 자리에서 절삭
       TRUNC(105.55) TRU5 --TRU3과 값이 동일 즉, dafult값이 0
FROM dual;

--emp 테이블에서 사원의 급여(sal)를 1000으로  나눴을 때 몫
SELECT ename, sal, TRUNC(sal/1000) 몫, MOD(sal,1000) 나머지 -- mod의 결과는 divisor(나누는 수) 보다 항상 작다. 0~999
FROM emp;

desc emp;

--년도 2자리 월 2자리, 일 2자리
SELECT ename, hiredate
FROM emp;

-- SYSDATE : 현재 오라클 서버의 시, 분, 초가 포함된 날짜 정보를 리턴해주는 특수 함수
-- 일반적으로 함수를 사용할 때는 함수(인자1, 인자2)
-- BUT SYSDATE는 특수 함수라서 함수명만으로 실행
SELECT SYSDATE
FROM dual;

--복습
--date + 정수 = 일자 연산
-- 1=하루
-- 1시간 = 1/24
SELECT SYSDATE+5, SYSDATE +1/24
FROM dual;

-- 숫자 표기 : 숫자 --> 100
-- 문자 표기 : 싱글 쿼테이션 --> '문자열'
-- 날짜 표기 : TO_DATE('문자열 날짜 값', '문자열 날짜 값의 표시 형식') --> TO_DATE('19941011', 'YYYYMMDD')
                                                                                                                                                                                    
--과제 ppt function(date 실습 fn1) 
--ppt 129까지 했어용

SELECT TO_DATE('20191231','YYYYMMDD') LASTDAY, TO_DATE('20191231','YYYYMMDD')-5 LASTDAY_BEFORE5, 
       SYSDATE NOW, SYSDATE-3 NOW_BEFORE3
FROM dual;

                    
