--상향식 계층쿼리(leaf ==> root node(상위 node))
--
--전체 노드를 방문하는게 아니라 자신의 부모노드만 방문 (하향식과 다른점)
--
--시작점 : 디자인팀
--
--연결 : 상위부서

SELECT dept_h.*, LEVEL, LPAD(' ', (LEVEL-1)*4) || deptnm
FROM dept_h
START WITH deptnm = '디자인팀'  
CONNECT BY PRIOR p_deptcd = deptcd;

create table h_sum as
select '0' s_id, null ps_id, null value from dual union all
select '01' s_id, '0' ps_id, null value from dual union all
select '012' s_id, '01' ps_id, null value from dual union all
select '0123' s_id, '012' ps_id, 10 value from dual union all
select '0124' s_id, '012' ps_id, 10 value from dual union all
select '015' s_id, '01' ps_id, null value from dual union all
select '0156' s_id, '015' ps_id, 20 value from dual union all

select '017' s_id, '01' ps_id, 50 value from dual union all
select '018' s_id, '01' ps_id, null value from dual union all
select '0189' s_id, '018' ps_id, 10 value from dual union all
select '11' s_id, '0' ps_id, 27 value from dual;

SELECT LPAD(' ',(LEVEL-1)*4)||s_id s_id, VALUE
FROM h_sum
START WITH s_id = '0'
CONNECT BY PRIOR s_id = ps_id;

SELECT *
FROM h_sum;

create table no_emp(
    org_cd varchar2(100),
    parent_org_cd varchar2(100),
    no_emp number
);
insert into no_emp values('XX회사', null, 1);
insert into no_emp values('정보시스템부', 'XX회사', 2);
insert into no_emp values('개발1팀', '정보시스템부', 5);
insert into no_emp values('개발2팀', '정보시스템부', 10);
insert into no_emp values('정보기획부', 'XX회사', 3);
insert into no_emp values('기획팀', '정보기획부', 7);
insert into no_emp values('기획파트', '기획팀', 4);
insert into no_emp values('디자인부', 'XX회사', 1);
insert into no_emp values('디자인팀', '디자인부', 7);

commit;

SELECT *
FROM no_emp;

SELECT LPAD(' ', (LEVEL-1)*4)||ORG_CD, NO_EMP
FROM no_emp
START WITH org_cd = 'XX회사'
CONNECT BY PRIOR ORG_CD = PARENT_ORG_CD;

-- 계층형 쿼리의 행 제한 조건 기술 위치에 따른 결과 비교 (pruning branch - 가지치기)


FROM => START WITH, CONNECT BY => WHERE

1. WHERE : 계층 연결을 하고 나서 행을 제한
2. CONNECT BY : 계층 연결을 하는 과정에서 행을 제한하고 계층 연결

-- WHERE 절 기술 전 : 총 9개의 ROW
SELECT LPAD
(' ', (LEVEL-1)*4)||ORG_CD, NO_EMP
FROM no_emp
START WITH org_cd = 'XX회사'
CONNECT BY PRIOR ORG_CD = PARENT_ORG_CD;

-- WHERE 절 (deptnm != '정보기획부') :
-- 단, 다른 테이블과의 조인 조건으로 이용되었을 경우 조인에 사용됌
SELECT LPAD(' ', (LEVEL-1)*4)||ORG_CD, NO_EMP
FROM no_emp
WHERE org_cd != '정보기획부'
START WITH org_cd = 'XX회사'
CONNECT BY PRIOR ORG_CD = PARENT_ORG_CD;

--CONNECT BY 절에 조건을 기술
-- 정보기획부 밑에 노드들도 조회가 안됌
SELECT LPAD(' ', (LEVEL-1)*4)||ORG_CD, NO_EMP
FROM no_emp
START WITH org_cd = 'XX회사'
CONNECT BY PRIOR ORG_CD = PARENT_ORG_CD AND org_cd != '정보기획부';

--계층 쿼리 특수함수
--1. CONNECT BY_ROOT(col) : 최상위 데이터의 컬럼 정보 조회
--2. SYS_CONNECT_BY_PATH(col, '-') : 계층 순회 경로 표현, * 두번재 인자 : 경 로 표현 구분자
--3. CONNECT_BY_ISLEAF ISLEAF : 현재 행이 마지막 LEAF노드인지 리턴, * 1: 리프노드 0 : 리프노드 아님

--CONNECT_BY_ROOT(컬럼) : 해당 컬럼의 최상위 행의 값을 리턴
SELECT LPAD(' ', (LEVEL-1)*4)||ORG_CD, NO_EMP,
       CONNECT_BY_ROOT(org_cd) root
FROM no_emp
START WITH org_cd = 'XX회사'
CONNECT BY PRIOR ORG_CD = PARENT_ORG_CD AND org_cd != '정보기획부';

--SYS_CONNECT_BY_PATH(컬럼, 구분자)  : 해당 행의 컬럼이 거쳐온 컬럼 값을 추적, 구분자로 이어준다.
SELECT LPAD(' ', (LEVEL-1)*4)||ORG_CD, NO_EMP,
       LTRIM(SYS_CONNECT_BY_PATH(org_cd,'-'),'-') PATH
FROM no_emp
START WITH org_cd = 'XX회사'
CONNECT BY PRIOR ORG_CD = PARENT_ORG_CD;

-- CONNECT_BY_ISLEAF : 해당 행의 LEAF 노드인지(연결된 자식이 없는지) 값을 리턴 1:LEAF 노드, 0: NOT LEAF
SELECT LPAD(' ', (LEVEL-1)*4)||ORG_CD, NO_EMP,
       CONNECT_BY_ISLEAF LEAF
FROM no_emp
START WITH org_cd = 'XX회사'
CONNECT BY PRIOR ORG_CD = PARENT_ORG_CD;




CREATE table board_test (
 seq number,
 parent_seq number,
 title varchar2(100) );

insert into board_test values (1, null, '첫번째 글입니다');
insert into board_test values (2, null, '두번째 글입니다');
insert into board_test values (3, 2, '세번째 글은 두번째 글의 답글입니다');
insert into board_test values (4, null, '네번째 글입니다');
insert into board_test values (5, 4, '다섯번째 글은 네번째 글의 답글입니다');
insert into board_test values (6, 5, '여섯번째 글은 다섯번째 글의 답글입니다');
insert into board_test values (7, 6, '일곱번째 글은 여섯번째 글의 답글입니다');
insert into board_test values (8, 5, '여덜번째 글은 다섯번째 글의 답글입니다');
insert into board_test values (9, 1, '아홉번째 글은 첫번째 글의 답글입니다');
insert into board_test values (10, 4, '열번째 글은 네번째 글의 답글입니다');
insert into board_test values (11, 10, '열한번째 글은 열번째 글의 답글입니다');
commit;


SELECT *
FROM BOARD_TEST;

SELECT seq, LPAD(' ',(LEVEL-1)*4)||title TITLE,
        LTRIM(SYS_CONNECT_BY_PATH(TITLE,' - '),' - ') PATH,
        CONNECT_BY_ISLEAF LEAF,
        CONNECT_BY_ROOT(TITLE) ROOT
FROM board_test
START WITH parent_seq IS null
CONNECT BY PRIOR SEQ = parent_seq;


SELECT * 
FROM BOARD_TEST;

-- ORDER BY SIBLINGS BY 컬럼 DESC
SELECT seq, LPAD(' ',(LEVEL-1)*4)||title TITLE
FROM board_test
START WITH parent_seq IS null
CONNECT BY PRIOR SEQ = parent_seq
ORDER SIBLINGS BY SEQ DESC; --> 브렌치 노드들의 순서도 역순으로 조회된다.

-- 문제  ROOT노드는 DES, 브렌치노드들은 ASC 해라
ALTER TABLE board_test ADD (gn NUMBER);

-- 그룹번호 컬럼 추가
UPDATE board_test SET gn = 4
WHERE seq IN(4,5,6,7,8,10,11);

UPDATE board_test SET gn = 2
WHERE seq IN(2,3);

UPDATE board_test SET gn = 1
WHERE seq IN(1,9);

commit;

SELECT seq, LPAD(' ',(LEVEL-1)*4)||title TITLE,
        LTRIM(SYS_CONNECT_BY_PATH(TITLE,' - '),' - ') PATH,
        CONNECT_BY_ISLEAF LEAF,
        CONNECT_BY_ROOT(TITLE) ROOT
FROM board_test
START WITH parent_seq IS null
CONNECT BY PRIOR SEQ = parent_seq
ORDER SIBLINGS BY gn DESC, SEQ ASC; 


--WINDOW함수 
--행간 연산을 지원해주는 함수
--해당행의 범위를 넘어 다른 행간 연산이 가능
--   1. SQL의 약점보완  
--   2. 이전행의 특정 컬럼 값 조회
--   3. 특정 범위의 행들의 컬럼 합 조회
--   4. 특정 범위의 행중 특정 칼럼을 기준으로 한 순위, ROW 번호 조회
--     EX) SUM, COUNT, RANK, LEAD 등등

SELECT emp.ename, emp.deptno, c.LV
FROM 
(SELECT *
FROM (
        SELECT LEVEL LV
        FROM dual
        CONNECT BY LEVEL <=14) A,
        
        (SELECT deptno, COUNT(*) cnt
        FROM emp
        GROUP BY deptno) B
WHERE b.cnt >= a.LV
ORDER BY B.deptno, a.lv) C, emp
WHERE C.deptno = emp.deptno
ORDER BY C.DEPTNO, C.LV;

SELECT 

FROM EMP




   