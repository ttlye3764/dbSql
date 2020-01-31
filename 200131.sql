-- �� JOIN (�ڡڡڡڡڡڡڡڡڡڡڡڡڡڡ�)
-- �ߺ��� �ּ�ȭ �ϴ� RDBMS ���
-- �� ���̺��� �����ϴ� �۾�

-- �� JOIN ����
--     1. ANSI ����
--     2. ORACLE ����

-- �� ANSI : Natural Join
-- �� ���̺� �÷����� ���� �� �ش� �÷����� ����(����)
-- emp, dept ���̺��� deptno��� ����� �÷��� ����
SELECT *
FROM emp NATURAL JOIN dept;

SELECT emp.empno, emp.ename -- �ش� ���̺�.�÷��� ���� ��������� �Է����ִ°� ����
FROM emp NATURAL JOIN dept;

-- deptno��� ����� �÷����� �����߱� ������ �� �÷��� �տ� �����ڸ� ���ټ� ���� -> ���� ������
-- �÷��� ���(dept.deptno - > deptno)
SELECT emp.empno, emp.ename, dept.dname, dept.deptno 
FROM emp NATURAL JOIN dept;

-- ������ ���� �����ȳ�
SELECT emp.empno, emp.ename, dept.dname, deptno 
FROM emp NATURAL JOIN dept;

-- ���̺� ���� ��Ī�� ��밡��
SELECT e.empno, e.ename, d.dname, deptno 
FROM emp e NATURAL JOIN dept d;

-- �� ORACLE JOIN

-- FROM���� ������ ���̺� ����� ,�� �����Ͽ� �����Ѵ�.
-- ������ ���̺��� ���� ������ WHERE���� ����Ѵ�.
-- emp, dept ���̺� �����ϴ� deptno �÷��� [���� ��] ����

SELECT e.empno, e.ename
FROM emp e, dept d
WHERE e.deptno = d.deptno;

SELECT e.ename, d.dname
FROM emp e, dept d
WHERE e.deptno != d.deptno;

-- ORACLE JOIN (,) ������ �����ڸ� ��Ȯ�� ��������� (Naturaljoin�� ������)
SELECT e.empno, e.ename, deptno -- �����ڸ� �Ƚ���� ������ ����
FROM emp e, dept d
WHERE e.deptno = d.deptno;

SELECT e.empno, e.ename, e.deptno -- �����ڸ� �����༭ ����
FROM emp e, dept d
WHERE e.deptno = d.deptno;

-- �� join with USING
-- �����Ϸ��� �ΰ��� ���̺� �̸��� ���� �÷��� �ΰ������� �ϳ��� �÷����θ� ������ �ϰ��� �Ҷ�
-- �����ϴ� ���� �÷��� ���

-- �� ANSI ����
-- emp, dept ���̺��� ���� �÷� : deptno
SELECT emp.ename, dept.dname, deptno
FROM emp JOIN dept USING(deptno);

-- �� ORACLE ����
SELECT emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

-- ��������� �����Ϸ��� �� ���̺��� ������ �÷����� ������

-- �� join with ON
-- �����Ϸ��� �ϴ� ���̺��� �÷��� �̸��� ���� �ٸ� ��

-- �� ANSI ����
SELECT emp.ename, dept.dname, emp.deptno
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

-- �� ORACLE ����
SELECT emp.ename, dept.dname, emp.deptno
FROM emp, dept
WHERE emp.deptno = dept.deptno;

-- �� SELF JOIN
-- ���� ���̺� ����
-- ����) emp ���̺��� �����Ǵ� ����� ������ ����� �̿��Ͽ� ������ �̸��� ��ȸ
-- ���� ���̺� �ΰ��� ���� ������ �ֱ� ���� ALIES�� �ݵ�� �ٿ��ְ� �����ڸ� ����� �־�� ��.

-- �� ANSI ����
SELECT e.emp1no, e.ename, m.empno, m.ename
FROM emp e JOIN emp m ON (e.mgr = m.empno);

-- �� ORACLE ����
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno;

-- �� equal ���� : =
-- �� non - equal ���� : !=, >, <, BETWEEN AND ��� (��, ���� ��)

SELECT ename, sal
FROM emp;

SELECT *
FROM salgrade;

--���� �ΰ� ���̺��� �̿��ؼ� ����� �Űܶ�

-- �� ANSI ����
SELECT e.ename, e.sal, s.grade
FROM emp e join salgrade s on(e.sal BETWEEN S.losal AND S.hisal);


-- e.sal ����s.losal~s.hisal�� ���ؼ� ���̿��ִ� grade�� ���

-- �� ORALCE ����
SELECT e.ename, e.sal, s.grade
FROM emp e, salgrade s
WHERE e.sal BETWEEN S.losal AND S.hisal;

-- JOIN �ǽ�
-- 1. emp, dept ���̺��� �̿��Ͽ� ������ ���� ��ȸ�ǵ��� �����ۼ�

SELECT e.empno, e.ename, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
ORDER BY deptno;

--2. 
SELECT e.empno, e.ename, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno AND d.deptno !=20 
ORDER BY deptno;

--3.
SELECT e.empno, e.ename,e.sal, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno AND e.sal >2500
ORDER BY deptno;

--4.
SELECT e.empno, e.ename,e.sal, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno AND e.sal >2500 AND e.empno >7600
ORDER BY deptno;

--5.
SELECT e.empno, e.ename,e.sal, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno AND e.sal >2500 AND e.empno >7600 AND d.Dname='RESEARCH'
ORDER BY deptno;

--���ο� ���̺��
--
SELECT l.lprod_gu, l.lprod_nm, p.prod_id, p.prod_name
FROM prod p, lprod l
WHERE p.prod_lgu = l.lprod_gu;

SELECT b.buyer_id, b.buyer_name, p.prod_id, p.prod_name
FROM prod p, buyer b
WHERE P.prod_buyer = b.buyer_id;
-- ����
SELECT *
FROM member m, cart c, prod p
WHERE (m.mem_id = c.cart_member) AND (c.cart_prod = p.prod_id);
 
SELECT *
FROM EMP;

SELECT *
FROM dept;
-----------
SELECT *
FROM prod;

SELECT *
FROM lprod;



