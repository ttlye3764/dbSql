-- SUBQUERY
-- dept ���̺��� 5���� �����Ͱ� ����
-- emp ���̺��� 14���� ������ �ְ�, ������ �ϳ��� �μ��� ���� �ִ�.(deptno)
-- �μ��� ������ ���� ���� ���� �μ� ������ ��ȸ;

-- ������������ �������� ������ �´��� Ȯ���� ������ �ϴ� �������� �ۼ�


SELECT *
FROM dept
WHERE deptno NOT IN(SELECT deptno
                    FROM emp);

SELECT deptno
FROM emp;

SELECT *
FROM dept
WHERE deptno NOT IN(SELECT DISTINCT deptno
                    FROM emp);

SELECT *
FROM cycle;

SELECT *
FROM product;
-- SUBQUERY 5��
SELECT *
FROM product
WHERE pid  in(  SELECT pid
                 FROM cycle
                 WHERE cid = 1);
                 
--SUBQUERY 6

SELECT *
FROM cycle;

-- cid=2�� ���� �����ϴ� ��ǰ
-- ���� ������� cid=1�� ���� �̿��ϴ� ��ǰ
SELECT *
FROM cycle
WHERE cid = 1 and pid  in (SELECT pid
                            FROM cycle
                            WHERE cid = 2);

-- customer, cycle, product ���̺��� �̿��Ͽ� cid=2�� ���� �����ϴ� ��ǰ�� cid=1 �� ���� �����ϴ� ��ǰ�� ����������
-- ��ȸ�ϰ� ����� ��ǰ�� ���� �����ϴ� ������ �ۼ��ϼ���
SELECT *
FROM customer;

-------- �غ���
SELECT a.cid, a.pid,  a.day, a.cnt
FROM (SELECT *
            FROM cycle c
            WHERE cid = 1 and pid  in (SELECT pid
                                        FROM cycle
                                    WHERE cid = 2)) a, customer, product
WHERE a.cid = customer.cid
AND a.pid = product.pid;


        
---  CROSS ���λ��
SELECT cycle.cid, customer.cnm, cycle.pid, product.pnm, cycle.day, cycle.cnt
FROM cycle, customer, product
WHERE cycle.cid = 1
AND cycle.pid in(SELECT pid
            FROM cycle
            WHERE cid = 2)
AND cycle.cid = customer.cid
AND cycle.pid = product.pid;






SELECT *
FROM cycle c
WHERE cid = 1 and pid  in (SELECT pid
                            FROM cycle
                            WHERE cid = 2);

-- CID=2�� ���� �����ϴ� ��ǰ


SELECT *
FROM ;

select *
from emp;

--  SUBQUERY 
-- �Ŵ����� �����ϴ� ������ ��ȸ KING�� ������ 13���� �����Ͱ� ��ȸ

SELECT *
FROM emp
WHERE mgr IS NOT NULL;

-- �� ���� ���� EXISTS������

-- EXSITS ���ǿ� �����ϴ� ���� ���� �ϴ��� Ȯ���ϴ� ������
-- �ٸ� �����ڿ� �ٸ��� WHERE���� �÷��� ������� �ʴ´�.
-- WHERE = empno = 7369
-- WHERE EXISTS (SELECT 'X'
--               FORM ..)

-- �Ŵ����� �����ϴ� ������ EXISTS �����ڸ� ���� ��ȸ
-- �Ŵ����� ����

SELECT *
FROM emp e
WHERE EXISTS(SELECT 'X'
             FROM emp m
             where e.mgr = m.empno);
             
-- SUBQUERY �ǽ� 9��

-- cycle, product ���̺��� �̿��Ͽ� cid=1�� ���� �����ϴ� ��ǰ�� ��ȸ�ϴ� ������ exists �����ڸ� �̿��Ͽ� �ۼ�
-- cid=1�� ���� �����ϴ� ��ǰ
SELECT pid
FROM cycle
WHERE cid =1;

SELECT *
FROM product
WHERE pid IN (SELECT pid
            FROM cycle
            WHERE cid =1) ;
            
SELECT *
FROM product
WHERE EXISTS (SELECT 'X'
             FROM cycle
             WHERE cid =1 
             AND product.pid = cycle.pid) ;

--SUBQUERY �ǽ� 10��
SELECT *
FROM product
WHERE NOT EXISTS (SELECT 'X'
             FROM cycle
             WHERE cid =1 
             AND product.pid = cycle.pid) ;

-------------------------------------------------------------
-- �� ���տ���

-- ������ : UNION - �ߺ����� / UNION ALL �ߺ��������� ����
-- ������ : INTERSECT 
-- ������ : MINUS (���հ���)
-- ���տ��� �������
-- �� ������ �÷� ����, Ÿ���� ��ġ�ؾ� �ϳ�.

SELECT empno, ename
FROM emp
WHERE empno IN(7566,7698)

UNION ALL -- �ߺ� ���

SELECT empno, ename
FROM emp
WHERE empno IN(7566,7698);

-------------------������

SELECT empno, ename
FROM emp
WHERE empno IN(7566,7698,7369)

INTERSECT

SELECT empno, ename
FROM emp
WHERE empno IN(7566,7698);

-------------------������

SELECT empno, ename
FROM emp
WHERE empno IN(7566,7698,7369)

MINUS

SELECT empno, ename
FROM emp
WHERE empno IN(7566,7698);

-- ������ ��� ������ ������ ���� ���տ�����

-- A UNION B       B UNION A --> ����
-- A UNION ALL B   B UNION ALL A --> ����(���� ��������)
-- A INTERSECT B   B INTERSECT A  --> ����
-- A MIUNS B       B MINUS A   --> �ٸ�]


-- ���տ����� ��� �÷� �̸��� ù��° ������ �÷����� ������
SELECT 'X' fir, 'b' sec
FROM dual

UNION

SELECT 'X' t, 'b' f
FROM dual;


--����(ORDER BY)�� ���տ��� ���� ������ ���� ������ ���

SELECT deptno, dname, loc
FROM dept 
WHERE deptno IN (10,20)

UNION

SELECT *
FROM dept
WHERE deptno IN (30,40)

ORDER BY deptno;


-- �õ� �ñ���, ��������
SELECT f.sido, f.sigungu, f.gb
FROM fastfood f, tax t
WHERE concat(f.SIDO, f.sigungu)  = concat(t.sido, t.sigungu)
ORDER BY f.id;

-- ����ŷ + kfc + �Ƶ����� / �Ե�����


-- ����

SELECT a.sido, A.sigungu, gb, COUNT(*)
FROM (SELECT f.sido, f.sigungu, f.gb
    FROM fastfood f, tax t
    WHERE concat(f.SIDO, f.sigungu)  = concat(t.sido, t.sigungu)) A
GROUP BY a. sido, a.sigungu, A.gb
ORDER BY SIGUNGU;

SELECT B.sido, B.sigungu
FROM (
        SELECT a.sido, A.sigungu, gb, COUNT(*)
        FROM (SELECT f.sido, f.sigungu, f.gb
                FROM fastfood f, tax t
                WHERE concat(f.SIDO, f.sigungu)  = concat(t.sido, t.sigungu)) A
        GROUP BY a. sido, a.sigungu, A.gb
        ORDER BY SIGUNGU) B;






SELECT a.sido, A.sigungu, COUNT(*)
FROM (SELECT f.sido, f.sigungu, f.gb
    FROM fastfood f, tax t
    WHERE concat(f.SIDO, f.sigungu)  = concat(t.sido, t.sigungu)) A
GROUP BY a. sido, a.sigungu
ORDER BY SIGUNGU;


SELECT A.SIDO, A.SIGUNGU, ROUND(B.AA/A.AA, 1) "����"
FROM
    (SELECT f.sido, f.sigungu, COUNT(*) AA
    FROM fastfood f, tax t
    WHERE concat(f.SIDO, f.sigungu)  = concat(t.sido, t.sigungu)
    AND f.gb ='�Ե�����'
    GROUP BY f.sido, f.sigungu
    ORDER BY SIGUNGU)A,

    (SELECT f.sido, f.sigungu, COUNT(*)AA
    FROM fastfood f, tax t
    WHERE concat(f.SIDO, f.sigungu)  = concat(t.sido, t.sigungu)
    AND f.gb IN ('KFC','�Ƶ�����','����ŷ')
    GROUP BY f.sido, f.sigungu
    ORDER BY SIGUNGU) B
WHERE concat(A.SIDO, A.sigungu)  = concat(B.sido, B.sigungu);






SELECT f.sido, f.sigungu, COUNT(*)/(SELECT f.sido, f.sigungu, COUNT(*)
                                    FROM fastfood f, tax t
                                    WHERE concat(f.SIDO, f.sigungu)  = concat(t.sido, t.sigungu)
                                    AND f.gb ='�Ե�����'
                                    GROUP BY f.sido, f.sigungu
                                    ORDER BY SIGUNGU)
FROM fastfood f, tax t
WHERE concat(f.SIDO, f.sigungu)  = concat(t.sido, t.sigungu)        
AND f.gb !='�Ե�����'
GROUP BY f.sido, f.sigungu
ORDER BY SIGUNGU;






SELECT f.sido, f.sigungu, COUNT(*)/(SELECT SELECT f.sido, f.sigungu, COUNT(*)/(SELECT )
                                    FROM fastfood f, tax t
                                    WHERE concat(f.SIDO, f.sigungu)  = concat(t.sido, t.sigungu)        
                                    AND f.gb ='�Ե�����'
                                    GROUP BY f.sido, f.sigungu
                                    ORDER BY SIGUNGU)
FROM fastfood f, tax t
WHERE concat(f.SIDO, f.sigungu)  = concat(t.sido, t.sigungu)
AND f.gb !='�Ե�����'
GROUP BY f.sido, f.sigungu
ORDER BY SIGUNGU;





SELECT COUNT(*)
FROM fastfood
��GB ='�Ե�����';

SELECT *
FROM fastfood;

SELECT *
FROM TAX;

