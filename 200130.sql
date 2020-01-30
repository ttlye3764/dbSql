-- emp ���̺��� �̿��Ͽ� deptno�� ���� �μ������� �����ؼ� ��ȸ
SELECT empno, ename,
       CASE 
            WHEN deptno=10 THEN 'ACCOUNTING'
            WHEN deptno=20 THEN 'RESEARCH'
            WHEN deptno=30 THEN 'SALES'
            WHEN deptno=40 THEN 'OPERATIONS'
            ELSE 'DDIT'
        END dname
FROM emp;

-- ���س⵵�� ¦��, �Ի� ���� ¦�� -> �ǰ����� �����
-- ���س⵵�� ¦��, �Ի� ���� Ȧ�� - > ������
-- ���س⵵�� Ȧ��, �Ի� ���� Ȧ�� -> �����
-- ���س⵵�� Ȧ��, �Ի� ���� ¦�� - > ������

-- ���� §��
SELECT empno, ename, hiredate,
        CASE 
            WHEN  MOD( TO_NUMBER(TO_CHAR(hiredate, 'MM')), 2) =0 AND MOD (TO_NUMBER(TO_CHAR(SYSDATE, 'yyyy')),2)=0 THEN '�ǰ����� �����'
            WHEN  MOD( TO_NUMBER(TO_CHAR(hiredate, 'MM')), 2) =0 AND MOD (TO_NUMBER(TO_CHAR(SYSDATE, 'yyyy')),2)!=0 THEN '�ǰ����� ������'
            WHEN  MOD( TO_NUMBER(TO_CHAR(hiredate, 'MM')), 2) !=0 AND MOD (TO_NUMBER(TO_CHAR(SYSDATE, 'yyyy')),2)!=0 THEN '�ǰ����� �����'
            WHEN  MOD( TO_NUMBER(TO_CHAR(hiredate, 'MM')), 2) !=0 AND MOD (TO_NUMBER(TO_CHAR(SYSDATE, 'yyyy')),2)=0 THEN '�ǰ����� ������'
        END contact_to_doctor
FROM emp;

--�������� §�� (�Ի�⵵�� ¦��, ����⵵�� ¦�� -> �����)
SELECT empno, ename, hiredate,
        CASE 
            WHEN  MOD( TO_NUMBER(TO_CHAR(hiredate, 'yyyy')), 2) = MOD(TO_NUMBER(TO_CHAR(SYSDATE, 'yyyy')),2) THEN '�ǰ����� �����'
            ELSE '�ǰ����� ������'
        END contact_to_doctor
        --DECODE�θ� ¥����
FROM emp;


-- 
--
SELECT empno, ename, hiredate, 
                        case 
                            when mod(to_char(sysdate,'yy'),2) = 0 then (DECODE(to_number(mod(to_char(hiredate,'yymm'),2)),0,'�ǰ����� �����',1,'�ǰ����� ������'))
                        else (DECODE(mod(to_char(hiredate,'yymm'),2),1,'�ǰ����� �����',0,'�ǰ����� ������'))
                        end CONTACT_TO_DOCTOR                                                                            
FROM emp;

SELECT deptno
FROM emp;

-----------------------------------------------------------------

-- Function 
-- �� �׷� �Լ�
-- group function = multi row function
-- �������� ���� �ѹ��� input �Ǽ� �ϳ��� ���(output)�� �����°�

SELECT *
FROM emp;

SELECT *
FROM dept;

-- GROUP BY ���� ���� ����
-- �μ���ȣ ���� ROW���� ���� ��� : GROUP BY deptno
-- �������� ���� ROW���� ���� ��� : GROUP BY job
-- MGR�� ���� �������� ���� ROW ���� ���� ��� : GROUP BY mgr. job
-- �״ϱ� GROUP BY deptno; �̷��� �ϸ�  deptno�� ���� �����͵��� ���� �ϳ��� ������ ��ȸ ��

-- �׷��Լ��� ����
-- SUM : �հ�
-- COUNT : ���� - NULL�� �ƴ� ROW�� ����
-- MAX : �ִ�
-- MIN : �ּ�
-- AVG : ���

-- �׷��Լ��� Ư¡
-- �ش� �÷��� NULL���� ���� ROW�� ������ ��� �ش� ���� �����ϰ� ����Ѵ�. (NULL�� ���� ������ ����� NULL�̱� ������ ����)

-- �μ��� �޿� ��
SELECT deptno, 
       SUM(sal) sum_sal, MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal, COUNT(sal) count_sal
FROM emp
GROUP BY deptno;

-- �׷��Լ� ������
-- GROUP BY���� ���� �÷� �̿��� �ٸ��÷��� SELECT���� ǥ���Ǹ� ����
-- �ؿ��� ������ ����
SELECT deptno, ename,
       SUM(sal) sum_sal, MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal, COUNT(sal) count_sal
FROM emp
GROUP BY deptno;

-- SELECT���� ���� �÷��� GROUP BY���� �÷��� ��ġ ������� �Ѵ�.(�׷��Լ� ���� �ٸ� �÷��� ����)
-- �ùٸ� ����
SELECT deptno, ename,
       SUM(sal) sum_sal, MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal, COUNT(sal) count_sal
FROM emp
GROUP BY deptno, ename;

-- GROUP BY���� ���� ���¿��� �׷��Լ��� ����� ���
-- -> �� ���� ��ü ���� �ϳ��� ������ ���´ٴ� ���� �׷� ����� �� ������ ���´�.
-- -> ��ü����� sal ��, ��ü����� sal �ִ밪, ... ���
SELECT SUM(sal) sum_sal, MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal, 
       COUNT(sal) count_sal, -- sal �÷��� ���� NULL�� �ƴ� ROW�� ����
       COUNT(comm), -- comm �÷��� ���� NULL�� �ƴ� ROW�� ����
       COUNT(*)  -- ����� �����Ͱ� �ִ��� ----> COUNT �׷��Լ��� ��쿡�� �ƽ�Ÿ����ũ(*) ��밡��
FROM emp;

-- �̶� SELECT�� �÷��� �����ָ� ����
SELECT ename,
       SUM(sal) sum_sal, MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal, COUNT(sal) count_sal
FROM emp;

--GROUP BY�� ������ empno�̸� 
SELECT SUM(sal) sum_sal, MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal, 
       COUNT(sal) count_sal, -- sal �÷��� ���� NULL�� �ƴ� ROW�� ����
       COUNT(comm), -- comm �÷��� ���� NULL�� �ƴ� ROW�� ����
       COUNT(*)  -- ����� �����Ͱ� �ִ��� ----> COUNT �׷��Լ��� ��쿡�� �ƽ�Ÿ����ũ(*) ��밡��
FROM emp
GROUP BY empno;

-- �׷�ȭ�� ���þ��� ������ ���ڿ�, �Լ�, ���� ���� SELECT���� ������ ���� ����
SELECT 1, SYSDATE, 'DDD',
       SUM(sal) sum_sal, MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal, 
       COUNT(sal) count_sal, -- sal �÷��� ���� NULL�� �ƴ� ROW�� ����
       COUNT(comm), -- comm �÷��� ���� NULL�� �ƴ� ROW�� ����
       COUNT(*)  -- ����� �����Ͱ� �ִ��� ----> COUNT �׷��Լ��� ��쿡�� �ƽ�Ÿ����ũ(*) ��밡��
FROM emp
GROUP BY empno;

-- �� HAVING ��
-- SINGLE ROW FUNCTION�� ��� WHERE ������ ����ϴ� ���� �����ϳ�
-- GROUP FUNCTION�� ��� WHERE������ ����ϴ� ���� �Ұ��� �ϰ�
-- HAVING ������ ������ ����Ѵ�.


-- ����) �μ��� �޿� �� ��ȸ, �� �޿� ���� 9000�̻��� ROW�� ��ȸ
SELECT deptno, SUM(sal) sum_sal
FROM emp
GROUP BY deptno
HAVING SUM(sal) > 9000;

SELECT *
FROM EMP;

-- �ǽ�1
SELECT MAX(sal), MIN(sal), ROUND(AVG(sal),2), SUM(sal), COUNT(sal), COUNT(mgr), COUNT(*)
FROM emp;

-- �ǽ�2
-- emp���̺��� �̿��Ͽ� ������ ���Ͻÿ�
-- �μ����� 
SELECT deptno,
       MAX(sal), MIN(sal), ROUND(AVG(sal),2), SUM(sal), COUNT(sal), COUNT(mgr), COUNT(*)
FROM emp
GROUP BY deptno;

--�ǽ�3
--emp ���̺��� �̿��Ͽ� ���ض�
-- �ǽ�2�� ������ �̿��Ͽ� deptno ��� �μ����� �������� �ض���
-- CASE�� �̿�
SELECT CASE 
            WHEN deptno = 10 THEN 'ACCOUNTING'
            WHEN deptno = 20 THEN 'RESEARCH'
            WHEN deptno = 30 THEN 'SALES'
       END deptname, 
       MAX(sal), MIN(sal), ROUND(AVG(sal),2), SUM(sal), COUNT(sal), COUNT(mgr), COUNT(*)
FROM emp
GROUP BY deptno;

-- DECODE ���
SELECT DECODE(deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES') deptname, 
       MAX(sal), MIN(sal), ROUND(AVG(sal),2), SUM(sal), COUNT(sal), COUNT(mgr), COUNT(*)
FROM emp
GROUP BY deptno;

-- DOCODE ����� GROUP BY��
SELECT MAX(sal), MIN(sal), ROUND(AVG(sal),2), SUM(sal), COUNT(sal), COUNT(mgr), COUNT(*)
FROM emp
GROUP BY DECODE(deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES') ;

-- CASE ����� GROUP BY��
SELECT MAX(sal), MIN(sal), ROUND(AVG(sal),2), SUM(sal), COUNT(sal), COUNT(mgr), COUNT(*)
FROM emp
GROUP BY CASE 
            WHEN deptno = 10 THEN 'ACCOUNTING'
            WHEN deptno = 20 THEN 'RESEARCH'
            WHEN deptno = 30 THEN 'SALES'
       END;

-- �ǽ�4
-- emp���̺��� �̿��Ͽ� ������ ���ض�
-- ������ �Ի� ������� ����� ������ �Ի��ߴ��� ��ȸ
SELECT TO_CHAR(hiredate, 'YYYY-MM') hireYYYYMM, COUNT(TO_CHAR(hiredate, 'YYYY-MM')) cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYY-MM')
ORDER BY TO_CHAR(hiredate, 'YYYY-MM');

-- �ǽ�5
-- EMP ���̺� �̿�
-- ������ �Ի� �⺰�� ����� ������ �Ի��ߴ��� ��ȸ�ϴ� ����
SELECT TO_CHAR(hiredate, 'YYYY') hireYYYYMM, COUNT(*) cnt -- COUNT() �ȿ� *�� �־��൵ �ǰ� GROUP BY�� ���� �־��൵ ��
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYY')
ORDER BY TO_CHAR(hiredate, 'YYYY');

select *
from dept;

-- �ǽ�6
-- dept ���̺� �̿�
-- ȸ�翡 �����ϴ� �μ��� ������ ����� ��ȸ
SELECT COUNT(*) "�μ�����"
FROM dept;

SELECT *
FROM EMP;

--�ǽ�7
-- emp ���̺� �̿�
-- ������ ���� �μ��� ������ ��ȸ�ϴ� ����
SELECT COUNT(*)
FROM
      (SELECT deptno, COUNT(deptno)
       FROM emp
       GROUP BY deptno);
        

-- �� GROUP BY ���Ĺ���
-- ORACLE 9i ���������� GROUP BY���� ����� �÷����� ������ ����
-- ORACLE 10G ���� ���ʹ� GROUP BY���� ����� �÷����� ������ �������� �ʴ´�.(GROUP BY ���� �� �ӵ� UP)






