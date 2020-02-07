-- TRUNCATE 테스트

-- 1. REDO 로그를 생성하지 않기 때문에 삭제시 데이터 복구가 불가하다.
-- 2. DML(SELECT, INSERT, UPDATE, ELETE)가 아니라 ★ DDL로 분류 -> ROLLBACK 불가

-- 테스트 시나리오
-- emp 테이블 복사를 하여 emp_copy라는 이름으로 테이블 생성
-- emp_copy 테이블을 대상으로 TRUNCATE TABLE emp_copy 실행

-- emp_copy 테이블에 데이터가 존재하는지(정상적으로 삭제가 되었는지) 확인;

CREATE TABLE emp_copy AS
SELECT *
FROM emp;

TRUNCATE TABLE emp_copy;


-- TRUNCATE TABLE 명령어는 DDL 이기 때문에 ROLLBACK이 불가하다.
--
-- ROLLBACK 후 SELECT 를 해보면 데이터가 복구 되지 않는 것을 알 수 있다.

-- ● 고립화 레벨

-- 트랜잭션 
-- 논리적인 일의 단위
-- 아래 사항에서 트랜잭션 발생
-- 관련된 여러 DML 문장을 하나로 처리하기 위해 사용
-- 1. 첫번째 DML문을 실행함과 동시에 트랜잭션 시작
-- 2. 이후 다른 DML문 실행
-- 3. COMMIT : 트랜잭션을 종료, 데이터를 확정
-- 4. ROLLBACK : 트랜잭션에서 실행한 DML문을 취소하고 트랜잭션 종료

-- 트랜잭션이 발생하는상황
-- 게시판 첨부파일? --> 찾아서 정리

-- DCL / DDL 
-- 자동 COMMIT, ROLLBACK 불가

-- 읽기 일관성

-- INSERT 후 COMMIT하지 않은 상황
-- -> SELECT 문으로 조회해도 INSERT로 삽입한게 조회 되지 않음 ?
-- COMMIT후에 조회가능

-- 오라클은 멀티블럭으로 관리

-- 트랜잭션의 실행결과가 다른 트랜잭션에게 어떻게 영향을 미치는지 정의
-- LV 0~3단계(총4단계)


-- ISOLATION LEVEL
-- LV 0 : Read Uncommitted
-- 오라클에서는 지원 안함
-- dirty read
-- COMMIT하지 않은 정보를 사용자가 볼 수 있는 거

-- LV 1 : Read Committed
-- 대부분의 DBMS 기본 설정
-- COMMIT 되지 않은 정보를 조회 할 수 없음

-- LV 2 : Repeatable Read
-- 선행 트랜잭션이 읽은 데이터를 후행 트랜잭션에서 데이터를 수정, 삭제하지 못함
-- -> 선행 트랜잭션에서 같은 조회를
-- 오라클에서는 공식적으로 지원x -> for update 절을 통해 비슷하게 효과를 낼 수 있음
SELECT *
FROM dept
WHERE deptno =10
FOR UPDATE;
-- -> FOR UPDATE구문으로 deptno 10인 데이터에 lock을 건 개념
-- -> commit이나 rollback을 해야 lock이 풀림

-- 하지만 후행 트랜잭션에서 신규 입력은 가능
-- Phantom Read : 없던 데이터가 새로 조회되는 현상

-- LV 3 : Serializable Read

-- isolation 레벨을 조정 해줘야 됌
-- SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; -> 레벨3으로 조정하는 쿼리
-- 선행 트랜잭션의 데이터 조회 기준은 선행 트랜잭션이 시작된 지점
-- 후행 트랜잭션에서 수정, 입력, 삭제된 데이터가 선행 트랜잭션에 영향을 주지 않음


-- DBMS의 특성을 생각하지 않고 일관성 레벨을 임의로 수정하는 것은 위험
-- 약은 약사에게 DB는 DBA에게


-- BUT 오라클은 LOCKING 메커니즘이 다른 DBMS와 차이가 있음
-- 그래서 일관성 레벨을 올려도 타 DBMS만큼 동시성이 저하되지 않음 --> 멀티 버전 데이터 블럭을 이용하기 때문
-- 하지만 메커니즘의 차이로 다른 DBMS에 없는 에러가 있음 : SNAPSHOT TOO OLD
-- 

-- SQL 활용 PART.2
-- 오예~~

-- 오라클의 대표 객체
-- TABLE : 데이터 저장소(순서 보장 X)
-- INDEX : 조회시 성능향상을 위해 정해진 컬럼 순으로 정렬을 해놓은 객체
-- VIEW : 데이터 조회 쿼리를 객체로 생성하여 재사용하기 위한 객체
-- SEQUENCE : 중복되지 않는 숫자를 생성
-- SYNONYM : 오라클 객체의 별칭

-- 테이블 컬럼명 규칙
-- 1. 영문자로 시작
-- 2. 길이는 1-30글자
-- 3. 알파벳 대소문자 _ $ #
-- 4.
-- 5.

-- DROP

-- ● DDL : Data Definition Language - 데이터 정의어
-- 객체를 생성, 수정, 삭제시 사용
-- ROLLBACK 불가

-- 테이블 생성
-- CREATE TABLE [스키마명.]테이블명(            --> 스키마명 : 접속계정이름
--      컬럼명 컬럼타입 [DEFALUT 기본값],
--      컬럼명2 컬럼타입2 [DEFALUT 기본값], ...
-- );

-- ranger라는 이름의 테이블 생성
CREATE TABLE ranger(
    ranger_no NUMBER,
    ranger_nm VARCHAR2(50),
    reg_dt DATE DEFAULT SYSDATE
    );


SELECT *
FROM ranger;

INSERT INTO ranger (ranger_no, ranger_nm) VALUES(1, 'brown');

-- 테이블 삭제
-- DROP TABLE 테이블명;
-- 관련된 객체 같이 삭제
DROP TABLE ranger;

-- 다시한번 말하지만 DROP TABLE은 ROLLBACK이 안됌...

SELECT *
FROM ranger;


-- ● 데이터 타입
-- ○ 문자열 (VARCHAR2사용, CHAR 타입 사용 지양)

-- VARCHAR2(SIZE) : 가변길이 문자열 SIZE : 1~4000BYTE
--                  한글 1글자 : 3BYTE
--                  * 오라클 DBMS의 인코딩 설정마다 다름

-- CHAR(SIZE) : 고정길이 문자열 SIZE : 1~2000BYTE
-- CHAR(10) : 해당 컬럼에 문자열을 5BYTE만 지정하면 나머지 5BYTE는 공백으로 채워짐 
--              'TEST' ==> 'TEST       '


-- ○ 숫자
-- NUMBER(P, S) : P- 전체자리수 (38), S- 소수점 자리수
-- NUMBER ==> NUMBER(38,0) 으로 인식
-- INTEGER ==> NUMBER(38,0) 으로 인식

-- ○ 날짜
-- DATE - 일자와 시간 정보를 저장
--        7BYTE로 고정
-- 날짜 - DATE타입으로 관리하는 곳,
--      - VARCHAR2(8)로 관리하는 곳 - '20200207'    -- 데이터 사이즈가 다르기 때문에 상황에 맞게 타입 잘 쓰세용

-- 위 두개의 타입은 하나의 데이터당 1BYTE의 사이즈가 차이가 난다.
-- 데이터 양이 많아 지게 되면 무시할 수 없는 사이즈로, 설계시 타입에 대한 고려가 필요

-- LOB(LARGE OBject) - 최대 4GB
-- CLOB(Character Large OBject) - VARCHAR2로 담을 수 없는 사이즈의 문자열(4000BYTE를 초과하는 문자열)
--                                EX) 웹 에디터에 생성된 HTML 코드
-- BLOB(Byte Large OBject) - 파일을 데이터베이스의 테이블에서 관리할 때 사용
--                         - 일반적으로 게시글 첨부파일을 테이블에 직접 관리하지 않고 보통 첨부파일을 디스크의 특정 공간에 저장하고, 해당 [경로]만 문자열로 관리
--                         - 파일이 매우 중요한 경우 : 고객 정보사용 동의서 - > [파일]을 테이블에 저장


-- DDL
-- DATE에서 특정 FIELD를 추출 (TO_CHAR와 동일)
-- SELECT EXTRACT (DAT FROM SYSDTAE)
-- FROM DUAL;

