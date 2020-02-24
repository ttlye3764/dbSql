
REPROT GROUP FUNCTION

1. ROLLUP
2. CUBE
3. GROUPING SETS

Ȱ�뵵
3, 1 >>>>>>>>>>>>>>>>>>>>>>>>>>>>> CUBE


GROUPING SETS
 ������ ������� ���� �׷��� ����ڰ� ���� ����
 ����� : GROUP BY GROUPING SETS(col1, col2, ...)
 
GROUP BY GROUPING SETS(col1, col2, ...)
 ==> GROUP BY col1
     UNION ALL
     GROUP BY col2 �� ����.
     
GROUP BY GROUPING SETS( (co1, co2), col3, col4)

==> GROUP BY col1, col2
    UNION ALL
    GROUP BY col3
    UNION ALL
    GROUP BY col4;
    
    
--GROUPING SETS�� ��� �÷� ��� ������ ����� ������ ��ġ�� �ʴ´�.
--  * ROLLUP�� �÷� ��� ������ ����� ������ ��ģ��.
  
GROUP BY  GROUPING SETS(col1, col2)
==> GROUP BY col1
    UNION 
    GROUP BY col2
    
GROUP BY  GROUPING SETS(col2, col1)
==> GROUP BY col2
    UNION 
    GROUP BY col1

--�ǽ�    
SELECT job, deptno, SUM(sal) sal
FROM emp
GROUP BY GROUPING SETS(job, deptno);
==> ����
GROUP BY job
UNION 
GROUP BY deptno;

job, deptno�� GROUP BY�� ����� 
mgr�� GROUP BY �� ����� ��ȸ�ϴ� SAQL�� GROUPING SETS�� �޿��� SUM(sal) �ۼ�

SELECT job, deptno
FROM emp
GROUP BY job, deptno;

SELECT mgr
FROM emp
GROUP BY mgr;

SELECT job, deptno, mgr, SUM(sal)
FROM emp
GROUP BY GROUPING SETS ((job,deptno),mgr);


CUBE 
������ ��� �������� �÷��� ������ SUB GROUP �� �����Ѵ�.

 GROUP BY CUBE(col1, col2);
 
 (col1, col2) ==>
 
 (null, col2) == GROUP BY col2
 (null, null) == GROUP BY ��ü
 (col1, null) == GROUP BY col1
 (col1, nul2) == GROUP BY col1, col2;
 
 SELECT job, deptno, SUM(sal) sal
 FROM emp
 GROUP BY CUBE(job, deptno);
 
    		29025  -> null
        10	8750   -> deptno
        20	10875
        30	9400
CLERK		4150   -> job
CLERK	10	1300   -> job, deptno
CLERK	20	1900
CLERK	30	950
ANALYST		6000
ANALYST	20	6000
MANAGER		8275
MANAGER	10	2450
MANAGER	20	2975
MANAGER	30	2850
SALESMAN		5600
SALESMAN	30	5600
PRESIDENT		5000
PRESIDENT	10	5000

SELECT job, deptno, mgr, SUM(sal) sal
FROM emp
GROUP BY job, ROLLUP(deptno), CUBE(mgr);



==> GROUP BY job, deptno, mgr == GROUP BY job, deptno, mgr
==> GROUP BY job, deptno == GROUP BY job, deptno = 
==> GROUP BY job, null, mgr == GROUP BY job, mgr
==> GROUP BY null, null == GROUP BY job


 �������� UPDATE
 1. emp_test ���̺� DROP
 2. emp ���̺��� �̿��ؼ� emp_test���̺� ����(��� �࿡ ���� CTAS)
 3. emp_test ���̺� dname VARCHAR2(14) �÷��߰�
 4. emp_test.dname �÷��� dept ���̺��� �̿��ؼ� �μ����� ������Ʈ;
 
 -- emp_test ���̺� ����
 DROP TABLE emp_test;
 
 -- emp���̺��� CTAS�� emp_test���̺� ����
 CREATE TABLE emp_test AS
 SELECT *
 FROM emp;
 
 -- ���̺� ��ȸ
 SELECT *
 FROM emp_test;
 
 -- emp_test ���̺� dname VARCHAR2(14) ����
 ALTER TABLE emp_test ADD(dname VARCHAR2(14));
 
 -- emp_test ���̺� dname ������ ���� (dept���̺� �̿�)
 UPDATE emp_test SET dname = (SELECT dname
                              FROM dept
                              WHERE dept.deptno = emp_test.deptno);
                              
 
 --dept ���̺��� ����
 DROP  TABLE dept_test;
 --dept ���̺��� �̿��Ͽ� dept_test ���̺����
 CREATE TABLE dept_test AS
 SELECT *
 FROM dept;
 -- �÷� ����
 ALTER TABLE dept_test ADD(dmpcnt NUMBER);
 -- ������ ������Ʈ
 UPDATE dept_test SET dmpcnt = (SELECT count(deptno)
                                FROM emp
                                WHERE emp.deptno = dept_test.deptno);
                                
sub_a2;
dept_test ���̺� �ִ� �μ��߿� ������ ������ ���� �μ������� ����
 *dept_test.dmpcnt �÷��� ������� �ʰ�
INSERT INTO dept_test VALUES(99, 'it1' ,'daejeon',0);
INSERT INTO dept_test VALUES(98, 'it1' ,'daejeon',0);

--ALTER TABLE dept_test DROP COLUMN (
SELECT *
FROM dept_test
WHERE deptno NOT IN (SELECT deptno
                FROM emp
                WHERE dept_test.deptno = emp.deptno));
                
DELETE FROM dept_test
WHERE IN(
        SELECT deptno
        FROM dept_test
        WHERE deptno NOT IN (SELECT deptno
                            FROM emp
                            WHERE dept_test.deptno = emp.deptno));
                


SELECT ename
FROM emp
WHERE deptno != (SELECT deptno
                FROM dept_test
                WHERE emp.deptno = dept_test.deptno);



                SELECT *
                FROM dept_test;
                
                SELECT *
                FROM EMP;
                

emp ���̺��� �̿��Ͽ� emp_test ���̺� ����
SUBQUERY�� �̿��Ͽ� emp_test ���̺��� ������ ���� �μ��� ��� �޿����� �޿��� ����
������ �޿��� �� �޿����� 200�� �߰��ؼ� ������Ʈ �ϴ� ������ �ۼ��ϼ���

UPDATE emp_test SET sal = sal + 200
WHERE emp_test.empno in
(SELECT empno
FROM emp_test a
WHERE sal  <(
            SELECT ROUND(AVG(sal),2)
            FROM emp_test b
            WHERE a.deptno = b.deptno
            GROUP BY deptno));
SELECT *
FROM EMP_TEST;


MERGE INTO emp_test a
    USING (SELECT empno
          FROM emp_test a
          WHERE sal  <(
                       SELECT ROUND(AVG(sal),2)
                         FROM emp_test b
                        WHERE a.deptno = b.deptno
                        GROUP BY deptno)) b
    ON (a.empno = b.empno)
    WHEN MATCHED THEN
        UPDATE SET a.sal = a.sal+200;
        
        SELECT *
        FROM EMP_TEST;
        

SELECT *
FROM EMP_TEST;
 
-- �� WITH��
-- �ϳ��� �������� �ݺ��Ǵ� ���������� ���� �� �ش� SUBQUERY�� ������ �����ؿ� ����
-- MAIN������ ����� �� WITH ������ ���� ���� �޸𸮿� �ӽ������� ����
--  ==> MAIN ������ ����Ǹ� �޸� ����

-- SUBQUERY �ۼ��ÿ��� �ش� SUBQUERY�� ����� ��ȸ�ϱ� ���ؼ� I/O�� �ݺ������� �Ͼ����
-- WITH���� ���� �����ϸ� �ѹ��� SUBQUERY�� ����ǰ� �� ����� �޸𸮿� ������ ���� ����
-- ��, �ϳ��� �������� ������ SUBQUERY�� �ݺ������� ������ ���� �߸� �ۼ��� ������ ���ɼ��� ����

-- WITH ��������̸� AS(
--    ��������
-- )
-- SELECT *
-- FROM ������� �̸�

������ �μ��� �޿� ����� ��ȸ�ϴ� ��������� WITH���� ���� ����

WITH sal_avg_dept AS(
    SELECT deptno, ROUND(AVG(sal), 2) sal
    FROM emp
    GROUP BY deptno
),
   dept_empcnt AS(
    SELECT deptno, COUNT(*) empcnt
    FROM emp
    GROUP BY deptno)

SELECT *
FROM sal_avg_dept a, dept_empcnt b
WHERE a.deptno = b.deptno;

--��� ��
--��¥ �����͸� ���鶧 ���
WITH temp AS (
    SELECT sysdate - 1 FROM dual UNION ALL
    SELECT sysdate - 2 FROM dual UNION ALL
    SELECT sysdate - 3 FROM dual)
SELECT *
FROM temp;


-- �޷� �����
SELECT *
FROM dual;  --> 1�� ��

--CONNECT BY LEVEL <[=] ����
--�ش� ���̺��� ���� ������ŭ �����ϰ�, ������ ���� �����ϱ� ���ؼ� LEVEL�� �ο�
--LEVEL�� 1���� ����

SELECT dummy, LEVEL
FROM dual  
CONNECT BY LEVEL <=10 ;

SELECT dept.*, LEVEL
FROM dept
CONNECT BY LEVEL <=5
ORDER BY LEVEL;

2020�� 2���� �޷��� ����
:dt = 202002, 202003
1.�ش� ���� ���ڸ�ŭ LEVEL����

SELECT TO_DATE('202003','YYYYMM') + (LEVEL-1)
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY( TO_DATE('202003','YYYYMM')),'DD');

2. �� �� ȭ �� �� �� ��


SELECT TO_DATE('202003','YYYYMM') + (LEVEL-1),
       TO_CHAR(TO_DATE('202003','YYYYMM') + (LEVEL-1),'D'),
       DECODE(TO_CHAR(TO_DATE('202003','YYYYMM') + (LEVEL-1),'D'), 1,TO_DATE('202003','YYYYMM') + (LEVEL-1)) s,
       DECODE(TO_CHAR(TO_DATE('202003','YYYYMM') + (LEVEL-1),'D'), 2,TO_DATE('202003','YYYYMM') + (LEVEL-1)) s,
       DECODE(TO_CHAR(TO_DATE('202003','YYYYMM') + (LEVEL-1),'D'), 3,TO_DATE('202003','YYYYMM') + (LEVEL-1)) s,
       DECODE(TO_CHAR(TO_DATE('202003','YYYYMM') + (LEVEL-1),'D'), 4,TO_DATE('202003','YYYYMM') + (LEVEL-1)) s,
       DECODE(TO_CHAR(TO_DATE('202003','YYYYMM') + (LEVEL-1),'D'), 5,TO_DATE('202003','YYYYMM') + (LEVEL-1)) s,
       DECODE(TO_CHAR(TO_DATE('202003','YYYYMM') + (LEVEL-1),'D'), 6,TO_DATE('202003','YYYYMM') + (LEVEL-1)) s,
       DECODE(TO_CHAR(TO_DATE('202003','YYYYMM') + (LEVEL-1),'D'), 7,TO_DATE('202003','YYYYMM') + (LEVEL-1)) s
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY( TO_DATE('202003','YYYYMM')),'DD');



SELECT TO_CHAR(LAST_DAY( TO_DATE('202003','YYYYMM')),'DD')
FROM dual;

D : ����
SELECT TO_CHAR(LAST_DAY( TO_DATE('202003','YYYYMM')),'D')
FROM dual;

-- �߿��� : ���� ���� �ٲٴ°�
-- ����Ʈ �������� ���� ����

���� ���� : 




    
    