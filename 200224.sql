--SQL문 처리과정
--
--서버 프로세스에 의해 PGA를 통해 수행
--
--구문분석 실행 계획 -> 바인드 -> 실행 -> 인출(FETCH)
--
--구문분석 실행 계획 : 공유 풀에서 동일한 실행 계획이 있는지 검색(커서 공유) * 실행 계획을 세우는 작업이 비용이 높기 때문에 재사용 할 수 있으면 하려고
--                   SQL Syntax 검사 (문법적으로 오류가 없는지)
--                   Semantic 검사
--                   Data Dictionary
--                   참조 객체 검사
--                   스키마, 롤, 권한
--                   실행 계획 작성
--                   
--바인드 : 바인드 변수 값이 있는 경우 할당
--
--실행 : 실행 계획 적용
--      실행에 필요한 작업 수행 - DB I/O 작업
--                           - 조인, 정렬
--
--인출 : 질의 결과 행들을 검색하여 반환
--      검색하여 반환
--      배열처리
--      정렬
--
--실행 : 실행 계획 적용
--
--○ SQL공유
--
--1. 이미 수립된 실행 계획을 공유해서 재사용
--   - 
--
--동일한 SQL 문장이란?
-- -> 텍스트가 완벽하게 동일한 SQL
--   1. 대소문자 가림
--   2. 공백도 동일해야함
--   3. 조회 결과가 같다고 동일한 SQL문이 아님
--   4. 주석도 영향을 미침
--
--그렇기 때문에 다음의 SQL 문장들은 동일한 문장이 아님
--select * FROM dept;
--SELECT * FROM dept;
--select   * FROM dept;
--select *
--FROM dept;

--SQL 실행시 v$SQL 뷰에 데이터가 조회되는지 확인;
SELECT /* sql_test*/ *
FROM dept
WHERE deptno = 10;

--위 두개의 SQL은 검색하고자 하는 부서번호만 다르고
--나머지 텍스트는 동일하다. 하지만 부서번호가 다르기 때문에 DBMS 임장에서는 서로 다른 SQL로 인식
-- => 다른 SQL 실행 계획을 세운다
-- => 실행 계획을 공유하지 못한다
-- ==> 해결책 : 바인드 변수 사용
-- 
-- SQL에서 변경되는 부분을 별도로 전송을 하고
-- 실행계획 세워진 이후에 바인딩 작업을 거쳐 실제 사용자가 원하는 변수 값으로 치환 후 실행
--  ==> 실행계획 공유 가능 ==> 메모리 자원 낭비 방지;
--  
SELECT /* sql_test*/ *
FROM dept
WHERE deptno = :deptno;

--● 커서 (Cursor)
-- - SQL문을 실행하기 위한 메모리 공간
-- - 기존에 사용한 SQL문은 묵시적 커서를 사용
--
-- - 묵시적(암시적) 커서
--    -> 오라클에서 자동으로 선언해주는 SQL 커서
--    -> ?
--    
-- - 명시적 커서
--    -> 사용자가 선언하는 SQL 커서
--    -> 로직을 제어하기 위한 커서
--    
--명시적 커서 사용이유    
--    
--SELECT 결과 여러건을 TABLE 타입의 변수에 저장할 수 있지만 메모리는 한정적이기 때문에 많은 양의 데이터를 담기에는 제한이 따름
--
--SQL 커서를 통해 개발자가 직접 데이터를 FETCH 함으로써 SELECT 결과를 전부 불러오지 않고도 개발이 가능;
--
--명시적 커서 선언(여러 건을 검색하는 SELECT)
-- CURSOR cursor_name IS
--   SUBQUERY;
--   
--○ 커서 선언 방법
--
--선언부(DECLARE)에서 선언
--    CURSOR 커서이름 IS
--        제어할 쿼리;
--
--실행부(BEGIN)에서 커서 열기
--    OPEN 커서이름;
--    
--실행부(BEGIN)에서 커서로 부터 데이터 FETCH
--    FETCH 커서이름 INTO 변수;
--    
--실행부(BEGIN)에서 커서 닫기
--    CLOSE 커서이름;
--
--부서 테이블을 활용하여 모든 행에 대해 부서번호와 부서 이름을 CURSOR를 통해 FETCH, FETCH된 결과를 확인;

SET SERVEROUTPUT ON;

DECLARE 
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
    CURSOR dept_cursor IS
        SELECT deptno, dname
        FROM dept;
BEGIN
    OPEN dept_cursor;
    
    LOOP
        FETCH dept_cursor INTO v_deptno, v_dname;
        EXIT WHEN dept_cursor%NOTFOUND;   
        DBMS_OUTPUT.PUT_LINE(v_deptno || ' : ' || v_dname);
    END LOOP;
END;    
/

--CURSOR를 열고 닫는 과정이 다소 거추장스러움
--CURSOR는 일반적으로 LOOP와 함께 사용하는 경우가 많음
-- ==> 명시적 커서를 FOR LOOP에서 사용할 수 있게 끔 문법으로 제공

--JAVA
--LIST<String> UserNameList = new ArrayList<String>();
--userNameList.add("brown");
--userNameList.add("cony");
--userNameList.add("sally");
--
--일반 for 
--for(int i = 0 ; i < userNameList.size(); i++){
--    userNameList.get(i);
--}
--
--향상된 for
--for(String UserName : userNameList){
--    UserName 값을 사용..;
--}

--JAVA 향상된 FOR문 형태와 유사
--
--FOR record_name(한 행의 정보를 담을 변수이름 / 변수를 직접 선언안함) IN 커서이름 LOOP
--    record_name.컬럼명
--END LOOP;

DECLARE
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
    
    CURSOR dept_cursor IS
        SELECT deptno, dname
        FROM dept;
BEGIN
    FOR rec IN dept_cursor LOOP
        DBMS_OUTPUT.PUT_LINE(rec.deptno || ' : ' || rec.dname);
    END LOOP;
END;
/

--인자가 있는 커서;
--기존 커서 선언 방법
--    CURSOR 커서이름 IS
--        서브쿼리..;
--        
--인자가 있는 커서 선언방법
--    CURSOR 커서이름(인자1 인자1 타입, 인자2 인자2 타입, ...) IS
--        서브쿼리;
--            (커서 선언시에 작성한 인자를 서브쿼리에서 사용할 수 있다.)

DECLARE
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
    
    CURSOR dept_cursor(p_deptno dept.deptno%TYPE) IS
        SELECT deptno, dname
        FROM dept
        WHERE deptno <= p_deptno;
BEGIN
    FOR rec IN dept_cursor(:deptno) LOOP
        DBMS_OUTPUT.PUT_LINE(rec.deptno || ' : ' || rec.dname);
    END LOOP;
END;
/


select *
from dept;


--커서 속성
--1. SQL%ROWCOUNT
--2. SQL%FOUND
--3. SQL%NOTFOUND
--4. 
--
--FOR LOOP 에서 커서를 인라인 형태로 작성
--FOR 레코드 이름 IN 커서이름
--==>
--FOR 레코드 이름 IN (서브쿼리);
--
--실습;

DECLARE
BEGIN
    FOR rec IN (SELECT deptno, dname FROM dept) LOOP
        DBMS_OUTPUT.PUT_LINE(rec.deptno || ' : ' || rec.dname);
    END LOOP;
END;
/

SELECT *
FROM dept;

 CREATE TABLE DT
(	DT DATE);

insert into dt
select trunc(sysdate + 10) from dual union all
select trunc(sysdate + 5) from dual union all
select trunc(sysdate) from dual union all
select trunc(sysdate - 5) from dual union all
select trunc(sysdate - 10) from dual union all
select trunc(sysdate - 15) from dual union all
select trunc(sysdate - 20) from dual union all
select trunc(sysdate - 25) from dual;

commit;
SELECT *
FROM dt;






DECLARE 
    TYPE dt_tab IS TABLE OF dt%ROWTYPE INDEX BY BINARY_INTEGER;
    v_dt_tab dt_tab;
    v_sum number(5) := 0;
    v_avg number(5) := 0;
BEGIN
    SELECT * BULK COLLECT INTO v_dt_tab
    FROM dt;

    FOR i IN 1..(v_dt_tab.count-1) LOOP
        v_sum := v_sum + TO_NUMBER(TO_CHAR(v_dt_tab(i).dt - v_dt_tab(i+1).dt));
        DBMS_OUTPUT.PUT_LINE(v_sum);
    END LOOP;
    v_avg := v_sum/(v_dt_tab.count-1);
    DBMS_OUTPUT.PUT_LINE(v_avg || ' , '|| v_sum);
END;
/
    
-- cursor로도 해봅시당~ 과제

--분석함수
SELECT avg(gap)
from
(
SELECT DT, lead_dt, dt-lead_dt GAP
FROM
(
SELECT dt, 
        LEAD(DT) OVER(ORDER BY DT DESC) lead_dt
FROM dt));

SELECT (MAX(dt) - MIN(dt)) / (COUNT(dt)-1) avg
FROM dt;
    
    
    
    