-- ○ 제약조건
-- 데이터가 무결성을 지키도록 하기 위한 설정
-- 1. UNIQUE 제약조건
--    해당 컬럼의 값이 다른 행의 데이터와 중복되지 않도록 제약
--    EX) 사번이 같은 사원이 있을 수가 없다.

-- 2. NOT NULL 제약조건 (CHECK 제약조건)
--    해당 컬럼에 값이 반드시 존재해야 한다.
--    EX) 사번 컬럼이 NULL인 사원은 존재할 수가 없다.
--        회원가입시 필수 입력사항(GITHUB - 이메일, 이름)


-- 3. PRIMARY KEY 제약조건
--    UNIQUE + NOT NULL
--    EX) 사번이 같은 사원이 있을 수가 없고, 사번이 없는 사람이 있을 수가 없다.
--    PRIMARY KEY 제약 조건을 생성할 경우, 해당 컬럼으로 UNIQUE INDEX가 생성된다.
--    
--    4. FOREIGN KEY 제약조건(참조무결성)
--       해당 컬럼이 참조하는 다른 테이블에 값이 존재하는 행이 있어야 한다.
--       EX) emp 테이블의 deptno컬럼이 dept테이블의 deptno컬럼을 참조(관계)
--           emp 테이블의 deptno컬럼에는 dept 테이블이 존재하지 않는 부서번호가 입력 될 수 없다.
--           만약, dept 테이블의 부서번호가 10, 20, 30, 40번만 존재할 경우
--                 emp 테이블에 새로운 행을 추가하면서 부서번호 값을 99번으로 등록할 경우
--                 행 추가가 실패한다.
--                 
--    5. CHECK 제약조건
--       NOT NULL 조건도 CHECK 제약조건에 포함
--       emp 테이블의 JOB 컬럼에 들어 올 수 있는 값을 'SALESMAN', 'PRESIDENT', 'CLEARK'로 설정하면 이 세개 문자열만 들어 올 수 있음

-- ○ 제약 조건 생성 방법 
--    1. 테이블을 생성하면서 컬럼에 기술
--    2. 테이블을 생성하면서 컬럼 기술 이후에 별도로 제약조건을 기술
--    3. 테이블 생성과 별도로, 추가적으로 제약조건을 추가
--    
--    CREATE TABLE 테이블명(
--    컬럼1, 컬럼 타입[1.제약조건],
--    컬럼2, 컬럼 타입[1.제약조건],
--    
--     [2.TABLE_CONSTRAINT]
--    );
--    
--    3. ALTER TABLE 테이블명...;
       
       
-- PRIMARY KEY 제약조건을 컬럼 레벨로 생성(1.번 방식)
-- dept테이블을 참고하여 dept_test 테이블을 PRIMARY KEY 제약조건과 함께 생성
-- 단, 이방식은 테이블의 key 컬럼이 복합 컬럼은 불가능, 단일 컬럼일 때만 가능
CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR(13)
    );
INSERT INTO dept_test(deptno) VALUES(99); -- 정상적으로 실행

INSERT INTO dept_test(deptno) VALUES(99); -- 오류발생 UNIQUE CONSTRAINT VIOLATED 오류 (유일값 조건 침범 오류)

-- 제약조건이 안 걸려 있을 경우
desc dept;

INSERT INTO dept(deptno) VALUES(99);  -- 원래 사용하던 테이블에 제약조건이 없기때문에
INSERT INTO dept(deptno) VALUES(99);  -- 똑같은 부서번호가 계속 들어감

desc dept;

SELECT deptno
FROM dept;

ROLLBACK;

--○ 제약조건 확인 방법
--    1. TOOL을 통해 확인 -> 확인 하고자 하는 테이블 선택
--    2. DICTIONARY를 통해 확인(USER_TABLES);
--         1. USER_CONSTRAINTS 딕셔너리에서 제약조건이 걸린 테이블 이름 확인
--            SELECT *
--            FROM USER_CONSTRAINTS
--            WHERE table_name = 'DEPT_TEST'; 
--         2. USER_CONS_COLUMNS 딕셔너리에서 constraint_name이 테이블 이름인것 검색
--            SELECT *
--            FROM USER_CONS_COLUMNS
--            WHERE constraint_name = 'SYS_C007085';    
--    
--    3. 모델링 (ex: EXERD) 확인

-- ○ 제약조건명을 기술하지 않을 경우 오라클에서 제약조건 이름을 임의로 부여 (EX : SYS_C007086)
--- > 가독성이 떨어지기 때문에, 명명 규칙을 지정하고 생성하는게 개발, 운영 관리에 유리
--    EX) PRIMARY KEY 제약조건 : PK_테이블명;
--        FOREIGN KEY 제약조건 : FK_대상테이블명_참조테이블명;
      
DROP TABLE dept_test;

-- ○ 컬럼 레벨의 제약 조건을 생성하면서 제약조건 이름을 부여
-- CONSTRAINT 제약조건명 제약조건 타입(PRIMARY KEY);

CREATE TABLE dept_test(
    deptno NUMBER(2) CONSTRAINT PK_dept_test PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR(13)
    );

INSERT INTO dept_test(dname, loc)VALUES('이름','위치');
-- ORA-01400: cannot insert NULL into ("JAEHO"."DEPT_TEST"."DEPTNO") 무슨 오류가 났는지 판단하기 편함
    

SELECT *
FROM user_cons_columns
WHERE CONSTRAINT_NAME = 'PK_DEPT_TEST';

2. 컬럼 생성시 컬럼 기술 이후 별도로 제약조건 기술;
DROP TABLE dept_test;

CREATE TABLE dept_test(
    deptno NUMBER(2),
    dname VARCHAR2(14),
    loc VARCHAR2(13),
    
    CONSTRAINT PK_dept_test PRIMARY KEY(deptno)
    );
 -- 조회   
SELECT *
FROM user_cons_columns
WHERE constraint_name = 'PK_DEPT_TEST';



--○ NOT NULL  제약조건 생성하기 
    1. 컬럼에 기술하기 (O)
      단, 컬럼에 기술하면서 제약조건의 이름을 설정하는건 안됌
    
DROP TABLE dept_test;

CREATE TABLE dept_test(
    deptno NUMBER(2),
    dname VARCHAR2(14) NOT NULL,
    loc VARCHAR2(13),
    
    CONSTRAINT PK_dept_test PRIMARY KEY(deptno)
    );

--NOT NULL 제약조건 확인;
--INSERT INTO dept_test (deptno, dname) VALUES (99, NULL);
-- ORA-01400: cannot insert NULL into ("JAEHO"."DEPT_TEST"."DNAME")  dname 컬럼에 NULL 값을 넣을수 없다는 메시지 출력

--2. 테이블 생성시 컬럼 기술 이후에 제약 조건추가
CREATE TABLE dept_test(
    deptno NUMBER(2),
    dname VARCHAR2(14),
    loc VARCHAR2(13),
    
    CONSTRAINT NN_dept_test_dname CHECK(deptno IS NOT NULL)
    );
    
3. UNIQUE 제약 : 해당 컬럼에 중복되는 값이 들어오는 것을 방지, 단, NULL은 입력이 가능
    PIRMARY KEY = UNIQUE + NOT NULL;
    
    1. 테이블 생성시 컬럼 레벨 UNIQUE 제약조건;
    
DROP TABLE dept_test;

CREATE TABLE dept_test(
    deptno NUMBER(2) CONSTRAINT PK_dept_test PRIMARY KEY,
    dname VARCHAR2(14) UNIQUE,
    loc VARCHAR2(13)
    );
    
dept_test 테이블의 dname 컬럼에 설정된 UNIQUE 제약조건을 확인
INSERT INTO dept_test VALUES (98, 'ddit','daejeon');
INSERT INTO dept_test VALUES (98, 'ddit','daejeon');

    2. 테이블 생성시 컬럼에 제약조건 기술, 제약조건 이름을 부여
DROP TABLE dept_test;

CREATE TABLE dept_test(
    deptno NUMBER(2) CONSTRAINT PK_dept_test PRIMARY KEY,
    dname VARCHAR2(14) CONSTRAINT UK_dept_test_dname UNIQUE,
    loc VARCHAR2(13)
    );
    
dept_test 테이블의 dname 컬럼에 설정된 UNIQUE 제약조건을 확인
INSERT INTO dept_test VALUES (98, 'ddit','daejeon');
INSERT INTO dept_test VALUES (98, 'ddit','daejeon');

-- ORA-00001: unique constraint (JAEHO.PK_DEPT_TEST) violated

2. 테이블 생성시 컬럼 기술 이후 제약조건 생성- 복합컬럼 (deptno-danme이 동일해야만 중복으로 인식)(UNIQUE)
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2),
    dname VARCHAR2(14),
    loc VARCHAR2(13),
    
    CONSTRAINT UK_dept_test_deptno_danme UNIQUE (deptno,dname)
    );
복합 컬럼에 대한 UNIQUE 제약 확인(deptno, dname);
INSERT INTO dept_test VALUES(99,'ddit','daejeon');
INSERT INTO dept_test VALUES(98,'ddit','daejeon');  -- 둘다 정상적으로 삽입 
INSERT INTO dept_test VALUES(98,'ddit','daejeon');  -- deptno과 dname이 위의 INSERT문이랑 정확하게 같기 때문에 오류남
 --ORA-00001: unique constraint (JAEHO.UK_DEPT_TEST_DEPTNO_DANME) violated
 
--○ FOREIGN KEY 제약조건
--    참조하는 테이블의 칼럼에 존재하는 값만 대상 테이블의 컬럼에 입력할 수 있도록 설정
--    EX) emp테이블의 deptno컬럼에 값을 입력할 때, dept 테이블의 deptno컬럼에 존재하는 부서번호만 입력할 수 있도록 설정
--        존재하지 않는 부서번호를 emp 테이블에서 사용하지 못하게끔 방지

1. dept_test 테이블 생성
2. emp_test 테이블 생성
   -> emp_test 테이블 생성 시 deptno컬럼으로 dept.deptno컬럼을 참조하도록 FK를 설정;
   
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2),
    dname VARCHAR2(14),
    loc VARCHAR(13),
    
    CONSTRAINT PK_dept_test PRIMARY KEY (deptno)
    );
DROP TABLE emp_test;
DESC emp;

CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2) REFERENCES dept_test (deptno), -- dept_test테이블의 deptno 컬럼을 참조.
    
    CONSTRAINT PK_emp_test PRIMARY KEY(empno)
    );

--데이터 입력순서
--emp_test 테이블에 데이터를 입력하는게 가능한가?
-- -> 지금상황(dept_test, emp_test 테이블을 방금 생성- 데이터가 존재하지 않음)

INSERT INTO emp_test VALUES(9999,'brown',NULL); -- NULL은 가능
INSERT INTO emp_test VALUES(9998,'sally',10);  -- ORA-01438: value larger than specified precision allowed for this column

-- dept_test 테이블에 데이터를 준비
INSERT INTO dept_test VALUES(99,'ddit','daejeon');
INSERT INTO emp_test VALUES(9998,'ddit',10);
INSERT INTO emp_test VALUES(9998,'ddit',99);

drop table emp_test;
drop table dept_test;


--테이블 생성시 컬럼 기술 이후 FOREIGN KEY 제약조건 생성

DROP TABLE  EMP_TEST ;
DROP TABLE  dept_test ;

CREATE TABLE dept_test(
    deptno NUMBER(2),
    dname VARCHAR2(14),
    loc VARCHAR(13),
    
    CONSTRAINT PK_dept_test PRIMARY KEY (deptno)
    );
    
CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2),
    
    CONSTRAINT FK_emp_test_dept_test FOREIGN KEY(deptno) REFERENCES dept_test (deptno)
    );
INSERT INTO dept_test VALUES (99,'ddit','daejeon');
    
INSERT INTO emp_test VALUES (9999,'brown',10); -- dept_test 테이블에 10번부서가 존재하지 않아 에러
INSERT INTO emp_test VALUES (9999,'brown',99); -- dept_test 테이블에 99번 부서가 존재하므로 정상실행

-- 과제 exred  counsel 테이블, 제약조건을 생성하는 쿼리문을 만들어서 와라  오늘 배운거 기준
