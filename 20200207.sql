-- TRUNCATE �׽�Ʈ

-- 1. REDO �α׸� �������� �ʱ� ������ ������ ������ ������ �Ұ��ϴ�.
-- 2. DML(SELECT, INSERT, UPDATE, ELETE)�� �ƴ϶� �� DDL�� �з� -> ROLLBACK �Ұ�

-- �׽�Ʈ �ó�����
-- emp ���̺� ���縦 �Ͽ� emp_copy��� �̸����� ���̺� ����
-- emp_copy ���̺��� ������� TRUNCATE TABLE emp_copy ����

-- emp_copy ���̺� �����Ͱ� �����ϴ���(���������� ������ �Ǿ�����) Ȯ��;

CREATE TABLE emp_copy AS
SELECT *
FROM emp;

TRUNCATE TABLE emp_copy;


-- TRUNCATE TABLE ��ɾ�� DDL �̱� ������ ROLLBACK�� �Ұ��ϴ�.
--
-- ROLLBACK �� SELECT �� �غ��� �����Ͱ� ���� ���� �ʴ� ���� �� �� �ִ�.

-- �� ��ȭ ����

-- Ʈ����� 
-- ������ ���� ����
-- �Ʒ� ���׿��� Ʈ����� �߻�
-- ���õ� ���� DML ������ �ϳ��� ó���ϱ� ���� ���
-- 1. ù��° DML���� �����԰� ���ÿ� Ʈ����� ����
-- 2. ���� �ٸ� DML�� ����
-- 3. COMMIT : Ʈ������� ����, �����͸� Ȯ��
-- 4. ROLLBACK : Ʈ����ǿ��� ������ DML���� ����ϰ� Ʈ����� ����

-- Ʈ������� �߻��ϴ»�Ȳ
-- �Խ��� ÷������? --> ã�Ƽ� ����

-- DCL / DDL 
-- �ڵ� COMMIT, ROLLBACK �Ұ�

-- �б� �ϰ���

-- INSERT �� COMMIT���� ���� ��Ȳ
-- -> SELECT ������ ��ȸ�ص� INSERT�� �����Ѱ� ��ȸ ���� ���� ?
-- COMMIT�Ŀ� ��ȸ����

-- ����Ŭ�� ��Ƽ������ ����

-- Ʈ������� �������� �ٸ� Ʈ����ǿ��� ��� ������ ��ġ���� ����
-- LV 0~3�ܰ�(��4�ܰ�)


-- ISOLATION LEVEL
-- LV 0 : Read Uncommitted
-- ����Ŭ������ ���� ����
-- dirty read
-- COMMIT���� ���� ������ ����ڰ� �� �� �ִ� ��

-- LV 1 : Read Committed
-- ��κ��� DBMS �⺻ ����
-- COMMIT ���� ���� ������ ��ȸ �� �� ����

-- LV 2 : Repeatable Read
-- ���� Ʈ������� ���� �����͸� ���� Ʈ����ǿ��� �����͸� ����, �������� ����
-- -> ���� Ʈ����ǿ��� ���� ��ȸ��
-- ����Ŭ������ ���������� ����x -> for update ���� ���� ����ϰ� ȿ���� �� �� ����
SELECT *
FROM dept
WHERE deptno =10
FOR UPDATE;
-- -> FOR UPDATE�������� deptno 10�� �����Ϳ� lock�� �� ����
-- -> commit�̳� rollback�� �ؾ� lock�� Ǯ��

-- ������ ���� Ʈ����ǿ��� �ű� �Է��� ����
-- Phantom Read : ���� �����Ͱ� ���� ��ȸ�Ǵ� ����

-- LV 3 : Serializable Read

-- isolation ������ ���� ����� ��
-- SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; -> ����3���� �����ϴ� ����
-- ���� Ʈ������� ������ ��ȸ ������ ���� Ʈ������� ���۵� ����
-- ���� Ʈ����ǿ��� ����, �Է�, ������ �����Ͱ� ���� Ʈ����ǿ� ������ ���� ����


-- DBMS�� Ư���� �������� �ʰ� �ϰ��� ������ ���Ƿ� �����ϴ� ���� ����
-- ���� ��翡�� DB�� DBA����


-- BUT ����Ŭ�� LOCKING ��Ŀ������ �ٸ� DBMS�� ���̰� ����
-- �׷��� �ϰ��� ������ �÷��� Ÿ DBMS��ŭ ���ü��� ���ϵ��� ���� --> ��Ƽ ���� ������ ���� �̿��ϱ� ����
-- ������ ��Ŀ������ ���̷� �ٸ� DBMS�� ���� ������ ���� : SNAPSHOT TOO OLD
-- 

-- SQL Ȱ�� PART.2
-- ����~~

-- ����Ŭ�� ��ǥ ��ü
-- TABLE : ������ �����(���� ���� X)
-- INDEX : ��ȸ�� ��������� ���� ������ �÷� ������ ������ �س��� ��ü
-- VIEW : ������ ��ȸ ������ ��ü�� �����Ͽ� �����ϱ� ���� ��ü
-- SEQUENCE : �ߺ����� �ʴ� ���ڸ� ����
-- SYNONYM : ����Ŭ ��ü�� ��Ī

-- ���̺� �÷��� ��Ģ
-- 1. �����ڷ� ����
-- 2. ���̴� 1-30����
-- 3. ���ĺ� ��ҹ��� _ $ #
-- 4.
-- 5.

-- DROP

-- �� DDL : Data Definition Language - ������ ���Ǿ�
-- ��ü�� ����, ����, ������ ���
-- ROLLBACK �Ұ�

-- ���̺� ����
-- CREATE TABLE [��Ű����.]���̺��(            --> ��Ű���� : ���Ӱ����̸�
--      �÷��� �÷�Ÿ�� [DEFALUT �⺻��],
--      �÷���2 �÷�Ÿ��2 [DEFALUT �⺻��], ...
-- );

-- ranger��� �̸��� ���̺� ����
CREATE TABLE ranger(
    ranger_no NUMBER,
    ranger_nm VARCHAR2(50),
    reg_dt DATE DEFAULT SYSDATE
    );


SELECT *
FROM ranger;

INSERT INTO ranger (ranger_no, ranger_nm) VALUES(1, 'brown');

-- ���̺� ����
-- DROP TABLE ���̺��;
-- ���õ� ��ü ���� ����
DROP TABLE ranger;

-- �ٽ��ѹ� �������� DROP TABLE�� ROLLBACK�� �ȉ�...

SELECT *
FROM ranger;


-- �� ������ Ÿ��
-- �� ���ڿ� (VARCHAR2���, CHAR Ÿ�� ��� ����)

-- VARCHAR2(SIZE) : �������� ���ڿ� SIZE : 1~4000BYTE
--                  �ѱ� 1���� : 3BYTE
--                  * ����Ŭ DBMS�� ���ڵ� �������� �ٸ�

-- CHAR(SIZE) : �������� ���ڿ� SIZE : 1~2000BYTE
-- CHAR(10) : �ش� �÷��� ���ڿ��� 5BYTE�� �����ϸ� ������ 5BYTE�� �������� ä���� 
--              'TEST' ==> 'TEST       '


-- �� ����
-- NUMBER(P, S) : P- ��ü�ڸ��� (38), S- �Ҽ��� �ڸ���
-- NUMBER ==> NUMBER(38,0) ���� �ν�
-- INTEGER ==> NUMBER(38,0) ���� �ν�

-- �� ��¥
-- DATE - ���ڿ� �ð� ������ ����
--        7BYTE�� ����
-- ��¥ - DATEŸ������ �����ϴ� ��,
--      - VARCHAR2(8)�� �����ϴ� �� - '20200207'    -- ������ ����� �ٸ��� ������ ��Ȳ�� �°� Ÿ�� �� ������

-- �� �ΰ��� Ÿ���� �ϳ��� �����ʹ� 1BYTE�� ����� ���̰� ����.
-- ������ ���� ���� ���� �Ǹ� ������ �� ���� �������, ����� Ÿ�Կ� ���� ����� �ʿ�

-- LOB(LARGE OBject) - �ִ� 4GB
-- CLOB(Character Large OBject) - VARCHAR2�� ���� �� ���� �������� ���ڿ�(4000BYTE�� �ʰ��ϴ� ���ڿ�)
--                                EX) �� �����Ϳ� ������ HTML �ڵ�
-- BLOB(Byte Large OBject) - ������ �����ͺ��̽��� ���̺��� ������ �� ���
--                         - �Ϲ������� �Խñ� ÷�������� ���̺� ���� �������� �ʰ� ���� ÷�������� ��ũ�� Ư�� ������ �����ϰ�, �ش� [���]�� ���ڿ��� ����
--                         - ������ �ſ� �߿��� ��� : �� ������� ���Ǽ� - > [����]�� ���̺� ����


-- DDL
-- DATE���� Ư�� FIELD�� ���� (TO_CHAR�� ����)
-- SELECT EXTRACT (DAT FROM SYSDTAE)
-- FROM DUAL;

-- �� ��������
-- �����Ͱ� ���Ἲ�� ��Ű���� �ϱ� ���� ����
-- 1. UNIQUE ��������
--    �ش� �÷��� ���� �ٸ� ���� �����Ϳ� �ߺ����� �ʵ��� ����
--    EX) ����� ���� ����� ���� ���� ����.

-- 2. NOT NULL �������� (CHECK ��������)
--    �ش� �÷��� ���� �ݵ�� �����ؾ� �Ѵ�.
--    EX) ��� �÷��� NULL�� ����� ������ ���� ����.
--        ȸ�����Խ� �ʼ� �Է»���(GITHUB - �̸���, �̸�)


-- 3. PRIMARY KEY ��������
--    UNIQUE + NOT NULL
--    EX) ����� ���� ����� ���� ���� ����, ����� ���� ����� ���� ���� ����.
--    PRIMARY KEY ���� ������ ������ ���, �ش� �÷����� UNIQUE INDEX�� �����ȴ�.
--    
--    4. FOREIGN KEY ��������(�������Ἲ)
--       �ش� �÷��� �����ϴ� �ٸ� ���̺� ���� �����ϴ� ���� �־�� �Ѵ�.
--       EX) emp ���̺��� deptno�÷��� dept���̺��� deptno�÷��� ����(����)
--           emp ���̺��� deptno�÷����� dept ���̺��� �������� �ʴ� �μ���ȣ�� �Է� �� �� ����.
--           ����, dept ���̺��� �μ���ȣ�� 10, 20, 30, 40���� ������ ���
--                 emp ���̺� ���ο� ���� �߰��ϸ鼭 �μ���ȣ ���� 99������ ����� ���
--                 �� �߰��� �����Ѵ�.
--                 
--    5. CHECK ��������
--       NOT NULL ���ǵ� CHECK �������ǿ� ����
--       emp ���̺��� JOB �÷��� ��� �� �� �ִ� ���� 'SALESMAN', 'PRESIDENT', 'CLEARK'�� �����ϸ� �� ���� ���ڿ��� ��� �� �� ����

-- �� ���� ���� ���� ��� 
--    1. ���̺��� �����ϸ鼭 �÷��� ���
--    2. ���̺��� �����ϸ鼭 �÷� ��� ���Ŀ� ������ ���������� ���
--    3. ���̺� ������ ������, �߰������� ���������� �߰�
--    
--    CREATE TABLE ���̺��(
--    �÷�1, �÷� Ÿ��[1.��������],
--    �÷�2, �÷� Ÿ��[1.��������],
--    
--     [2.TABLE_CONSTRAINT]
--    );
--    
--    3. ALTER TABLE ���̺��...;
       
       
-- PRIMARY KEY ���������� �÷� ������ ����(1.�� ���)
-- dept���̺��� �����Ͽ� dept_test ���̺��� PRIMARY KEY �������ǰ� �Բ� ����
-- ��, �̹���� ���̺��� key �÷��� ���� �÷��� �Ұ���, ���� �÷��� ���� ����
CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR(13)
    );
INSERT INTO dept_test(deptno) VALUES(99); -- ���������� ����

INSERT INTO dept_test(deptno) VALUES(99); -- �����߻� UNIQUE CONSTRAINT VIOLATED ���� (���ϰ� ���� ħ�� ����)

-- ���������� �� �ɷ� ���� ���
desc dept;

INSERT INTO dept(deptno) VALUES(99);  -- ���� ����ϴ� ���̺� ���������� ���⶧����
INSERT INTO dept(deptno) VALUES(99);  -- �Ȱ��� �μ���ȣ�� ��� ��

desc dept;

SELECT deptno
FROM dept;

ROLLBACK;

--�� �������� Ȯ�� ���
--    1. TOOL�� ���� Ȯ�� -> Ȯ�� �ϰ��� �ϴ� ���̺� ����
--    2. DICTIONARY�� ���� Ȯ��(USER_TABLES);
--         1. USER_CONSTRAINTS ��ųʸ����� ���������� �ɸ� ���̺� �̸� Ȯ��
--            SELECT *
--            FROM USER_CONSTRAINTS
--            WHERE table_name = 'DEPT_TEST'; 
--         2. USER_CONS_COLUMNS ��ųʸ����� constraint_name�� ���̺� �̸��ΰ� �˻�
--            SELECT *
--            FROM USER_CONS_COLUMNS
--            WHERE constraint_name = 'SYS_C007085';    
--    
--    3. �𵨸� (ex: EXERD) Ȯ��

-- �� �������Ǹ��� ������� ���� ��� ����Ŭ���� �������� �̸��� ���Ƿ� �ο� (EX : SYS_C007086)
--- > �������� �������� ������, ��� ��Ģ�� �����ϰ� �����ϴ°� ����, � ������ ����
--    EX) PRIMARY KEY �������� : PK_���̺��;
--        FOREIGN KEY �������� : FK_������̺��_�������̺��;
      
DROP TABLE dept_test;

-- �� �÷� ������ ���� ������ �����ϸ鼭 �������� �̸��� �ο�
-- CONSTRAINT �������Ǹ� �������� Ÿ��(PRIMARY KEY);

CREATE TABLE dept_test(
    deptno NUMBER(2) CONSTRAINT PK_dept_test PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR(13)
    );

INSERT INTO dept_test(dname, loc)VALUES('�̸�','��ġ');
-- ORA-01400: cannot insert NULL into ("JAEHO"."DEPT_TEST"."DEPTNO") ���� ������ ������ �Ǵ��ϱ� ����
    

SELECT *
FROM user_cons_columns
WHERE CONSTRAINT_NAME = 'PK_DEPT_TEST';

2. �÷� ������ �÷� ��� ���� ������ �������� ���;
DROP TABLE dept_test;

CREATE TABLE dept_test(
    deptno NUMBER(2),
    dname VARCHAR2(14),
    loc VARCHAR2(13),
    
    CONSTRAINT PK_dept_test PRIMARY KEY(deptno)
    );
 -- ��ȸ   
SELECT *
FROM user_cons_columns
WHERE constraint_name = 'PK_DEPT_TEST';



--�� NOT NULL  �������� �����ϱ� 
    1. �÷��� ����ϱ� (O)
      ��, �÷��� ����ϸ鼭 ���������� �̸��� �����ϴ°� �ȉ�
    
DROP TABLE dept_test;

CREATE TABLE dept_test(
    deptno NUMBER(2),
    dname VARCHAR2(14) NOT NULL,
    loc VARCHAR2(13),
    
    CONSTRAINT PK_dept_test PRIMARY KEY(deptno)
    );

--NOT NULL �������� Ȯ��;
--INSERT INTO dept_test (deptno, dname) VALUES (99, NULL);
-- ORA-01400: cannot insert NULL into ("JAEHO"."DEPT_TEST"."DNAME")  dname �÷��� NULL ���� ������ ���ٴ� �޽��� ���

--2. ���̺� ������ �÷� ��� ���Ŀ� ���� �����߰�
CREATE TABLE dept_test(
    deptno NUMBER(2),
    dname VARCHAR2(14),
    loc VARCHAR2(13),
    
    CONSTRAINT NN_dept_test_dname CHECK(deptno IS NOT NULL)
    );
    
3. UNIQUE ���� : �ش� �÷��� �ߺ��Ǵ� ���� ������ ���� ����, ��, NULL�� �Է��� ����
    PIRMARY KEY = UNIQUE + NOT NULL;
    
    1. ���̺� ������ �÷� ���� UNIQUE ��������;
    
DROP TABLE dept_test;

CREATE TABLE dept_test(
    deptno NUMBER(2) CONSTRAINT PK_dept_test PRIMARY KEY,
    dname VARCHAR2(14) UNIQUE,
    loc VARCHAR2(13)
    );
    
dept_test ���̺��� dname �÷��� ������ UNIQUE ���������� Ȯ��
INSERT INTO dept_test VALUES (98, 'ddit','daejeon');
INSERT INTO dept_test VALUES (98, 'ddit','daejeon');

    2. ���̺� ������ �÷��� �������� ���, �������� �̸��� �ο�
DROP TABLE dept_test;

CREATE TABLE dept_test(
    deptno NUMBER(2) CONSTRAINT PK_dept_test PRIMARY KEY,
    dname VARCHAR2(14) CONSTRAINT UK_dept_test_dname UNIQUE,
    loc VARCHAR2(13)
    );
    
dept_test ���̺��� dname �÷��� ������ UNIQUE ���������� Ȯ��
INSERT INTO dept_test VALUES (98, 'ddit','daejeon');
INSERT INTO dept_test VALUES (98, 'ddit','daejeon');

-- ORA-00001: unique constraint (JAEHO.PK_DEPT_TEST) violated

2. ���̺� ������ �÷� ��� ���� �������� ����- �����÷� (deptno-danme�� �����ؾ߸� �ߺ����� �ν�)(UNIQUE)
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2),
    dname VARCHAR2(14),
    loc VARCHAR2(13),
    
    CONSTRAINT UK_dept_test_deptno_danme UNIQUE (deptno,dname)
    );
���� �÷��� ���� UNIQUE ���� Ȯ��(deptno, dname);
INSERT INTO dept_test VALUES(99,'ddit','daejeon');
INSERT INTO dept_test VALUES(98,'ddit','daejeon');  -- �Ѵ� ���������� ���� 
INSERT INTO dept_test VALUES(98,'ddit','daejeon');  -- deptno�� dname�� ���� INSERT���̶� ��Ȯ�ϰ� ���� ������ ������
 --ORA-00001: unique constraint (JAEHO.UK_DEPT_TEST_DEPTNO_DANME) violated
 
--�� FOREIGN KEY ��������
--    �����ϴ� ���̺��� Į���� �����ϴ� ���� ��� ���̺��� �÷��� �Է��� �� �ֵ��� ����
--    EX) emp���̺��� deptno�÷��� ���� �Է��� ��, dept ���̺��� deptno�÷��� �����ϴ� �μ���ȣ�� �Է��� �� �ֵ��� ����
--        �������� �ʴ� �μ���ȣ�� emp ���̺��� ������� ���ϰԲ� ����

1. dept_test ���̺� ����
2. emp_test ���̺� ����
   -> emp_test ���̺� ���� �� deptno�÷����� dept.deptno�÷��� �����ϵ��� FK�� ����;
   
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
    deptno NUMBER(2) REFERENCES dept_test (deptno), -- dept_test���̺��� deptno �÷��� ����.
    
    CONSTRAINT PK_emp_test PRIMARY KEY(empno)
    );

--������ �Է¼���
--emp_test ���̺� �����͸� �Է��ϴ°� �����Ѱ�?
-- -> ���ݻ�Ȳ(dept_test, emp_test ���̺��� ��� ����- �����Ͱ� �������� ����)

INSERT INTO emp_test VALUES(9999,'brown',NULL); -- NULL�� ����
INSERT INTO emp_test VALUES(9998,'sally',10);  -- ORA-01438: value larger than specified precision allowed for this column

-- dept_test ���̺� �����͸� �غ�
INSERT INTO dept_test VALUES(99,'ddit','daejeon');
INSERT INTO emp_test VALUES(9998,'ddit',10);
INSERT INTO emp_test VALUES(9998,'ddit',99);

drop table emp_test;
drop table dept_test;


--���̺� ������ �÷� ��� ���� FOREIGN KEY �������� ����

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
    
INSERT INTO emp_test VALUES (9999,'brown',10); -- dept_test ���̺� 10���μ��� �������� �ʾ� ����
INSERT INTO emp_test VALUES (9999,'brown',99); -- dept_test ���̺� 99�� �μ��� �����ϹǷ� �������

-- ���� exred  counsel ���̺�, ���������� �����ϴ� �������� ���� �Ͷ�  ���� ���� ����
