SELECT * FROM lprod;

SELECT buyer_id, buyer_name FROM buyer;

SELECT * FROM cart;

SELECT mem_id, mem_pass, mem_name FROM member;

--users ���̺� ��ȸ
--users ���� 5���� �����Ͱ� ����

SELECT *
FROM users;

-- WHERE�� : ���̺��� �����͸� ��ȸ�� �� ���ǿ� �´� �ุ ��ȸ
-- ex) userid �÷��� ���� brown�� �ุ ��ȸ

SELECT *
FROM users
WHERE userid = 'brown'; -- �̱� �����̼��� �Ⱦ��� user�� �ִ� �÷����� �ν� -> brown �÷�, 'brown' ���ڿ� ���

--userid�� brown�� �ƴ� �ุ ��ȸ
SELECT *
FROM users
WHERE userid != 'brown';

--emp ���̺� �����ϴ� �÷��� Ȯ�� �غ�����
desc emp;

SELECT *
FROM emp;

--emp ���̺��� ename �÷� ���� JONES�� �ุ ��ȸ
-- * SQL KEY WORD�� ��ҹ��ڸ� ������ ������
-- �÷��� ���̳�, ���ڿ� ����� ��ҹ��ڸ� ������.
-- ��, 'JONES' �� 'jones'�� �ٸ� ��
SELECT *
FROM emp
WHERE ename = 'JONES' ;

-- emp���̺��� deptno (�μ���ȣ) �� 30���� ũ�ų� ���� ����鸸 ��ȸ
SELECT *
FROM emp
WHERE deptno >= 30;

-- ���ڿ� : '���ڿ�'
-- ���� : 50
-- ��¥ : ??? --> �Լ��� ���ڿ��� �����ؼ� ���
--       ���ڿ��� �̿��Ͽ� ǥ�� ���������� �������� ���� (�������� ��¥ ǥ�� ����� �ٸ�)
--       �ѱ� : �⵵ 4�ڸ� - �� 2�ڸ� - ���� 2�ڸ�
--       �̱� : �� 2�ڸ� - ���� 2�ڸ� - �⵵ 4�ڸ�
-- �Ի����ڰ� 1980�� 12�� 17�� ������ ��ȸ
SELECT ename, hiredate
FROM emp;

-- TO_DATE : ���ڿ��� date Ÿ������ �����ϴ� �Լ� 
-- TO_DATE(��¥���� ���ڿ�, ù��° ������ ����)
-- '1980/02/03'
SELECT *
FROM emp
WHERE hiredate = TO_DATE('19801217','YYYYMMDD');

-- ��������
-- sal �÷��� ���� 1000���� 2000 ������ ���
SELECT *
FROM emp;

SELECT *
FROM emp
WHERE sal >= 1000 AND sal <= 2000;

SELECT *
FROM emp
WHERE SAL BETWEEN 1000 AND 2000 ;
--emp ���̺��� �Ի� ���ڰ� 1982�� 1�� 1�� ���ĺ��� 1983�� 1�� 1�� ������ ����� ename, hiredate�� ��ȸ�ϴ� ������ �ۼ��Ͻÿ�
--�����ڴ� BETWEEN ���
SELECT ename, hiredate
FROM emp
WHERE hiredate between TO_DATE('19820101','YYYYMMDD') AND TO_DATE('19830101','YYYYMMDD');

-- ���̺� � �÷��� �ִ��� Ȯ���ϴ� ���
-- 1. SELECT * FROM users;
-- 2. TOOL�� ��� (����� - TABLES)
-- 3. DESC ���̺�� (DESC-DESCRIBE)
DESC users;
SELECT id
FROM users;

-- users ���̺��� userid, usernm, reg_dt �÷��� ��ȸ�ϴ� sql�� �ۼ��ϼ���
-- ��¥ ���� (reg_dt �÷��� date ������ ���� �� �ִ� Ÿ��)
-- SQL ��¥ �÷� + (���ϱ� ����) 
-- �������� ��Ģ������ �ƴ� �͵� (5+5)
-- String h = "hello";
-- String w = "world";
-- String hw = h+w;  -> �ڹٿ����� �� ���ڿ��� �����ض� 
-- SQL���� ���ǵ� ��¥ ���� : ��¥ + ���� = ��¥���� ������ �ϼ��� ����Ͽ� ���Ѵ�.

SELECT userid u_id, usernm, reg_dt, reg_dt +5 AS reg_dt_after_5day
FROM users;

SELECT prod_id AS id, prod_name AS name
FROM prod;

SELECT lprod_gu AS gu, lprod_nm AS nm
FROM lprod;

SELECT buyer_id AS ���̾���̵�, buyer_name AS �̸�
FROM buyer;

-- �ڹ� ���� ���ڿ� ���� : + ("hello" + "world")
-- SQL������ �� ������ �ִ���
-- SQL������ || ('hello' || 'world')
-- SQL������ concat('hello', 'world') concat�̶�� �Լ� ���

-- userid, usernm �÷��� ����, ��Ī id_name

SELECT userid || usernm AS id_name
FROM users;

-- ����, ���
-- int a = 5; String msg = "hello World"; -> ����
-- System.out.println(msg); -> ������ �̿��� ���
-- System.out.println("hello World"); -> ����� �̿��� ���
-- FINAL int a  = 5 ; -> ���
-- SQL������ ������ ���� (�÷��� ����� ����, PL/SQL������ ������ ������ ����)
-- SQL���� ���ڿ� ����� �̱� �����̼�('')���� ǥ��
-- "Hello, World" --> 'Hello, World'

-- ���ڿ� ����� �÷����� ����
-- user id : brown
-- user id : cony

-- AS(��Ī)���� ������ �� �� ������ ���� �����̼���("") ����ϸ� ����
-- AS(��Ī)���� �ҹ��ڰ� �� �� ������ ���� �����̼���("") ����ϸ� ����
SELECT 'user id : ' || userid AS "user id"
FROM users;

SELECT 'SELECT * FROM ' ||TABLE_NAME || ';' AS QUERY
FROM USER_TABLES;

-- concat
SELECT concat(concat('SELECT * FROM ', TABLE_NAME),';') AS QUERY
FROM USER_TABLES;

-- int a = 5; -> java������ �Ҵ�, ���� ������
-- a == 5 �̰� ����
-- SQL������ = --> equal, wql������ ������ ������ ���� (PL/SQL������ �ִ�)
-- where�� ���� ������ ���� �˻��ؼ� ��������


