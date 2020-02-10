
-- insert
 -- �÷����� ����ϸ� �ش� �÷��� �� �����Ͱ� �ϳ��� �� ( �÷��� �����͸� ��Ȯ�� ��Ī���־����)
 -- �÷����� ������� ������ �ش� ���̺��� ��� ������ ���� VALUES�ȿ� �־������
 
-- NOT NULL�� NULL���� ���� �ʰ� �������� 
--     ->   ������ ���Ἲ : ����ڰ� �ǵ��Ѵ�� ��Ȯ�� �� ��ġ�� �����Ѱ�  
-- 

DESC EMP;

-- empno �÷��� not null ���������� �ִ� - insert�� �ݵ�� ���� �����ؾ� ���������� �Էµȴ�.
-- empno �÷��� ������ ������ �÷��� NULLABLE�̴�( NULL���� ����� �� �ִ�.) 

INSERT INTO emp (empno, ename, job)
VALUES(9999,'brown', NULL);

SELECT *
FROM emp;

-- empno �� NOT NULL���� ������ �ֱ⶧���� �ݵ�� empno�� ���� �־��־���� (NULL�� ������)
INSERT INTO emp(ename, job)
VALUES ('sally', 'SALESMAN');

-- ���ڿ� : ''
-- ���� : 
-- ��¥ : TO_DATE('20200206', 'YYYYMMDD'), SYSDATE

-- emp ���̺��� hiredate�÷��� date Ÿ��
-- emp ���̺��� 8�� �÷��� ���� �Է�

DESC emp;
INSERT INTO emp VALUES(9998, 'sally', 'SALESMAN', NULL, SYSDATE, 1000, NULL,99);
ROLLBACK;

-- �������� �����͸� �ѹ��� INSERT : 
-- INSERT INTO ���̺�� [COL1, COL2, ...]
-- SELECT ...
-- FROM ;W

INSERT INTO emp -- ���̺� �÷� ������� �����͸� �����־��� ������ �÷��� ��� �����൵ ��
SELECT 9998, 'sally', 'SALESMAN', NULL, SYSDATE, 1000, NULL,99 
FROM dual
UNION ALL  --�� ���̺��� �ߺ��� ���°� �츮�� �ƴϱ� ���� UNION�� �����ʴ´� -> ȿ����
SELECT 9999, 'brown', 'CLERK', NULL, TO_date('20200205','YYYYMMDD'), 1100,NULL,99
FROM dual;

SELECT *
FROM emp;


-- 99�� �μ���ȣ�� ���� �μ� ������ DEPT ���̺� �ִ� ��Ȳ
INSERT INTO dept VALUES (99,'ddit', '');
-- 99�� �μ���ȣ�� ���� �μ��� dname �÷��� ���� '���IT', loc �÷��� ���� '���κ���'���� ������Ʈ

UPDATE dept SET dname = '���IT', loc = '���κ���'
WHERE deptno = 99;

SELECT *
FROM dept
WHERE deptno = 99;

-- �Ǽ��� WHERE���� ������� �ʾ��� ���

