--INDEX �ǽ�
--1. TABLE FULL
--2. idx1 : empno
--2. idx2 : job

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

SELECT *
FROM TABLE(dbms_xplan.display);

--------------------------------------------------------------------------------------------
| Id  | Operation                   | Name         | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |              |     1 |    38 |     2   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS BY INDEX ROWID| EMP          |     1 |    38 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_N_EMP_02 |     3 |       |     1   (0)| 00:00:01 |
--------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("ENAME" LIKE 'C%')
   2 - access("JOB"='MANAGER');
-- �ΰ��� �÷��� �ε��� ����

CREATE INDEX idx_n_emp_03 ON emp (job, ename);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job ='MANAGER' 
AND ename LIKE 'C%';

SELECT *
FROM TABLE(dbms_xplan.display);

--------------------------------------------------------------------------------------------
| Id  | Operation                   | Name         | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |              |     1 |    38 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP          |     1 |    38 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_N_EMP_03 |     1 |       |     1   (0)| 00:00:01 |
--------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("JOB"='MANAGER' AND "ENAME" LIKE 'C%')
       filter("ENAME" LIKE 'C%');
       
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job ='MANAGER' 
AND ename LIKE '%C';

-- %�� �Ǿտ� ������ �ε����� �� ó�� �����ͺ��� �о�� �ؼ� �ε����� �ǹ̰� ũ�� ����.

SELECT *
FROM TABLE(dbms_xplan.display);


--1.TABLE FULL
--2.idx1 : empno
--3.idx2 : job
--4.idx3 : job + ename
--5.idx4 : ename + job

CREATE INDEX idx4_n_emp_O4 ON emp(ename,job);

-- �ε��� ���� ����� ����� �����
SELECT ename, job, ROWID
FROM emp
ORDER BY ename, job; 

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'J%';

SELECT *
FROM TABLE(dbms_xplan.display);
       
-- �������� �����ϴ� �ε����� �̚���ؼ� �׻� �ε����� ����ϴ� ���� �ƴ�

-- DBMS�� ��Ƽ�������� �Ǵܿ� ���� �ε��� ��ĵ�� �� ���� �ְ� ���̺� ��ü ��ĵ�� �� ���� ����

-- ��Ƽ�������� ��Ȳ�� �°� ������ ������ �����ȹ�� �ۼ�
-- HINT�� ���� �����ڰ� ���ϴ� �����ȹ �ۼ�����



-- JOIN

����� �� �ִ� ����� ��
emp - TABLE FULL, PK_empa(empno)
dept - - TABLE FULL, PK_dept(deptno)

emp - TABLE FULL, dept-TABLE FULL
dept-TABLE FULL, emp - TABLE FULL

emp - TABLE FULL, dept - PK_dept
dept - PK_dept, emp - TABLE FULL

emp - PK_emp, dept - TABLE FULL
dep - TABLE FULL, emp - PK_emp

emp - PK_emp, dept - PK_dept
dept - PK_dept, emp - PK_emp

--1.����
--ORACLE - �ǽð� ���� OLTP (ON LINE TRANSACTION PROCESSING) (�ǽð� ������ �߿�)

--       - ��ü ó���ð� : OLAP (ON LINE ANALYSIS PROCESSING) - ������ ������ �����ȹ�� ����µ� 30��~1�ð����� �ɸ��⵵��
--                 * ����ڰ� ���� �Ǵ� �͵� .. BACK JOB���� ���ư� (��ü ó���ð��� �켱, ��� ó���� �߿��Ѱ� �ƴ�, ��� �����ȹ�� �����ؼ� ����)

--2. N�� ���̺� ����
--   ���� ������ ���̺� �ε����� 5���� �ִٸ�
--   �� ���̺� ���� ���� : 6��
--   �� ����� �� : 6 * N * 2 

-- �������� �� emp���� ������ dept ���� ������??
EXPLAIN PLAN FOR
SELECT ename, dname, loc
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.empno = 7788;

SELECT *
FROM TABLE(dbms_xplan.display);

Plan hash value: 3315830739

4 - 3 - 5 - 2 - 6 - 1 - 0
 
----------------------------------------------------------------------------------------------
| Id  | Operation                     | Name         | Rows  | Bytes | Cost (%CPU)| Time     |
----------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT              |              |     1 |    33 |     3   (0)| 00:00:01 |
|   1 |  NESTED LOOPS                 |              |       |       |            |          |
|   2 |   NESTED LOOPS                |              |     1 |    33 |     3   (0)| 00:00:01 |   
|   3 |    TABLE ACCESS BY INDEX ROWID| EMP          |     1 |    13 |     2   (0)| 00:00:01 |   
|*  4 |     INDEX RANGE SCAN          | IDX_N_EMP_01 |     1 |       |     1   (0)| 00:00:01 |   
|*  5 |    INDEX UNIQUE SCAN          | PK_DEPTA     |     1 |       |     0   (0)| 00:00:01 |   
|   6 |   TABLE ACCESS BY INDEX ROWID | DEPT         |     1 |    20 |     1   (0)| 00:00:01 |
----------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   4 - access("EMP"."EMPNO"=7788)
   5 - access("EMP"."DEPTNO"="DEPT"."DEPTNO")


-- index vs TABLE FULL ACCESS
-- �ε���
-- �Ҽ��� ������ ��ȸ �� ���� : ����ӵ��� �߿��� ��
-- I/O ������ single block : �ٷ��� �����͸� �ε����� �����ϸ� ���̺� ��ü ��ȸ���� ������ ������.
-- ���̺��� �� �÷����� �ε����� ������������
-- ������ ���Խ� �÷����� �����۾��� �̷������ ������ �δ��� �����Ѵ�.
-- -> SELECT ���� ������ �� ������ UPDATE, INSERT, DELETE�� ���ϰ� Ŀ����.
-- �ȸ���� ���� ������ ���� ���̺��� ��� �� 5��? ������ MAX
 �ý��ۿ��� ����Ǵ� ��� ������ �м��Ͽ� ���� �ε����� �����ϴ� �۾��� ����� ;

-- TABLE FULL ACCESS
-- ���̺��� ��� �����͸� �о ó���ϴ� ����� �ε������� ����
-- I/O�� ������ MULTI BLOCK 
-- �ε����� �а� �����ϴ� ? 




--�ε��� �񱳿����� ����??
--1. cims_cd(=)
--2. cs_rcv_id(=), cs_rcv_(between)
--3. cs_rcv_(between), cs_rcv_id(=), = , =, = , LIKE

���̺� �ε����� ���ٸ� PPT���� 105��?;

--���� �ε���
 PPT �����ؼ� ���� 106��;
 
CREATE TABLE dept_test2 AS
SELECT *
FROM dept
WHERE 1=1;
SELECT * FROM DEPT_TEST2;



ALTER TABLE dept_test2 ADD CONSTRAINT PK_dept_test2 PRIMARY KEY (deptno);
CREATE INDEX idx_n_dept_test2_01 ON dept_test2(dname);
CREATE INDEX idx_n_dept_test2_02 ON dept_test2 (deptno, dname);

DROP INDEX idx_n_dept_test2_02;


emp  empno - PRIMARY KEY
     ename - NON-UNIQUE 
     sal, deptno - NON-UNIQUE
     empno, mgr = non-UNIQUE
     
desc dept;
CREATE TABLE emp1(
    EMPNO NUMBER(4) NOT NULL,
    ENAME VARCHAR2(10), 
    JOB VARCHAR2(9),
    MGR NUMBER(4),    
    HIREDATE DATE,         
    SAL NUMBER(7,2),
    COMM NUMBER(7,2),  
    DEPTNO NUMBER(2)    
    );
DROP TABLE dpet1;
CREATE TABLE dpet1(
    dept NUMBER(2) NOT NULL,
    dname VARCHAR2(14),
    loc VARCHAR2(13)
);

CREATE TABLE dept1 AS
SELECT *
FROM dept
WHERE 1=1;


--1.
EXPLAIN PLAN FOR
SELECT *
FROM EMP1
WHERE empno = 7369;

access pattern
empno(=)

--�ذ� 
ALTER TABLE emp1 ADD CONSTRAINT PK_emp1 PRIMARY KEY (empno);
ALTER TABLE dept1 ADD CONSTRAINT PK_dept1 PRIMARY KEY (deptno);

--2. 
EXPLAIN PLAN FOR
SELECT *
FROM emp1
WHERE ename = 'SMITH' ;

access pattern
ename(=)
    
--�ذ�
CREATE INDEX idx_emp1_ename ON emp1 (ename);

3.
EXPLAIN PLAN FOR
SELECT *
FROM emp1 e, dept1 d
WHERE e.deptno = d.deptno
AND e.deptno = 20
AND e.empno LIKE 7 || '%';

access pattern
deptno(=), empno(LIKE ������ȣ)

-- �ذ�
CREATE INDEX idx_emp1_deptno_empno ON emp1(deptno);
DROP INDEX idx_emp1_deptno_empno;

SELECT *
FROM emp1;


DROP INDEX idx_emp1_deptno;

SELECT *
FROM TABLE(dbms_xplan.display);

--4��
EXPLAIN PLAN FOR
SELECT *
FROM emp1
WHERE sal BETWEEN 2000 AND 3000
AND deptno = 20;
-- �ذ�


--5��
EXPLAIN PLAN FOR
SELECT b.*
FROM emp1 a, emp1 b
WHERE a.mgr = b.empno
AND a.deptno = 20;


DROP INDEX idx_emp1_mgr;

--6��
EXPLAIN PLAN FOR
SELECT deptno, TO_CHAR(hiredate, 'yyyymm'), COUNT(*) cnt
FROM emp1
GROUP BY deptno, TO_CHAR(hiredate, 'yyyymm');

-- ���� �ε���
ALTER TABLE emp1 ADD CONSTRAINT PK_emp1 PRIMARY KEY (empno);
--ALTER TABLE dept1 ADD CONSTRAINT PK_dept1 PRIMARY KEY (deptno);
CREATE INDEX idx_emp1_ename ON emp1 (ename);
CREATE INDEX idx_emp1_deptno ON emp1(deptno);




