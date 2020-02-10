--  ����Ŭ������ PK �������� ����
--  �ε����� tree����

-- 1. PRIMARY KEY ���� ���� ������ ����Ŭ DBMS�� �ش� �÷����� UNIQUE INDEX�� �ڵ����� �����Ѵ�.
--   INDEX : �ش��÷����� �̸� ������ �س��� ��ü
--   ������ �Ǿ� �ֱ� ������ ã���� �ϴ� ���� �����ϴ��� ������ �� �� �ִ�.
--   ����, �ε����� ���ٸ� ���ο� �����͸� �Է��� �� �ߺ��� ���� ã�� ���ؼ� �־��� ��� ���̺��� ��� �����͸� ã�ƾ� �Ѵ�.
--   ������ �ε����� ������ �̹� ������ �Ǿ��ֱ� ������ �ش� ���� ���� ������ ������ �� �� �ִ�.
--     * �� ��Ȯ�� ���ϸ� UNIQUE �������ǿ� ���� �ε����� �����ȴ�.

-- 2. FOREING KEY ��������
--    �����ϴ� ���̺� ���� �ִ����� Ȯ���ؾ� �Ѵ�.
--    �׷���, �����ϴ� �÷��� �ε����� �־������ FOREING KEY ������ ������ �� �ִ�.

--FOREIGN KEY ������ �ɼ�
-- FOREIGN KEY (���� ���Ἲ) : �����Ϸ��� ���̺��� �÷��� �����ϴ� ���� �Էµ� �� �ֵ��� ����
--  EX) emp ���̺� ���ο� �����͸� �Է½� deptno �÷����� dept ���̺� �����ϴ� �μ���ȣ�� �Է� �� �� �ִ�.
--  
-- FOREIGN KEY�� �����ʿ� ���� �����͸� ������ �� ������
-- � ���̺��� �����ϰ� �ִ� �����͸� �ٷ� ������ �� ����
--  EX) emp.detpno ==> dept.deptno �÷��� �����ϰ� ���� ��
--      dept.detpno�� �����͸� ������ �� ����
      
select *
from dept_test;
INSERT INTO dept_test VALUES (98,'ddit2','����');
INSERT INTO emp_test (empno, ename, deptno) VALUES (9999,'brown',99);

--emp : 9999,99
--dept : 99,99
--==> 98�� �μ��� �����ϴ� emp ���Ը��� �����ʹ� ����
--==> 99�� �μ��� �����ϴ� emp ���̺��� �����ʹ� 9999�� brown�� ����

--���࿡ ���� ������ �����ϰ� �Ǹ�?
DELETE dept_test 
WHERE deptno = 99;
-- ORA-02292: integrity constraint (JAEHO.FK_EMP_TEST_DEPT_TEST) violated - child record found �����߻�
 
DELETE dept_test 
WHERE deptno = 98;
--==> emp_test���� 98�� �μ��� �����ϴ� �����Ͱ� ���� ������ ���� ����
--
--FOREIGN KEY �ɼ�
--1. ON DELETE CASCADE : �θ� ������ ���(dept_test) �����ϴ� �ڽ� �����͵� ���� �����Ѵ�(emp_test)
--    * �����ؼ� �� �Ⱦ�
--2. ON DELETE SET NULL : �θ� ������ ���(dept_test) �����ϴ� �ڽ� �������� �÷��� null�� ����
--
--emp_test ���̺��� DROP�� �ɼ��� ������ ���� ���� �� ���� �׽�Ʈ
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


-- emp_test ���̺��� deptno �÷��� dept_test ���̺��� deptno�÷��� ����(on delete cascade)
--�ɼǿ� ���� �θ����̺�(dept_test) ������ �����ϰ� �ִ� �ڽ� �����͵� ���� �����ȴ�.

DELETE dept_test
WHERE deptno = 99;
--�ɼ� �ο����� �ʾ��� ���� ���� delete ������ ������ �߻�
--�ɼǿ� ���� �����ϴ� �ڽ� ���̺��� �����Ͱ� ���������� ������ �Ǿ����� select Ȯ��
-- ==> ON DELETE CASCADE �ɼ��� �־��� ������ ������

SELECT *
FROM emp_test;


-- FK ON DELETE SET NULL �׽�Ʈ
-- �θ����̺��� ������ ������ �����ϴ� �ڽ� ���̺��� �÷��� NULL�� ����

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

-- dept_test���̺��� 99�� �μ��� �����ϰ� �Ǹ�(�θ� ���̺��� �����ϸ�)
-- 99�� �μ��� �����ϴ� emp_test ���̺��� 9999��(brown) �������� deptno �÷���
-- FK �ɼǿ� ���� NULL�� �����Ѵ�.

DELETE dept_test
WHERE deptno = 98;

-- �θ� ���̺��� ������ ���� �� �ڽ� ���̺��� �����Ͱ� null�� ����Ǿ����� Ȯ��

SELECT *
FROM emp_test;

-- CHECK �������� : �÷��� ���� ���� ������ ������ �� ���
--    ex) �޿� �÷��� ���ڷ� ����, �޿��� ������ �� �� ������?
--        �Ϲ����� ��� �޿����� > 0
--        CHECK ������ ����� ��� �޿����� 0 ���� ū ���� ������ �˻� ����,
--        emp ���̺��� job�÷��� ���� ���� ���� 4������ ���Ѱ���
--        'SALESMAN', 'PRESIDENT', 'ANALYST', 'MANAGER'
--        
--���̺� ������ �÷� ����� �Բ� CHECK ���� ����
--emp_test ���̺��� sal �÷��� 0���ٴ� ũ�ٴ� CHECK �������� ����
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
INSERT INTO emp_test VALUES (9999,'brown',99,1000); -- �������
INSERT INTO emp_test VALUES (9999,'brown',99,-1000); -- CHECK���ǿ� ���� sal�� 0���� ū ���� �Է°���

--CTAS
-- ���ο� ���̺� ����
-- CREATE TABLE ���̺��(
--    �÷�1...
--);
--
-- CREATE TABLE ���̺�� AS
-- SELECT ����� ���ο� ���̺�� ����

--EMP ���̺��� �̿��ؼ� �μ���ȣ�� 10���� ����鸸 ��ȸ�Ͽ� �ش� �����ͷ�
--emp_test2 ���̺��� ����
    
CREATE TABLE emp_test2 AS
SELECT *
FROM emp
WHERE deptno=10;

SELECT *
FROM emp_test2;

-- CTAS�� NOT NULL ���� ���� �̿��� ���� ������ ������� �ʴ´�.
        

-- ���̺���
--1. �÷��߰�
--2.�÷� �������, Ÿ�Ժ���
--3. �⺻�� ����
--4. �÷����� rename
--5. �÷��� ����
--6. �������� �߰�/����
--
--1. �÷��߰�
DROP TABLE emp_test;
CREATE TABLE EMP_TEST(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2),
    
    CONSTRAINT PK_emp_test PRIMARY KEY (empno),
    CONSTRAINT FK_emp_test_dept_test FOREIGN KEY (deptno) REFERENCES dept_test (deptno)
    );

--ALTER TABLE ���̺�� ADD (�ű��÷��� �ű��÷� Ÿ��)

ALTER TABLE emp_test ADD (hp VARCHAR2(20));

DESC EMP_TEST;

-- 2. �÷� ������ ����, Ÿ�Ժ���
-- EX) �÷� VARCHAR2(20) -==> VARCHAR2(5)
--    ������ �����Ͱ� ������ ���, ���������� ������ �ȵ� Ȯ���� �ſ� ����
--    �Ϲ������� �����Ͱ� �������� �ʴ� ����, �� ���̺��� ������ ���Ŀ� �÷��� ������, 
--    Ÿ���� �߸� �� ��� �÷� ������,. Ÿ���� ������
--    
--     �����Ͱ� �Էµ� ���ķδ� Ȱ�뵵�� �ſ� ������(������ �ø��� �͸� ����)
     
--hp VARCHAR2(20) ==> hp VARCHAR2(30);
--
--ALTER ���̺�� MODIFY (���� �÷��� �ű� �÷�Ÿ��(������));

ALTER TABLE emp_test MODIFY (hp VARCHAR2(30));

ALTER TABLE emp_test MODIFY (hp NUMBER);

--3, �÷� �⺻�� ����
--
--ALTER TABLE ���̺�� MODIFY(�÷��� DEFAULT �⺻��)

ALTER TABLE emp_test MODIFY(hp VARCHAR2(20) DEFAULT '010');
SELECT *
FROM dept_test;

INSERT INTO dept_test VALUES (99,'brown',9999);
--hp �÷����� ���� ���� �ʾ����� DEFAULT ������ ���� '010' ���ڿ��� �⺻������ ����ȴ�
INSERT INTO emp_test (empno, ename, deptno) VALUES (9999,'brown',99);

SELECT *
FROM emp_test;


-- 4.����� �÷� ����
-- �����Ϸ��� �ϴ� �÷��� FK, PK���������� �־ �� ���� ��������
--ALTER TABLE ���̺�� RENAME COLUMN ���� �÷��� TO �ű� �÷���;

ALTER TABLE emp_test RENAME COLUMN hp TO hp_n;

--���̺� ���� 5. �÷�����
--
--ALTER TABLE ���̺�� DROP COLUMN �÷Ÿ�

--emp_test ���̺��� hp_n�÷� ����;

ALTER TABLE emp_test DROP COLUMN hp_n;

--1. EMP ���̺��� DROP �� empno, ename, deptno, hp 4���� �÷����� ���̺� ����
--2. empno, ename, deptno 3���� �÷����� (9999,'brown',99) �����ͷ� INSERT
--3. emp_test ���̺��� hp �÷��� �⺻���� 010���� ����
--4. 2�� ������ �Է��� �������� hp �÷� ���� ��� �ٲ���� Ȯ��

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

--6. �������� �߰�/ ����;
--ALTER TABLE ���̺�� ADD CONSTRAINT �������Ǹ� �������� Ÿ��(PRIMARY KEY, FOREIGN KEY)(�ش��÷�);
--ALTER TABLE ���̺�� DROP CONSTRAINT �������Ǹ�;

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

--�������� Ȱ��ȭ / ��Ȱ��ȭ
--
--ALTER TABLE ���̺�� ENABLE | DISABLE CONSTRAINT �������Ǹ�;

--1. emp_test ���̺� ����
--2. emp_test ���̺� ����
--3. ALTER TABLE PRIMARY KEY(empno), FOREIGN KEY(dept_test.deptno)�������� ����
--4. �ΰ��� ���������� ��Ȱ��ȭ
--5. ��Ȱ��ȭ�� �մ� ��Ȯ����

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

-- ���������� ��Ȱ��ȭ -> Ȱ��ȭ�Ҷ��� �����Ϸ��� �������ǿ� �����ϴ� �����Ͱ� ����־�� Ȱ��ȭ ����

--dept_test ���̺� �������� �ʴ� �μ���ȣ 98�� emp_test���� �����
--1. dept_test ���̺� 98�� �μ��� ����ϰų� 
--2. sally�� �μ���ȣ�� 99������ �����ϰų�;

SELECT *
FROM EMP_test;

SELECT *
FROM dept_test;

