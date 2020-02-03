SELECT *
FROM customer;

SELECT *
FROM CYCLE;

SELECT *
FROM product;

ALL_TABLES;

SELECT *
FROM TAB;

    
-- �Ǹ��� : 200~250
-- ���� 2.5�� ��ǰ
-- �Ϸ� : 500~750
-- �Ѵ� : 15000~17500

SELECT *
FROM daily;

SELECT *
FROM batch;

-- �ǽ� 4�� 212
SELECT c1.cid, c1.cnm, c2.pid, c2.day, c2.cnt
FROM customer c1, cycle c2
WHERE c1.cid = c2.cid AND c1.cnm in('brown','sally');

-- �ǽ� 5�� 213
SELECT c1.cid, c1.cnm, c2.pid, p.pnm, c2.day, c2.cnt
FROM customer c1, cycle c2, product p
WHERE c1.cid = c2.cid AND c1.cnm in('brown','sally') AND p.pid= c2.pid;

-- �ǽ� 6�� p214 �ٽ��ѹ� �غ�����
SELECT A.CID, A.CNM, A.PID, A.PNM, COUNT(A.PNM)
FROM 
(SELECT cs.cid, cs.cnm, cy.pid, p.pnm, SUM(CY.cnt)
FROM customer cs, cycle cy, product p
WHERE cs.cid = cy.cid AND p.pid= cy.pid) A
GROUP BY A.CID, A.CNM, A.PID, A.PNM, A.CNT
ORDER BY A.CID;

SELECT cs.cid, cs.cnm, cy.pid, p.pnm, CY.cnt
FROM customer cs, cycle cy, product p
WHERE cs.cid = cy.cid AND p.pid= cy.pid;

FROM custome, 

--
-- �ش� ����Ŭ ������ ��ϵ� �����(����) ��ȸ

--SELECT *
--FROM dba_users;
---- HR ������ ��й�ȣ�� JAVA�� �ʱ�ȭ
--ALTER USER HR IDENTIFIED BY java;
--ALTER USER HR ACCOUNT UNLOCK;

-- 7����������

-- 8������ 13������ hr

--�� OUTER JOIN
-- �� ���̺��� �����Ҷ� ���� ������ ������Ű�� ���ϴ� �����͸�, �������� ������ ���̺��� �����͸��̶� ��ȸ �ǰԲ� �ϴ� ���� ���

-- 1.���ο� �����ϴ��� ��ȸ�� �� ���̺��� ����
-- 2.

-- �������� : e.mgr = m.empno --> KING�� �Ŵ����� NULL �̱� ������ ���ο� �����Ѵ�.
--           emp���̺��� �����ʹ� �� 14������ �Ʒ��� ���� ���������� ����� 13���� �ȴ�.(1���� ���� ����)
SELECT e.empno, e.ename, e.mgr, m.ename "�Ŵ��� �̸�"
FROM emp e, emp m
WHERE e.mgr = m.empno;

-- �� ANSI OUTER
--���ο� �����ϴ��� ��ȸ�� �� ���̺��� ����(�Ŵ��� ������ ��� ��������� ������ ��)

SELECT e.empno, e.ename, e.mgr, m.ename "�Ŵ��� �̸�"
FROM emp e LEFT OUTER JOIN emp m ON e.mgr = m.empno;

SELECT e.empno, e.ename, e.mgr, m.ename "�Ŵ��� �̸�"
FROM emp m RIGHT OUTER JOIN emp e ON e.mgr = m.empno;

-- �� ORCALE OUTER
-- �����Ͱ� ���� ���� ���̺� �÷� �ڿ� (+) ��ȣ�� �ٿ��ش�.
SELECT e.empno, e.ename, e.mgr, m.ename "�Ŵ��� �̸�", m.deptno
FROM emp e, emp m
WHERE e.mgr = m.empno(+);

-- ���� SQL�� ANSI SQL(OUTER JOIN)���� ����

SELECT e.empno, e.ename, e.mgr, m.ename "�Ŵ��� �̸�", m.deptno
FROM emp e LEFT JOIN emp m ON e.mgr = m.empno AND m.deptno=10;

-- ���� �������� �Ŵ����� �μ���ȣ�� 10���� ������ ��ȸ

SELECT e.empno, e.ename, e.mgr, m.ename "�Ŵ��� �̸�", m.deptno
FROM emp e LEFT OUTER JOIN emp m ON e.mgr = m.empno AND m.deptno = 10;

-- �Ʒ� LEFT OUTER ������ ���������� OUTER������ �ƴϴ�.
-- ��, LEFT�� ���� ����� �����ϴ� -> INNER���ΰ� ����� ����
-- --> ������ WHERE���� ����ߴ���, 
SELECT e.empno, e.ename, e.mgr, m.ename "�Ŵ��� �̸�", m.deptno
FROM emp e LEFT JOIN emp m ON e.mgr = m.empno
WHERE  m.deptno = 10;

SELECT e.empno, e.ename, e.mgr, m.ename "�Ŵ��� �̸�", m.deptno
FROM emp e JOIN emp m ON e.mgr = m.empno
WHERE  m.deptno = 10;

-- �� ����Ŭ OUTER JOIN�� 

-- ����Ŭ OUTER JOIN�� ���� ���̺��� �ݴ��� ���̺��� ��� �÷���(+)�� �ٿ��� �������� OUTER JOIN���� �����Ѵ�.
-- �� �÷��̶� (+)�� �����ϸ� INNER�������� ����
-- �� ������ INNER JOIN���� ����
SELECT e.empno, e.ename, e.mgr, m.ename "�Ŵ��� �̸�", m.deptno
FROM emp e, emp m
WHERE e.mgr = m.empno(+) AND m.deptno=10;

-- �� ������ OUTER JOIN���� ����
SELECT e.empno, e.ename, e.mgr, m.ename "�Ŵ��� �̸�", m.deptno
FROM emp e, emp m
WHERE e.mgr = m.empno(+) AND m.deptno(+)=10;

-- ��� - �Ŵ����� RIGHT OUTER JOIN
SELECT empno, ename, mgr
FROM emp e;

SELECT empno, ename
FROM emp m;

SELECT e.empno, e.ename, e.mgr, m.ename "�Ŵ����̸�"
FROM emp e, emp m
WHERE e.mgr(+) = m.empno(+);

-- �� FULL OUTER 
--  FULL OTHER : LEFT OUTER + RIGHT OUTER - �ߺ�����
SELECT e.empno, e.ename, e.mgr, m.ename "�Ŵ��� �̸�", m.deptno
FROM emp e FULL OUTER JOIN emp m ON e.mgr = m.empno;




SELECT *
FROM prod;

SELECT *
FROM buyprod;

-- OUTER JOIN �ǽ� 1
SELECT bp.buy_date, bp.buy_prod, p.prod_id, p.prod_name, bp.buy_qty
FROM buyprod bp, prod p
WHERE bp.buy_prod(+) = p.prod_id 
AND bp.buy_date(+) = TO_DATE('05/01/25','YY/MM/DD');

-- ORACLE OUTER JOIN������ (+)�� FULL OUTER ���ο��� �������� �ʴ´�. ??111



-- OUTER JOIN 2 
-- NULL�� �׸��� 05/01/25�� ä�켼��
SELECT NVL(bp.buy_date, TO_DATE('05/01/25','YY/MM/DD')) BUY_DATE, bp.buy_prod, p.prod_id, p.prod_name, bp.buy_qty
FROM buyprod bp, prod p
WHERE bp.buy_prod(+) = p.prod_id 
AND bp.buy_date(+) = TO_DATE('05/01/25','YY/MM/DD');






