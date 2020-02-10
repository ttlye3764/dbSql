--  오라클에서는 PK 기준으로 정렬
--  인덱스는 tree구조

-- 1. PRIMARY KEY 제약 조건 생성시 오라클 DBMS는 해당 컬럼으로 UNIQUE INDEX를 자동으로 생성한다.
--   INDEX : 해당컬럼으로 미리 정렬을 해놓은 객체
--   정렬이 되어 있기 때문에 찾고자 하는 값이 존재하는지 빠르게 알 수 있다.
--   만약, 인덱스가 없다면 새로운 데이터를 입력할 때 중복된 값을 찾기 위해서 최악의 경우 테이블의 모든 데이터를 찾아야 한다.
--   하지만 인덱스가 있으면 이미 정렬이 되어있기 때문에 해당 값의 존재 유무를 빠르게 알 수 있다.
--     * 더 정확히 말하면 UNIQUE 제약조건에 의해 인덱스가 생성된다.

-- 2. FOREING KEY 제약조건
--    참조하는 테이블에 값이 있는지를 확인해야 한다.
--    그래서, 참조하는 컬럼에 인덱스가 있어야지만 FOREING KEY 제약을 생성할 수 있다.

--FOREIGN KEY 생성시 옵션
-- FOREIGN KEY (참조 무결성) : 참조하려는 테이블의 컬럼에 존재하는 값만 입력될 수 있도록 제한
--  EX) emp 테이블에 새로운 데이터를 입력시 deptno 컬럼에는 dept 테이블에 존재하는 부서번호만 입력 될 수 있다.
--  
-- FOREIGN KEY가 생성됨에 따라 데이터를 삭제할 때 유의점
-- 어떤 테이블에서 참조하고 있는 데이터를 바로 삭제할 수 없음
--  EX) emp.detpno ==> dept.deptno 컬럼을 참조하고 있을 때
--      dept.detpno의 데이터를 삭제할 수 없음
      
select *
from dept_test;
INSERT INTO dept_test VALUES (98,'ddit2','대전');
INSERT INTO emp_test (empno, ename, deptno) VALUES (9999,'brown',99);

--emp : 9999,99
--dept : 99,99
--==> 98번 부서를 참조하는 emp 테입르의 데이터는 없음
--==> 99번 부서를 참조하는 emp 테이블의 데이터는 9999번 brown이 있음

--만약에 다음 쿼리를 실항하게 되면?
DELETE dept_test 
WHERE deptno = 99;
-- ORA-02292: integrity constraint (JAEHO.FK_EMP_TEST_DEPT_TEST) violated - child record found 에러발생
 
DELETE dept_test 
WHERE deptno = 98;
--==> emp_test에서 98번 부서를 참조하는 데이터가 없기 때문에 삭제 가능
--
--FOREIGN KEY 옵션
--1. ON DELETE CASCADE : 부모가 삭제될 경우(dept_test) 참조하는 자식 데이터도 같이 삭제한다(emp_test)
--    * 위험해서 잘 안씀
--2. ON DELETE SET NULL : 부모가 삭제될 경우(dept_test) 참조하는 자식 데이터의 컬럼을 null로 설정
--
--emp_test 테이블을 DROP후 옵션을 번갈아 가면 생성 후 삭제 테스트
DROP TABLE emp_test;

CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2),
    
    CONSTRAINT PK_emp_test PRIMARY KEY (empno),
    CONSTRAINT FK_emp_test_dept_test FOREIGN KEY(deptno)
                REFERENCES dept_test(deptno) ON DELETE CASCADE
);

INSERT INTO emp_test VALUES(9999,'brown', 99);


-- emp_test 테이블의 deptno 컬럼은 dept_test 테이블의 deptno컬럼을 참조(on delete cascade)
--옵션에 따라서 부모테이블(dept_test) 삭제시 참조하고 있는 자식 데이터도 같이 삭제된다.

DELETE dept_test
WHERE deptno = 99;
--옵션 부여하지 않았을 때는 위의 delete 쿼리가 에러가 발생
--옵션에 따라서 참조하는 자식 테이블의 데이터가 정상적으로 삭제가 되었는지 select 확인
-- ==> ON DELETE CASCADE 옵션을 주었기 때문에 삭제됌

SELECT *
FROM emp_test;


-- FK ON DELETE SET NULL 테스트
-- 부모테이블의 데이터 삭제시 참조하는 자식 테이블의 컬럼을 NULL로 만듬

DROP TABLE emp_test;

CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2),
    
    CONSTRAINT PK_emp_test PRIMARY KEY (empno),
    CONSTRAINT FK_emp_test_dept_test FOREIGN KEY(deptno)
                REFERENCES dept_test(deptno) ON DELETE SET NULL
);

INSERT INTO emp_test VALUES(9999,'brown', 98);

-- dept_test테이블의 99번 부서를 삭제하게 되면(부모 테이블을 삭제하면)
-- 99번 부서를 참조하는 emp_test 테이블의 9999번(brown) 데이터의 deptno 컬럼을
-- FK 옵션에 따라 NULL로 변경한다.

DELETE dept_test
WHERE deptno = 98;

-- 부모 테이블의 데이터 삭제 후 자식 테이블의 데이터가 null로 변경되었는지 확인

SELECT *
FROM emp_test;

-- CHECK 제약조건 : 컬럼에 들어가는 값은 종류를 제한할 때 사용
--    ex) 급여 컬럼을 숫자로 관리, 급여가 음수가 들어갈 수 있을까?
--        일반적인 경우 급여값은 > 0
--        CHECK 제약을 사용할 경우 급여값이 0 보다 큰 값이 들어가는지 검사 가능,
--        emp 테이블의 job컬럼에 들어가는 값을 다음 4가지로 제한가능
--        'SALESMAN', 'PRESIDENT', 'ANALYST', 'MANAGER'
--        
--테이블 생성시 컬럼 기술과 함께 CHECK 제약 생성
--emp_test 테이블의 sal 컬럼이 0보다는 크다는 CHECK 제약조건 생성
DROP TABLE emp_test;
CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2),
    sal NUMBER CHECK (sal >0),
    
    CONSTRAINT PK_test PRIMARY KEY (empno),
    CONSTRAINT FK_emp_test_dept_test FOREIGN KEY (deptno) REFERENCES dept_test (deptno)
    );
INSERT INTO dept_test VALUES (99,'brown',99);    
select *
from dept_test;

delete emp_test
WHERE deptno=99;
INSERT INTO emp_test VALUES (9999,'brown',99,1000); -- 정상삽입
INSERT INTO emp_test VALUES (9999,'brown',99,-1000); -- CHECK조건에 따라 sal이 0보다 큰 값만 입력가능

--CTAS
-- 새로운 테이블 생성
-- CREATE TABLE 테이블명(
--    컬럼1...
--);
--
-- CREATE TABLE 테이블명 AS
-- SELECT 결과를 새로운 테이블로 생성

--EMP 테이블을 이용해서 부서번호가 10번인 사원들만 조회하여 해당 데이터로
--emp_test2 테이블을 생성
    
CREATE TABLE emp_test2 AS
SELECT *
FROM emp
WHERE deptno=10;

SELECT *
FROM emp_test2;

-- CTAS는 NOT NULL 제약 조건 이외의 제약 조건은 복사되지 않는다.
        

-- 테이블변경
--1. 컬럼추가
--2.컬럼 사이즈변경, 타입변경
--3. 기본값 설정
--4. 컬러명을 rename
--5. 컬럼을 삭제
--6. 제약조건 추가/삭제
--
--1. 컬럼추가
DROP TABLE emp_test;
CREATE TABLE EMP_TEST(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2),
    
    CONSTRAINT PK_emp_test PRIMARY KEY (empno),
    CONSTRAINT FK_emp_test_dept_test FOREIGN KEY (deptno) REFERENCES dept_test (deptno)
    );

--ALTER TABLE 테이블명 ADD (신규컬럼명 신규컬럼 타입)

ALTER TABLE emp_test ADD (hp VARCHAR2(20));

DESC EMP_TEST;

-- 2. 컬럼 사이즈 변경, 타입변경
-- EX) 컬럼 VARCHAR2(20) -==> VARCHAR2(5)
--    기존에 데이터가 존재할 경우, 정상적으로 실행이 안될 확률이 매우 높음
--    일반적으로 데이터가 존재하지 않는 상태, 즉 테이블을 생성한 직후에 컬럼의 사이즈, 
--    타입이 잘못 된 경우 컬럼 사이즈,. 타입을 변경함
--    
--     데이터가 입력된 이후로는 활용도가 매우 떨어짐(사이즈 늘리는 것만 가능)
     
--hp VARCHAR2(20) ==> hp VARCHAR2(30);
--
--ALTER 테이블명 MODIFY (기존 컬럼명 신규 컬럼타입(사이즈));

ALTER TABLE emp_test MODIFY (hp VARCHAR2(30));

ALTER TABLE emp_test MODIFY (hp NUMBER);

--3, 컬럼 기본값 설정
--
--ALTER TABLE 테이블명 MODIFY(컬럼명 DEFAULT 기본값)

ALTER TABLE emp_test MODIFY(hp VARCHAR2(20) DEFAULT '010');
SELECT *
FROM dept_test;

