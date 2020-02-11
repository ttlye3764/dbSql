--���� ���� Ȯ�� ���
--1. tool
--2. dictionsary view
--
--���� ���� : USER_CONSTRAINTS
--�������� �÷� : USER_CONS_COLUMNS
----> �������� ���� : ���������� ��� �÷��� ���õǾ� �ִ��� �� �� ���� ������ ���̺��� ������ �и��Ͽ� ����
--
--1. ������

SELECT *
FROM USER_CONSTRAINTS
WHERE table_name IN('EMP', 'DEPT', 'EMP_TEST', 'DEPT_TEST');

emp, dept pk, fk ���������� ����

emp : pk (empno)
      fk (deptno) -> (dept.deptno) : (fk ������ �����ϱ� ���ؼ��� �����ϴ� ���̺� �÷��� �ε����� �����ؾ� �Ѵ�.)
      
dept : pk(deptno)

SELECT *
FROM emp;
ALTER TABLE emp ADD CONSTRAINTS PK_empa PRIMARY KEY (empno);
ALTER TABLE dept ADD CONSTRAINTS PK_depta PRIMARY KEY (deptno);
ALTER TABLE emp ADD CONSTRAINTS FK_emp_depta FOREIGN KEY (deptno) REFERENCES dept (deptno);


-- ERD
-- ������ �����Ͼ
-- �ڸ�Ʈ ����

-- ���̺�, �÷� �ּ� Ȯ�� : DICTIONARY�� ���� Ȯ�ΰ���
-- ���̺� �ּ� : USER_TAB_COMMENTS;
-- �÷� �ּ� : USER_COL_COMMENTS;
SELECT *
FROM USER_TAB_COMMENTS
WHERE TABLE_NAME IN('CUSTOMER', 'PRODUCT', 'CYCLE', 'DAILY');

SELECT *
FROM USER_COL_COMMENTS
WHERE TABLE_NAME IN('CUSTOMER', 'PRODUCT', 'CYCLE', 'DAILY');



-- �ּ�����
-- ���̺� �ּ� : COMMENT ON TABLE ���̺�� IS '�ּ�';
-- �÷� �ּ� : COMMENT ON COLUMN ���̺�.�÷��� IS '�ּ�';

COMMENT ON TABLE emp IS '����';
COMMENT ON TABLE dept IS '�μ�';

COMMENT ON COLUMN dept.deptno IS '�μ���ȣ';
COMMENT ON COLUMN dept.dname IS '�μ���';
COMMENT ON COLUMN dept.loc IS '�μ���ȣ';
COMMENT ON COLUMN emp.empno IS '���� ��ȣ';
COMMENT ON COLUMN emp.ename IS '���� �̸�';
COMMENT ON COLUMN emp.job IS '������';
COMMENT ON COLUMN emp.mgr IS '�Ŵ��� ������ȣ';
COMMENT ON COLUMN emp.hiredate IS '�Ի�����';
COMMENT ON COLUMN emp.sal IS '�޿�';
COMMENT ON COLUMN emp.comm IS '������';
COMMENT ON COLUMN emp.deptno IS '�ҼӺμ���ȣ';

-- comments �ǽ�
-- USER_TAB_COMMENTS, USER_COL_COMMENTS VIEW�� �̿��Ͽ�
-- customer, product, cycle, daily ���̺�� �÷��� �ּ� ������ ��ȸ�ϴ� ������ �ۼ��϶�.

SELECT A.TABLE_NAME, A.TABLE_TYPE, A.COMMENTS TAB_COMMENT, B.COLUMN_NAME, B.COMMENTS COL_COMMENT
FROM 
(SELECT *
FROM USER_TAB_COMMENTS
WHERE TABLE_NAME IN('CUSTOMER', 'PRODUCT', 'CYCLE', 'DAILY')) A,
(SELECT *
FROM USER_COL_COMMENTS
WHERE TABLE_NAME IN('CUSTOMER', 'PRODUCT', 'CYCLE', 'DAILY')) B
WHERE A.TABLE_NAME = B.TABLE_NAME;


-- DDL(VIEW)
-- �޿� ������ ���������� ���� ��Ű�� ���� ������..
-- 1. �÷�����
-- ���� ����ϴ� ������� ��Ȱ��
-- ���� ���� ����

-- VIEW = QUERY 
-- TABLEó�� �̸� DMBS�� �̸� �ۼ��� ��ü
-- ==> �ۼ����� �ʰ� QUERY���� �ٷ� �ۼ��� VIEW : IN-LINEVIEW(�̸��� ���� ������ ��Ȱ���� �Ұ�)
-- VIEW�� ���̺��̴� (X)

--������ 
--1. ���� ����(Ư�� �÷��� �����ϰ� ������ ����� �����ڿ��� ����)
--2. INLINE-VIEW�� VIEW�� �����ؼ� ��Ȱ�� -> ���� ���� ����
--
--���� ���
--CREATE [OR REPLACE] VIEW ���Ī [(col1, col2. ...)] AS          OR REPLACE�� ������ DROP�����ʰ� �������� 
--SBUQUERY;
--
--emp ���̺��� 8�� �÷��� sal, comm�÷��� ������ 6�� �÷��� �����ϴ� v_emp VIEW ����

CREATE OR REPLACE VIEW v_emp AS
SELECT empno,ename, job, mgr, hiredate, deptno
FROM emp;
--> "insufficient privileges" ���� '������� ����'
--> �����ڰ� view�� ���������ϴ°� ��� �ٶ������� ���� dba�� �ϴ°� �ùٸ�

-- �ý��� �������� jaeho �������� view ���� ���� �߰�;
GRANT CREATE VIEW TO JAEHO;

--���� �ζ��� ��� �ۼ���
SELECT *
FROM (SELECT empno, ename, job, mgr, hiredate, deptno
     FROM emp);
     
    -- view ���
    select *
    from v_emp;
    
emp ���̺��� �μ����� ���� == > dept ���̺�� ������ ����ϰ� ����
���ε� ����� view�� ���� �س����� �ڵ带 �����ϰ� �ۼ��ϴ°� ����;

VIEW : V_emp_dept;
dname(�μ���), empno(������ȣ), ename(�����̸�), job(������), hiredate(�Ի�����)

CREATE OR REPLACE VIEW V_emp_dept AS
SELECT dept.dname, emp.empno, emp.ename, emp.job, emp.hiredate
FROM emp, dept
WHERE emp.deptno = dept.deptno;

-- �ζ��κ� ����
SELECT *
FROM (
SELECT dept.dname, emp.empno, emp.ename, emp.job, emp.hiredate
FROM emp, dept
WHERE emp.deptno = dept.deptno);

-- �� ����
SELECT *
FROM V_emp_dept;

-- ���� �����Ͱ� ���ϸ� view�� ���ұ�?
-- SMITH���� ���� �� V_emp_dept_ view �Ǽ� ��ȭ�� Ȯ��;


-- �����Ȱ� �ݿ��ȴ�
--  -> ������


--�׷� �Լ� ��� x -> simple view
--dml ���� �Ϲ������� ���� -> �ٵ� �߾���
--
--�׷� �Լ� ��� - > complex view
--dml ���� �Ұ���
--group by
--distance
--rownum �� ��������ϸ� dml�Ұ���
--
---- squence
--�����Ϳ� key �÷��� ���� �����ؾ� ��
--������ ���� ����� ���
--1. key table(�̸� ���� ���� �ص� ���̺�)
--
--2. uuid / Ȥ�� ������ ���̺귯��
--
--3. sequence
--������ ���� ���� �������ִ� ����Ŭ ��ü
-- - pk �÷��� ������ ������ �� ����
 
--CREATE SEQUENCE squence_name 

-- SEQUENCE : ������ - �ߺ����� ���� �������� �������ִ� ����Ŭ ��ü
--�������
--CREATE SEQUENCE ������_�̸�;
--[OPTION ... ] ;  -> �˻��ؼ� ã�ƺ���
--����Ģ :  SEQ_����� ���̺��; (�Ϲ����� ����Ģ)
--
--EMP ���̺��� ����� ������ ����
CREATE SEQUENCE seq_emp;

--������ ���� �Լ�
--1. NEXTVAL : ���������� ���� ���� ������ �� ���
--2. CURRVAL : NEXTVAL�� ����ϰ��� ���� �о� ���� ���� ��Ȯ��

SELECT seq_emp.NEXTVAL
FROM dual;

SELECT seq_emp.CURRVAL
FROM dual;

-- ������ ��� ���� ���̺� ���� ����

INSERT INTO emp_test VALUES (seq_emp.NEXTVAL, 'james', 99, '017') ;

SELECT *
FROM emp_test;

�������� �������� ����� �� ����ȭ�Ҷ� �ʿ���
           MASTER 

SALVE1     SLAVE2    SLAVE3
1 - 100  101 - 200  201 -300


-- DDL(INDEX) �߿�
-- �����س��� ���� ���� ã�ư��� ����
-- ���̺��� �Ϻ� �÷��� �������� �����͸� ������ ��ü
-- ���̺��� ROW�� ����Ű�� �ּҸ� ������ �ִ�.(ROWID)
    -- ROWID �� ���̺��� �ּ�
    SELECT ROWID, emp.*
    FROM emp;
    -- �ּҸ� �˸� �ٷ� ���� ����
    SELECT *
    FROM EMP
    WHERE ROWID = 'AAAE5dAAFAAAACLAAD';
-- ���ĵ� �ε����� �������� �ش� ROW�� ��ġ�� ������ �˻��Ͽ� ���̺��� ���ϴ� �࿡ ������ ����
-- ���̺� �����͸� �Է��ϸ� �ε��� ������ ���ŵȴ�.

�׿����� TABLE
�Է� ������� ������ ���� : �� �������� ��� (DELETE ������ �� �������� ��� ����)
��뷮 ���̺� ������ �� ������ ��� �б� �߻� 

-- �ε��� ����Ҷ�
-- �ּ����� ������ ��� �б⸦ ���� �������
-- ��� ?

FULL TABLE SCAN
���̺� ���а� WHERE���� �ɸ��°� ������ -> �а� ������
INDEX SCAN
���ϴ� �͸� �г� -> �� �ʿ��� �Ÿ� �г�
FAST FULL INDEX SCAN

-- �ε��� ���� ?

-- INDEX �ǽ�
-- �ε����� ���� �� empno ������ ��ȸ�ϴ� ���;
-- emp ���̺��� pk_empa ���������� �����ؼ� empno�÷����� �ε����� �������� �ʴ� ȯ���� ����
ALTER TABLE emp DROP CONSTRAINT PK_empa;
-- tool���� Ȯ���ϴϱ� ������
EXPLAIN PLAN FOR
SELECT *
FROM EMP
WHERE empno = 7782; 
--> �� �߳����µ� ���� ��ȹ�� ����

SELECT *
FROM TABLE(dbms_xplan.display);

Plan hash value: 3956160932
 
--------------------------------------------------------------------------
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |     1 |    38 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP  |     1 |    38 |     3   (0)| 00:00:01 |   -- emp ���̺� ���а�
--------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("EMPNO"=7782)                                                  -- WHERE�� ���ǿ��� �ɷ��� ����
   
   
-- �ε����� ���� ��
-- �ٽ� �ε��� �����ϱ����� PRIMARY KEY ��������
ALTER TABLE emp ADD CONSTRAINT PK_empa PRIMARY KEY (empno);
--> empno �÷����� UNIQUE �ε����� ����

EXPLAIN PLAN FOR
SELECT *
FROM EMP
WHERE empno = 7782; 
--> �� �߳����µ� ���� ��ȹ�� ����

SELECT *
FROM TABLE(dbms_xplan.display);

Plan hash value: 3532656865
 
---------------------------------------------------------------------------------------
| Id  | Operation                   | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
---------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |         |     1 |    38 |     1   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP     |     1 |    38 |     1   (0)| 00:00:01 |
|*  2 |   INDEX UNIQUE SCAN         | PK_EMPA |     1 |       |     0   (0)| 00:00:01 |
---------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("EMPNO"=7782)

SELECT rowid, emp.*
from emp;

SELECT empno, ROWID
FROM emp;
ORDER BY empno; --> �ε����� �̷� ������ �Ǿ� ����

--SELECT ��ȸ �÷��� ���̺� ���ٿ� ��ġ�� ����;
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;

EXPLAIN PLAN FOR
SELECT empno 
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE (dbms_xplan.display);

--UNIQUE VS NON-UNIQUE �ε��� ���� Ȯ��
--1. PK_empa ����
--2. empno �÷����� NON-UNIQUE �ε��� ���� (CREATE INDEX idx_n_���̺�_���° ON ���̺�� (�÷���));
--3. �����ȹ Ȯ��

ALTER TABLE emp DROP CONSTRAINT PK_empa;

CREATE INDEX idx_n_emp_01 ON emp (empno);
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(dbms_xplan.display);

--INDEX �ǽ� 2
--emp ���̺� job �÷��� �������� �ϴ� ���ο� non-unique �ε����� ����

CREATE INDEX idx_n_emp_02 ON emp(job);

-- �ε����� �ָ� �� ����ó�� �����ȴٴ� �Ҹ�
SELECT job, ROWID
FROM emp
ORDER BY job;

-- �̷���Ȳ���� �ؿ� ���� ������ �˻��ض�!
SELECT *
FROM emp
WHERE job = 'MANAGER';
--���� ������ ��Ȳ
--1. EMP ���̺��� ��ü �б�
--2. idx_n_emp_01�� �ε��� Ȱ��
--3. idx_n_emp_02�� �ε��� Ȱ��
-- �ٵ� �츮�� ���� ������� �˻��� �� �ۿ� ���µ� ����Ŭ�� ���� ��ȹ�� ������ �� ȿ������ ������ �ڵ� ��������




