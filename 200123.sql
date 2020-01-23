-- 조건에 맞는 데이터 조회하기
--emp 테이블에서 입사 일자가 1982년 1월 1일 이후부터 1983년 1월 1일 이전인 사원의 ename, hiredate를 조회하는 쿼리를 작성하시오
--연산자는 비교 연산자 사용
SELECT ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('19820101','YYYYMMDD') AND  hiredate <= TO_DATE('19830101','YYYYMMDD');

-- WHER절에 기술하는 조건에 순서는 조회 결과에 영향을 미치지 않는다.
-- SQL은 기본적으로 집합의 개념을 갖고 있다.
-- 집합 : 키가 186CM 이상이고 몸무게가 70KG 이상인 사람들의 모임
--             -> 몸무게가 70KG 이상이고 키가 186이상인 사람들의 모임 
--             조건의 순서를 바꿨지만 집합은 절차적인 개념을 갖고 있지 않기 때문에 결과에 상관 X (집합은 순서가 없다.)
--        잘생긴 사람의 모임 --> 집합X (조건이 명확하지 않기 때문에)
-- 테이블에는 순서가 보장되지 않음
-- SELECT 결과 순서가 다르더라도 값이 동일하면 정답으로 간주
--  * 정렬 기능 제공 (ORDER BY)


-- IN 연산자
-- 특정 집합에 포함되는지 여부를 확인
SELECT empno, ename, deptno
FROM emp;
-- 부서 번호가 10번 혹은 20번에 속하는 사람
-- IN
SELECT empno, ename, deptno
FROM emp
WHERE deptno IN(10,20);
-- OR
SELECT empno, ename, deptno
FROM emp
WHERE deptno = 10 OR deptno = 20;

-- emp테이블에서 사원이름이 SMITH, JONES인 직원만 조회(empno, ename, deptno)
-- IN
SELECT empno, ename, deptno
FROM emp
WHERE ename IN('SMITH','JONES');
-- OR
SELECT empno, ename, deptno
FROM emp
WHERE ename ='SMITH' OR ename ='JONES';

SELECT *
FROM users
WHERE 1=1;

-- users 테이블에서 userid가 brown, cony, sally인 데이터를 다음과 같이 조회하시오 
-- IN 연산자 사용
SELECT userid AS 아이디,usernm AS 이름, alias AS 별명
FROM users
WHERE userid IN('brown', 'cony', 'sally');

-- 문자열 매칭 연산자 : LIKE, %, _
-- * 문자열 매칭에서는 = 대신 LIKE 키워드를 사용
-- * % : 어떤 문자열(한글자, 글자 없을수도 있고, 여러 문자열이 올수도 있다.)
-- * _ : 정확히 한문자 
-- 위에서 연습한 조건은 문자열 일치에 대해서 다룸
-- 이름이 BR로 시작하는 사람만 조회
-- 이름에 R문자열이 들어가는 사람만 조회

-- 사원 이름이 S로 시작하는 사원 조회
-- % 사용
SELECT *
FROM emp
WHERE ename LIKE 'S%';
-- 직원 이름이 S로 시작하고 이름의 전체 길이가 5글자인 직원
-- _ 사용
SELECT *
FROM emp
WHERE ename LIKE 'S____';
--사원 이름에 S글자가 들어가는 사원 조회
SELECT *
FROM emp
WHERE ename LIKE '%S%';

-- member 테이블에서 회원의 성이 [신]씨인 사람의 mem_id, mem_name을 조회하는 쿼리를 작성하시오
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '신%';

-- member 테이블에서 회원의 이름이 글자 [이]가 들어가는 모든 사람들의 mem_id, mem_name을 조회하는 쿼리를 작성하시오
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '%이%';

-- null 비교 연산(IS)
-- comm 컬럼의 값이 null인 데이터를 조회 (WHERE comm = null)
-- null값 비교할 때는 IS를 꼭 써줘야 함
SELECT *
FROM emp
where comm = null;

SELECT *
FROM emp
where comm = '';

SELECT *
FROM emp
where comm IS null;

-- emp 테이블에서 상여(comm)가 있는 회원의 정보를 다음과 같이 조회되도록 쿼리를 작성하시오
-- NOT null
SELECT *
FROM emp
where comm IS not null;

-- NOT IN
-- 사원의 관리자가 7698, 7839 그리고 NULL이 아닌 직원만 조회
-- NOT IN 연산자에서는 NULL값을 괄호 안에 포함 시킬 수 없음.
SELECT *
FROM emp
WHERE mgr NOT IN(7698, 7839) AND mgr IS NOT NULL;




-- emp 테이블에서 부서번호가 10번이 아니고 입사일자가 1981년 6월 1일 이후인 직원의 정보를
-- 다음과 같이 조회하세요 (IN, NOT IN 연산자 사용금지)
SELECT *
FROM emp
WHERE deptno != 10 AND hiredate > TO_DATE('19810601', 'YYYYMMDD');

-- emp 테이블에서 부서번호가 10번이 아니고 입사일자가 1981년 6월 1일 이후인 직원의 정보를
-- 다음과 같이 조회하세요 (IN, NOT IN 연산자 사용)
SELECT *
FROM emp
WHERE deptno NOT IN( 10) AND hiredate > TO_DATE('19810601', 'YYYYMMDD');



-- emp 테이블에서 부서번호가 10번이 아니고 입사일자가 1981년 6월 1일 이후인 직원의
-- 정보를 다음과 같이 조회 하세요 (부서는 10, 20, 30만 있다고 가정, IN 연산자 사용)
SELECT *
FROM emp
WHERE deptno IN(20, 30) AND hiredate > TO_DATE('19810601', 'YYYYMMDD');


-- emp 테이블에서 job이 SALEMAN이고 입사일자가 1981년 6월 1일 이후인 직원의 정보를
-- 다음과 같이 조회 하세요
SELECT *
FROM emp
WHERE job = 'SALESMAN' AND hiredate >= TO_DATE('19810601', 'YYYYMMDD');

-- emp 테이블에서 job이 SALEMAN이거나 사원번호가 78로 시작하는 직원의 정보를
-- 다음과 같이 조회 하세요
SELECT *
FROM emp
WHERE job = 'SALESMAN' OR empno LIKE '78%';

-- emp 테이블에서 job이 SALEMAN이거나 사원번호가 78로 시작하는 직원의 정보를
-- 다음과 같이 조회 하세요 ( LIKE연산자를 사용하지 마세요 )

SELECT *
FROM emp
WHERE job = 'SALESMAN' OR empno BETWEEN 7800 AND 7899;

--연산자 우선순위
-- 1. 산술연산자
-- 2. 문자열결합
-- 3. 비교연산
-- 4. IS, [NOT]NULL, LIKE
-- 5. 
-- 6.
-- 7. 
-- 우선순위 변경 : ()
-- AND > OR !!!

-- emp 테이블에서 사원 이름이 SMITH 이거나, 사원 이름이 ALLEN 이면서 담당업무가 SALESMAN인 사원 조회
SELECT *
FROM emp
WHERE ename = 'SMITH' 
OR (ename = 'ALLEN' AND job ='SALESMAN') ;

-- 사원 이름이 SMITH 이거나 ALLEN이면서 담당 업무가 SALESMAN인 사원 조회
SELECT *
FROM emp
WHERE ename IN ('SMITH', 'ALLEN')
AND job LIKE 'S%' ;

-- emp 테이블에서 job이 SALESMAN이거나 사원번호가 78로 시작하면서 입사일자가 1981년 6월 1일 이후인 직원의 정보를 조회
SELECT *
FROM emp
WHERE job ='SALESMAN' 
OR (empno LIKE '78%' AND hiredate > TO_DATE('19810601','YYYYMMDD'));





-- < 데이터 정렬 >
-- TABLE 객체에는 데이터를 저장 / 조회시 순서를 보장하지 않음
-- 보편적으로 데이터가 입력된 순서대로 조회됨
-- 데이터가 항상 동일한 순서로 조회되는 것을 보장하지 않는다
-- 데이터가 삭제되고, 다른 데이터가 들어 올 수도 있음

-- < ORDER BY >
-- ASC : 오름차순 (dafult)
-- DESC : 내림차순
-- 사용법
-- SELECT *
-- FROM TABLE
-- [WHERE]
-- ORDER BY {정렬 기준 컬럼 | ALIAS(별칭) | 컬럼번호 [ASC | DESC]}

-- emp 테이블의 모든 사원을 ename 컬럼 값을 기준으로 오름차순 정렬한 결과를 조회하세요
SELECT *
FROM emp
ORDER BY ename;

-- emp 테이블의 모든 사원을 ename 컬럼 값을 기준으로 내림차순 정렬한 결과를 조회하세요
SELECT *
FROM emp
ORDER BY ename DESC;

DESC emp; -- DESC : DESCRIBE (설명하다)
ORDER BY ename DESC -- DESC : DESCENDING (내림)

-- emp 테이블에서 사원 정보를 ename 컬럼으로 내침차순, ename 값이 같을 경우 mgr 컬럼으로 오름차순 정렬하는 쿼리를 작성하세요
SELECT *
FROM emp
ORDER BY ename DESC, mgr;

-- 별칭으로 정렬
SELECT empno, ename AS nm, sal*12 AS year_sal 
FROM emp
ORDER BY nm ;

-- 컬럼 인덱스로 정렬
-- java array에서 INDEX 시작은 0부터
-- SQL INDEX는 1부터 시작
SELECT empno , ename AS nm, sal*12 AS year_sal 
FROM emp
ORDER BY  2;

-- dept 테이블의 모든 정보를 부서이름으로 오름차순 정렬로 조회
SELECT *
FROM dept
ORDER BY dname;

-- dept 테이블의 모든 정보를 부서위치로 내림차순 정렬로 조회
SELECT *
FROM dept
ORDER BY loc DESC;

-- emp 테이블에서 상여(comm) 정보가 있는 사람들만 조회하고, 상여(comm)를 많이 받는 사람이 먼저 조회되도록 하고,
-- 상여가 같을 경우 사번으로 오츰차순 정렬하세요 (상여가 0인사람은 상여가 없는 것으로 간주)
SELECT *
FROM emp
WHERE comm IS NOT NULL 
AND comm != 0 
ORDER BY comm DESC, empno;

SELECT *
FROM emp
WHERE comm > 0
ORDER BY comm DESC, empno;

-- emp 테이블에서 관리자가 있는 사람들만 조회하고, 직군(job)순으로 오름차순 정렬하고, 직업이 같을 경우 사번이 큰 사원이 먼저 조회
SELECT *
FROM emp
WHERE mgr IS NOT NULL
ORDER BY job, empno DESC;
