
-- 
-- CROSS JOIN ==> īƼ�� ���δ�Ʈ(cartesian product)
-- �����ϴ� �� ���̺��� ���� ������ �����Ǵ� ���
-- ������ ��� ���տ� ���� ����(����)�� �õ�


-- dept ���̺�� emp ���̺��� ���� �ϱ� ���� from ���� �ΰ��� ���̺��� ���
-- ��, WHERE���� �� ���̺��� ���� ������ ����
-- �̷��� �Ǹ� ������ ��� ������ ���
SELECT dept.dname, emp.empno, emp.ename
FROM dept, emp;

-- �̰� ���� �� ������
SELECT dept.deptno, dept.dname, emp.empno, emp.ename
FROM dept, emp
WHERE dept.deptno=10
AND dept.deptno = emp.deptno;

-- CROSS �ǽ� 1
SELECT c.cid, c.cnm, p.pid, p.pnm
FROM customer c, product p
ORDER BY c.cid;

------------------------------------------------join ��----------------------------------------------------------------------

-- SUBQUERY
-- �����ȿ� �ٸ� ������ �� �ִ� ���

-- SUBQUERY�� ���� ��ġ�� ���� ũ�� 3������ �з� ����

-- 1. SELECT ���� ���� SUBQUERY : SCALAR SUBQUERY -> �ϳ��� ��, �ϳ��� �÷��� �����ؾ� ������ �߻����� ����

-- 2. FROM �� : INLINE-VIEW (VIEW)

-- 3. WHERE�� : SUBQUERY QUERY




-- ���ϰ��� �ϴ°�
-- SMITH�� ���� �μ��� ���ϴ� �������� ����Ʈ ������ ��ȸ

-- 1. SMITH�� ���ϴ� �μ� ��ȣ�� ���Ѵ�.
SELECT deptno
FROM emp
WHERE ename= 'SMITH';

-- 2. 1������ ���� �μ� ��ȣ�� ���ϴ� ������ ������ ��ȸ�Ѵ�.
SELECT *
FROM emp
WHERE deptno = 20;

-- -> ���ϴ� ����� ����� �ι��� �������� �ۼ��ߴµ� SUBQUERY�� �̿��ϸ� �Ѱ��� ������ ����
SELECT *
FROM emp
WHERE deptno =  (SELECT deptno
                FROM emp
                WHERE ename= 'SMITH');
                

-- SUBQEURY �ǽ� 2
-- ��� �޿����� ���� �޿��� �޴� ������ ���� ��ȸ
-- 1. ��� �޿� �� ?
SELECT AVG(sal)
FROM emp;

-- 2. ���� ��� �޿����� ���� �޿��� �޴»�� ?
SELECT COUNT(*)
FROM emp
WHERE sal > 2073;

-- 3. �ϳ��� ��ġ��?
SELECT COUNT(*)
FROM emp
WHERE sal > (SELECT avg(sal)
            FROM emp);
            
            
-- ������ ������   
-- IN : ���� ������ �������� ��ġ�ϴ� ���� ���� �� ��
-- ANY [*Ȱ�뵵�� �� ������ LIKE ����] : ���������� �������� �� ���̶� ������ ������ ��
-- ALL [*Ȱ�뵵�� �� ������ LIKE ����] : ���������� �������� ��� �࿡ ���� ������ ������ ��

-- �ǽ� 1
-- SMITH�� ���ϴ� �μ��� ��� ������ ��ȸ
-- SMITH�� WARD�� ���ϴ� �μ��� ��� ������ ��ȸ

-- 1. SMITH�� WARD�� ���� �μ���ȣ ��ȸ
SELECT deptno
FROM emp
WHERE ename in('SMITH', 'WARD');

-- 2. 20,30�� �ش��ϴ� ������ ��ȸ
SELECT *
FROM emp
WHERE deptno in(20,30);

SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                FROM emp
                WHERE ename in('SMITH', 'WARD'));

-- �ǽ� 3
-- SMITH, WARD ����� �޿����� �޿��� ���� ������ ��ȸ(SMITH, WARD�� �޿��� �ƹ��ų�)

-- 1. �� ��� �޿� ��?
SELECT sal
FROM emp
WHERE ename IN('SMITH','WARD');

--2. ��
SELECT *
FROM emp
WHERE sal < ANY(800,1250);

--3. ����
SELECT *
FROM emp
WHERE sal < ANY(SELECT sal
                FROM emp
                WHERE ename IN('SMITH','WARD'));
               
-- �̹��� SMITH,WARD ����� �޿����� �޿��� ���� ������ ��ȸ(SMITH, WARD�� �޿� 2���� ��ο� ���� ���� ��)
-- SMITH  800 
-- WARD : 1250 
--  ==> 1250���� �������
SELECT *
FROM emp
WHERE sal > ALL(SELECT sal
                FROM emp
                WHERE ename IN('SMITH','WARD'));

-- ������ ������ ����� 7902 �̰ų� null;
SELECT *
FROM emp
WHERE mgr IN(7902) OR mgr IS NULL;

-- ��� ��ȣ�� 7902�� �ƴϸ鼭 NULL�� �ƴ� ������ == > AND
SELECT *
FROM emp
WHERE mgr NOT IN(7902) AND mgr IS NOT NULL;

-- SUBQUERY 
-- MULTI COLUNM 
-- pairwise(������) ��� : ���� �÷��� ���� ����
-- �������� ����� ���ÿ� ���� ��ų��
-- �ǽ�
-- mgr 7698�̸鼭 deptno 30, mgr�� 7839�̸鼭 deptno�� 10�� ������ ��ȸ 
SELECT *
FROM emp
WHERE (mgr, deptno) IN (SELECT mgr, deptno
                        FROM emp
                        WHERE empno IN(7499,7782));


SELECT mgr, deptno
FROM emp
WHERE empno IN(7499,7782);

-- ���� ������ non-pairwise�� �����
-- mgr 7698�̸鼭 deptno 30, mgr�� 7839�̸鼭 deptno�� 10�� ������ ��ȸ  --> �տ����� ����
SELECT *
FROM emp
WHERE mgr IN (SELECT mgr
              FROM emp
              WHERE empno IN(7499,7782))
AND  deptno IN (SELECT deptno
                FROM emp
                WHERE empno IN(7499,7782));

-- ��Į�� �������� : SELECT���� ���, 1���� ROW, 1���� COL�� ��ȸ�ϴ� ����
-- ��Į�� ���������� MAIN ������ �÷��� ����ϴ°� �����ϴ�.
SELECT (SELECT SYSDATE
        FROM dual), dept.*
FROM dept;

SELECT empno, ename, deptno, (SELECT dname
                              FROM dept
                              WHERE deptno = emp.deptno) dname
FROM emp;


-- INLINE VIEW : FROM ���� ����Ǵ� ��������
-- ���� ����

-- ���ݱ����� ���������� �����ϴ� ��ġ�� ���� �з�

-- MAIN ������ �÷��� SUBQUERY���� ����ϴ��� ������ ���� �з�

-- 1. ����� ��� : correalted subquery(��ȣ ���� ����), ���������� �ܵ����� ���� �ϴ°� �Ұ�
--           ���� ������ �������ִ� (main -> sub)

-- 2. ������� ���� ��� : non-correalted subquery, ���������� �ܵ����� �����ϴ°� ����
--            ���� ������ ������ ���� �ʴ� (main -> sub, sub -> main ) 

-- ��� ������ �޿� ��պ��� �޿��� ���� ����� ��ȸ
SELECT *
FROM emp
WHERE sal > (SELECT AVG(sal)
             FROM emp);
             
-- ������ ���� �μ��� �޿� ��պ��� �޿��� ���� ����� ��ȸ
-- 1.������ ���� �μ���ȣ
SELECT *
FROM EMP;

SELECT *
FROM TAB;




FROM emp
GROUP BY deptno;
-- 2. ���� �μ���ȣ�� �޿� ���
SELECT AVG(sal)
FROM emp
GROUP BY deptno;
--3. �޿��� �������

SELECT *
FROM emp e, emp m 
WHERE e.deptno = m.deptno AND sal > SELECT AVG(sal)
                                     FROM emp
                                     GROUP BY deptno;
                                     
                                     SELECT AVG(sal)
                                     FROM emp
                                     GROUP BY deptno;
SELECT *
FROM emp e
WHERE sal > (SELECT AVG(sal)
            FROM emp m
            WHERE e.deptno = m.deptno);
-----------------------------------------------------------
SELECT e.empno, e.ename, e.sal, round(m.A,0) AVG
FROM emp e,(SELECT AVG(sal) A, deptno
        FROM emp
        GROUP BY deptno) m
WHERE e.deptno = m.deptno AND SAL > A;


SELECT *
FROM (SELECT *
FROM emp e
WHERE sal > (SELECT AVG(sal)
            FROM emp m
            WHERE e.deptno = m.deptno)) B,
(SELECT e.empno, e.ename, e.sal, round(m.A,0) AVG
FROM emp e,(SELECT AVG(sal) A, deptno
        FROM emp
        GROUP BY deptno) m
WHERE e.deptno = m.deptno AND SAL > A) C
WHERE B.empno = C.empno ;


--------------------------------------------------------------------------------------------
-- INSERT (������ �߰�)
-- INSERT INTO ���̺� VALUES (�����Ͱ�)

--INSER INTO dept VALUES(99,'ddit','daejeon');
-- ROLLBACK -> Ʈ����� ���
-- COMMIT -> Ʈ����� Ȯ��

INSERT INTO dept VALUES(99,'ddit','daejeon');

COMMIT;

-- SUBQUERY�ǽ� 4
-- dept ���̺��� �ű� ��ϵ� 99�� �μ��� ���� ����� ���� ������ ������ ���� �μ��� ��ȸ�ϴ� ������ �ۼ��غ�����
SELECT *
FROM dept
where deptno NOT IN(SELECT deptno
                     FROM emp);
                     
SELECT *
FROM (SELECT d.deptno deptnod, d.dname dname, d.loc loc, e.deptno deptnoe
      FROM dept d, emp e
      WHERE d.deptno = e.deptno (+))a
WHERE deptnoe is null;
                     





    
    