INSERT INTO dept_test VALUES (99,'brown',9999);
--hp 컬럼에는 값을 넣지 않았지만 DEFAULT 설정에 의해 '010' 문자열이 기본값으로 저장된다
INSERT INTO emp_test (empno, ename, deptno) VALUES (9999,'brown',99);

SELECT *
FROM emp_test;


-- 4.변경시 컬럼 변경
-- 변경하려고 하는 컬럼이 FK, PK제약조건이 있어도 다 같이 가져와줌
--ALTER TABLE 테이블명 RENAME COLUMN 기존 컬럼명 TO 신규 컬럼명;

ALTER TABLE emp_test RENAME COLUMN hp TO hp_n;

--테이블 변경 5. 컬럼삭제
--
--ALTER TABLE 테이블명 DROP COLUMN 컬렴명

--emp_test 테이블에서 hp_n컬럼 삭제;

ALTER TABLE emp_test DROP COLUMN hp_n;

--1. EMP 테이블을 DROP 후 empno, ename, deptno, hp 4개의 컬럼으로 테이블 생성
--2. empno, ename, deptno 3가지 컬럼에만 (9999,'brown',99) 데이터로 INSERT
--3. emp_test 테이블의 hp 컬럼의 기본값을 010으로 설정
--4. 2번 과정에 입력한 데이터의 hp 컬럼 값이 어떻게 바뀌는지 확인

DROP TABLE emp_test;

CREATE TABLE emp_test(
    empno NUMBER(4),
    enmae VARCHAR2(10),
    deptno NUMBER(2),
    hp NUMBER DEFAULT '010'
);

INSERT INTO emp_test (empno, enmae, deptno) VALUES(9999,'brown',99);

SELECT *
FROM emp_test;

--6. 제약조건 추가/ 삭제;
--ALTER TABLE 테이블명 ADD CONSTRAINT 제약조건명 제약조건 타입(PRIMARY KEY, FOREIGN KEY)(해당컬럼);
--ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건명;

DROP TABLE emp_test;
CREATE TABLE emp_test(
    empno NUMBER(4),
    enmae VARCHAR2(10),
    deptno NUMBER(2)
);

ALTER TABLE emp_test ADD CONSTRAINT PK_emp_test PRIMARY KEY (empno);

ALTER TABLE emp_test ADD CONSTRAINT FK_emp_test_dept_test FOREIGN KEY (deptno) REFERENCES dept_test (deptno);

INSERT INTO emp_test VALUES(9999,'brown',99);




SELECT *
FROM dept_test;

ALTER TABLE emp_test DROP CONSTRAINT PK_emp_test;
ALTER TABLE emp_test DROP CONSTRAINT FK_emp_test_dept_test;


INSERT INTO emp_test VALUES (9999,'brwon',99);

INSERT INTO emp_test VALUES (9999,'AA',88);

SELECT *
FROM emp_test;

--제약조건 활성화 / 비활성화
--
--ALTER TABLE 테이블명 ENABLE | DISABLE CONSTRAINT 제약조건명;

--1. emp_test 테이블 삭제
--2. emp_test 테이블 생성
--3. ALTER TABLE PRIMARY KEY(empno), FOREIGN KEY(dept_test.deptno)제약조건 생성
--4. 두개의 제약조건을 비활성화
--5. 비활성화되 잇는 지확ㅇ니

DROP TABLE emp_test;
CREATE TABLE emp_test(
    emptno NUMBER(4),
    ename VARCHAR(10),
    deptno NUMBER(2)
);
ALTER TABLE emp_test ADD CONSTRAINT  PK_emp_test PRIMARY KEY (emptno);
ALTER TABLE emp_test ADD CONSTRAINT FK_emp_test_dept_test FOREIGN KEY (deptno) REFERENCES dept_test(deptno);

ALTER TABLE emp_test DISABLE CONSTRAINT PK_emp_test;
ALTER TABLE emp_test DISABLE CONSTRAINT FK_emp_test_dept_test;

ALTER TABLE emp_test ENABLE CONSTRAINT PK_emp_test;
ALTER TABLE emp_test ENABLE CONSTRAINT FK_emp_test_dept_test;

-- 제약조건을 비활성화 -> 활성화할때는 설정하려는 제약조건에 만족하는 데이터가 들어있어야 활성화 가능

--dept_test 테이블에 존재하지 않는 부서번호 98을 emp_test에서 사용중
--1. dept_test 테이블에 98번 부서를 등록하거나 
--2. sally의 부서번호를 99번으로 변경하거나;

SELECT *
FROM EMP_test;

SELECT *
FROM dept_test;

