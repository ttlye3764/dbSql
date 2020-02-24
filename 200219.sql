���� ���� ��� 11��
����¡ ó��(�������� 10���� �Խñ�)
1������ : 1~10
2������ : 11~20
���ε庯�� :page, :pageSize;
rn (page-1)*pagesize+1 ~ page * pagesize;

SELECT *
FROM(
     SELECT rownum rn,seq, LPAD(' ', (LEVEL-1)*4) || title title, DECODE(parent_seq, NULL, seq, parent_seq) root
     FROM board_test
     START WITH parent_seq IS NULL
     CONNECT BY PRIOR seq = parent_seq
     ORDER SIBLINGS BY root DESC, seq ASC)
WHERE rn between (:page-1)*:pageSize +1 and :page * :pageSize;




-------���� ��ŷ�ο��ϱ�-------
SELECT b.ename, b.sal, a.lv
FROM
(SELECT a.*, rownum rm
FROM
(SELECT *
FROM
(   SELECT LEVEL lv
    FROM dual
    CONNECT BY LEVEL <=14) a,
(   SELECT deptno, COUNT(*) cnt
    FROM emp
    GROUP BY deptno) b
WHERE b.cnt >= a.lv
ORDER BY b.deptno, a.lv) a) a 
JOIN
(SELECT b.*, rownum rm
FROM
(SELECT ename, sal, deptno
FROM emp
ORDER BY deptno, sal desc)b) b ON(a.rm = b.rm);

���� ������ �м��Լ��� ����ؼ� ǥ���ϸ�...;

SELECT ename, sal, deptno, ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal DESC) rank
FROM emp;

�м��Լ� ����
�м��Լ���([����]) OVER([PARTITION BY �÷�] [ORDER BY �÷�] [WINDOWING])
PARTITION BY �÷� : �ش� �÷��� ���� ROW ���� �ϳ��� �׷����� ���´�. 
ORDER BY �÷� : PARTITION BY�� ���� ���� �׷� ������ ORDER BY �÷����� ����

ROW_NUMBER() OVER(PARTITION BY deptno ORDER BY sal DESC) rank;

���� ���� �м��Լ�
RANK : ���� ���� ������ �ߺ� ������ ����, �ļ����� �ߺ� ����ŭ ������ ������ ����
       2���� 2���̸� 3���� ���� 4����� �ļ����� �����ȴ�.
DENSE_RANK() : ���� ���� ������ �ߺ� ������ ����, �ļ����� �ߺ����� �������� ����
               2���� 2���̴��� �ļ����� 3����� ����
ROW_NUMBER() : ROWNUM�� ����, �ߺ��� ���� ������� ����;

�μ���, �޿� ������ 3���� ��ŷ �����Լ��� ����;

SELECT ename, sal, deptno,
        RANK() OVER (PARTITION BY deptno ORDER BY sal) sal_rank,
        DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal) sla_dense_rank,
        ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal) sla_row_number
FROM emp;


SELECT ename, sal, deptno,
        RANK() OVER (ORDER BY sal, empno) sal_rank,
        DENSE_RANK() OVER (ORDER BY sal,empno) sla_dense_rank,
        ROW_NUMBER() OVER (ORDER BY sal, empno) sla_row_number
FROM emp;



SELECT *
FROM emp;

ALTER TABLE emp ADD (EN NUMBER);
SELECT *
FROM EMP;
UPDATE emp SET EN = 1
WHERE EN IS NULL;

COMMIT;


SELECT A.empno, A.ename, A.deptno, B.count
FROM(
        SELECT empno, ename, deptno
        FROM emp) A,

        (SELECT deptno, COUNT(*) count
        FROM emp
        GROUP BY deptno) B
WHERE A.deptno =  B.deptno
ORDER BY A.deptno;

������ �м��Լ�(GROUP �Լ����� �����ϴ� �Լ� ������ ����)

SUM(�÷�)
COUNT(*), COUNT(�÷�)
MIN(�÷�)
MAX(�÷�)
AVG(�÷�)

no_ana2�� �м��Լ��� ����Ͽ� �ۼ�
�μ��� ���� ��

SELECT empno, ename, deptno,
       COUNT(*) OVER(PARTITION BY deptno) cnt
FROM emp;

--��� ������ ������� �׻���� ���� �μ��� �޿� ����� ��ȸ
SELECT empno, ename, deptno, sal,
        AVG(sal) OVER(PARTITION BY DEPTNO) AVG_SAL
FROM emp;

--��� ������ ������� �׻���� ���� �μ��� �ִ�޿��� ��ȸ
SELECT empno, ename, deptno, sal,
        MAX(sal) OVER(PARTITION BY DEPTNO) AVG_SAL
FROM emp;

--��� ������ ������� �׻���� ���� �μ��� �ּ� �޿��� ��ȸ
SELECT empno, ename, deptno, sal,
        MIN(sal) OVER(PARTITION BY DEPTNO) AVG_SAL
FROM emp;

�޿��� �������� �����ϰ�, �޿��� ���� ���� �Ի����ڰ� ���� ����� ���� �켱������ �ǵ��� �����Ͽ�
�������� ������(LEAD)�� sal �÷��� ���ϴ� ���� �ۼ�

SELECT empno, ename, hiredate, sal, LEAD(sal) OVER(ORDER BY SAL DESC, hiredate) lead_sal
FROM emp; -- 1�ܰ� �� SAL

SELECT empno, ename, hiredate, sal, LEAD(sal) OVER(ORDER BY SAL , hiredate) lead_sal
FROM emp; -- 1�ܰ� �� SAL

SELECT empno, ename, hiredate, sal, LAG(sal) OVER(ORDER BY SAL DESC, hiredate) lead_sal
FROM emp; -- 1�ܰ� �� SAL

SELECT empno, ename, hiredate, job, sal, LAG(sal) OVER(PARTITION BY JOB ORDER BY sal desc) lag_sal
FROM emp; -- 1�ܰ� �� SAL

��� ����� ����, �������� �޿� ������ 1�ܰ� ���� ��� (�޿��� ���� ��� �Ի����� ���� ����� ���� ����)



SAL�� �����ϰ� �ڽź��� �޿��� ��������� �޿� + �ڽ��� �޿� ���ϱ�
SELECT A.ENAME, A.SAL, SUM(B.SAL)
FROM(
SELECT ROWNUM RM, A.*
FROM
(SELECT *
FROM emp
ORDER BY sal, empno) a) A
,
(SELECT ROWNUM RM, B.*
FROM
(SELECT *
FROM emp
ORDER BY sal, empno) B) B
WHERE A.RM >= B.RM 
GROUP BY A.ENAME, A.SAL
ORDER BY SAL;

--> ���� ������ �м��Լ��� �̿��Ͽ� SQL

SELECT empno, ename, sal, SUM(sal) OVER( ORDER BY sal,empno ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) cumm_sal
FROM emp;

�������� �������� ���� ������� ���� ������� �� 3������ sal �հ� ���ϱ�

SELECT empno, ename, sal, SUM(sal) OVER(ORDER BY sal,empno ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING ) C_SUM
FROM emp;

�ǽ�
SELECT empno, ename, sal, SUM(sal) OVER(PARTITION BY deptno ORDER BY sal, empno ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) C
FROM emp;

--ORDER BY ����� WINDOWING ���� ������� ���� ��� ���� WINDOWING �� �⺻ ������ ����ȴ�.
--RANGE UNBOUNDED PRECEDING = RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW;

SELECT empno, ename, sal, SUM(sal) OVER(PARTITION BY deptno ORDER BY sal, empno ) C
FROM emp;    

-- WINDOWING �� RANGE, ROWS ��
-- RANGE : ������ ���� ����, ���� ���� ������ �÷����� �ڽ��� ������ ���  
-- ROWS : �������� ���� ����, ���� ���� ������ �÷��� �ڽ��� ������ ������� ����

SELECT empno, ename, sal, 
       SUM(sal) OVER(PARTITION BY deptno ORDER BY sal ROWS UNBOUNDED PRECEDING ) ROW_,   --> ���� ROW�� ���� ROW�� ���� ���� ��� �ڽ��� ROW��� �����ϰ� ���� �� ������ �ʴ´�.
       SUM(sal) OVER(PARTITION BY deptno ORDER BY sal RANGE UNBOUNDED PRECEDING ) RANGE,
       SUM(sal) OVER(PARTITION BY deptno ORDER BY sal) DEFAULT_
FROM emp;    
        
-------------------------
| RATIO_TO_REPORT       |
| PERCENT_RANK          |
| CUME_DIST             |
| NTILE                 |
-------------------------                                                                                                                                                                                               






