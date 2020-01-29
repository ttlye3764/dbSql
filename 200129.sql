--DATE : TO_DATE ���ڿ� -> ��¥ 
--       TO_CHAR ��¥ -> ���ڿ�
-- JAVA������ ��¥ ������ ��ҹ��ڸ� ������(MM / mm -> �� / ��)
SELECT TO_CHAR(SYSDATE, 'YYYY-MM/DD HH24:MI:SS')  -- HH24 �ð� / MI �� / SS �� (ǥ���)
FROM dual;

-- date ����
-- YYYY : 4�ڸ� ����
-- MM : 2�ڸ� ��
-- DD : 2�ڸ� ����

SELECT TO_CHAR(SYSDATE, 'YYYY-MM/DD HH24:MI:SS')  ,
        TO_CHAR(SYSDATE, 'D'),   -- D : �ְ� ����(1~7), �Ͽ��� 1, ������ 2, ..., ����� 7
        TO_CHAR(SYSDATE, 'IW'),  -- IW : ���� (ISO ǥ�� - �ش� ���� ������� �������� ������ ����) 
        TO_CHAR(TO_DATE('2019/12/31','YYYY/MM/DD'), 'IW')
FROM dual;

SELECT TO_DATE('19941011 09:50:10','YYYYMMDD HH24:MI:SS') 
FROM dual;

SELECT TO_DATE('19941024') 
FROM dual;

SELECT TO_CHAR(TO_DATE('2019/12/31 01:01:01','YYYY/MM/DD HH24:MI:SS'), 'YYYY/MM/DD HH24:MI:SS') --TO_CHAR������ �ú��ʰ� �����µ� TO_DATE������ �ú��ʰ� �ȳ��Ϳ� -> ȯ�漳��-NLS���� �����ϴϱ� �ǿ�
FROM dual; 

-- emp ���̺��� hiredate(�Ի�����) �÷��� �� �� �� ��:��:��
SELECT ename, hiredate,
       TO_CHAR(hiredate, 'YYYY-MM-DD HH24:MI:SS'),
       TO_CHAR(hiredate + 1, 'YYYY-MM-DD HH24:MI:SS'),  -- 1�Ͼ� +
       TO_CHAR(hiredate + 1/24, 'YYYY-MM-DD HH24:MI:SS')  -- 1�ð��� +
FROM emp;

--�ǽ� fn2
-- ���� ��¥�� ������ ���� �������� ��ȸ
-- 1.��-��-��
-- 2.��-��-�� �ð�(24)-��-��
-- 3. ��-��-��
SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD') DT_DASH, 
       TO_CHAR(SYSDATE,'YYYY-MM-DD HH24-MI-SS') DT_DASH_WITH_TIME,
       TO_CHAR(SYSDATE,'DD-MM-YYYY') DT_DD_MM_YYYY
FROM dual;

--date 
--��¥ ����
--ROUND(DATE, format) : �ݿø�
--TRUN(DATE, format) : ����

SELECT ename, hiredate, 
       MONTHS_BETWEEN(SYSDATE, hiredate), -- MONTHS_BETWEEN(DATE,DATE) : �� ��¥ ������ ������
       MONTHS_BETWEEN(TO_DATE('2020-01-17','YYYY-MM-DD'), hiredate)
FROM emp
WHERE ename ='SMITH';

--                    * �� �� *

SELECT ADD_MONTHS(SYSDATE, 5),    -- ADD_MONTHS(DATE, ����-������ ������) : NUMBER���� ������ ��¥
       ADD_MONTHS(SYSDATE, -5)
FROM dual;

-- NEXT_DAY(DATE, �ְ�����) : DATE ���� weekday EX) NEXT_DAY(SYSDATE, 5) -> SYSDATE ���� ó�� �����ϴ� 5�� �ش��ϴ� ����
--                                                 SYSDATE 2020/01/29(��)    
SELECT NEXT_DAY(SYSDATE, 3)
FROM dual;

SELECT NEXT_DAY(SYSDATE, 'ȭ') -- ���ڷε� ����(�� - 1, �� -2, ...�� - 6)
FROM dual;

-- LAST_DAY(DATE) : DATE�� ���� ���� ������ ��¥
SELECT LAST_DAY(SYSDATE),
        -- DATE�� ���� ���� ù��° ��¥ ���ϴ� ��
       LAST_DAY(ADD_MONTHS(SYSDATE,-1))+1,
       TO_DATE('01','DD'),
       ADD_MONTHS(LAST_DAY(SYSDATE)+1,-1),
       TO_DATE(TO_CHAR(SYSDATE, 'YYYY-MM') || '-01', 'YYYY-MM-DD')
FROM dual;

-- hiredate ���� �̿��Ͽ� �ش� ���� ù��° ���ڷ� ǥ��
SELECT ename, hiredate,
       LAST_DAY(ADD_MONTHS(hiredate, -1))+1,
       TO_DATE(TO_CHAR(hiredate, 'YYYY-MM') || '-01', 'YYYY-MM-DD')
FROM emp;

--�� ��ȯ
-- 1. ����� ����ȯ (���ݱ��� ����)
-- 2. ������ ����ȯ

--empno�� NUMBER Ÿ��, ���ڴ� ���ڿ��� ��
-- Ÿ���� ���� �ʱ� ������ ������ ����ȯ�� �Ͼ
-- ���̺� �÷��� �°� �ùٸ� ���� ���� �ִ°� �߿�
SELECT *
FROM emp
WHERE empno='7369';

-- hiredate�� ��� DATEŸ��, ���ڴ� ���ڿ��� �־����� ������ ������ ����ȯ�� �߻�
-- ��¥ ���ڿ� ���� ��¥ Ÿ������ ��������� ����ϴ� ���� ����
SELECT *
FROM emp
WHERE hiredate = '19801217';

SELECT *
FROM emp
WHERE hiredate = TO_DATE('19801217','YYYYMMDD');

-- ���� ��ȹ Ȯ���ϱ�
-- 1. EMPLAIN PLAN FOR ����
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno='7369';

-- 2. Ư���Լ� table(dbms_xplan.display) ����
-- ������ �Ʒ��� ����, �鿩���Ⱑ ������ �ڽ��̶�� �Ҹ� (�ڽ�->�θ� ����)
SELECT *
FROM table(dbms_xplan.display);


-- ���ڸ� ���ڷ� ����ȯ
-- ���ڸ� ���ڿ��� �����ϴ� ��� : ����
-- õ���� ������ 
-- �ѱ� : 1,000.55
-- ���� : 1.000,55

-- emp sal �÷�(NUMBER Ÿ��)�� ������
SELECT ename, sal, TO_CHAR(sal, '9,999'), -- 9 : ���� õ�ڸ����� �޸�(,)�� ǥ���ϰڴ�
       TO_CHAR(sal, '009,999'), -- 0 :���� �ڸ� ����(0���� ǥ��)
       TO_CHAR(sal, 'L009,999') -- L : ��ȭ����
FROM emp;

-- ����ȭ
-- EXERD

-- NULL �Լ�
-- 1. NVL
-- 2. NVL2
-- 3. NULLIF

-- NULL�� ���� ������ ����� �׻� NULL

-- emp ���̺��� sal �÷����� null �����Ͱ� �������� ����(14���� �����Ϳ� ����)
-- emp ���̺��� comm �÷����� null �����Ͱ� ����(14���� �����Ϳ� ����)
-- sal + comm --> comm�� null�� �࿡ ���ؼ��� ����� null�� ����
SELECT ename, sal, comm, sal + comm
FROM emp;

-- �� ��, �䱸������ comm�� null�̸� sal�÷��� ���� ��ȸ�Ҷ�?

-- NVL(Ÿ��, ��ü��)
-- Ÿ���� ���� NULL�̸� ��ü���� ��ȯ�ϰ�
-- Ÿ���� ���� NULL�� �ƴϸ� Ÿ�� ���� ��ȯ
SELECT ename, sal, comm, 
       NVL(sal + comm, sal),
       NVL(comm , 0),
       sal + NVL(comm, 0),
       NVL(sal+comm, 0)
FROM emp;

-- NVL2(expr1, expr2, expr3)

-- if(expr1 != null)
--  return expr2;
-- else
--  return expr3;

SELECT ename, sal, comm,
       NVL2(comm, 10000, 0)
FROM emp;

--NULLIF(expr1, expr2)

--if(expr1 == expr2)
--   return null;
--else
--   return expr1;
SELECT ename, sal, comm, NULLIF(sal, 1250) -- sal�� 1250�� ����� 1250�� return, 1250�� �ƴ� ����� sal�� ����
FROM emp;


-- COALESCE(expr1, expr2, ...)
-- �����߿� ���� ó������ �����ϴ� null�� �ƴ� ���ڸ� ��ȯ
-- ��������
-- if(expr1 != null)
--    return expr1;
-- else
--    return COALESCE(expr2, expr3....)

-- comm�� null�� �ƴϸ� comm, comm�� null�̸� sal
SELECT ename, sal, comm, COALESCE(comm, sal)
FROM emp;

-- �ǽ� 4
-- emp ���̺��� ������ ������ ���� ��ȸ
-- NVL, NVL2, COALESCE�̿�
SELECT empno, ename, mgr,
       NVL(mgr,9999),
       NVL2(mgr,mgr,9999),
       COALESCE(mgr,9999)
FROM emp;

-- �ǽ�5
-- users ���̺��� ������ ������ ���� ��ȸ
-- reg_dt�� null�� ��� sysdate�� ����
SELECT userid, usernm, reg_dt, NVL(reg_dt, SYSDATE) n_reg_dt 
FROM users
WHERE usernm != '����';

--function
-- 1. �̱�
-- 2. ��Ƽ

-- Condition : ������
-- 1. CASE
-- 2. DECODER

-- CASE : Java�� if - else if - else ���� ����� ����

-- CASE
--    WHEN ���� THAN ���ϰ�1 
--    WHEN ����2 THAN ���ϰ�2
--    ELSE �⺻��
-- END

-- ����) emp���̺��� JOB �÷��� ���� SALMESMAN �̸� SAL * 1.05 ����
--                                  MANAGER �̸� SAL * 1.1 ����
--                                  PRESIDENT �̸� SAL * 1.2 ����
--                                  �� ���� ������� SAL ����
SELECT ename, job, sal,
       CASE
            WHEN job = 'SALESMAN' THEN sal* 1.05
            WHEN job = 'MANAGER' THEN sal* 1.1
            WHEN job = 'PRESIDENT' THEN sal* 1.2
            ELSE sal
       END bonus_sal
FROM emp
ORDER BY job;



-- DECODE�Լ� : CASE���� ����
--�ٸ��� : CASE�� - WHEN ���� ���Ǻ񱳰� �����Ӵ�
--        DECODE �Լ� : �ϳ��� ���� ���ؼ� = �񱳸� ���
-- ��������(������ ������ ��Ȳ�� ���� �þ �� ����)
-- DECODE(col | expr, ù��° ���ڿ� ���� ��1, ù��° ���ڿ� �ι�° ���ڰ� ���� ��� ��ȯ ��,
--                    ù��° ���ڿ� ���� ��2, ù��° ���ڿ� �׹�° ���ڰ� ���� ��� ��ȯ ��, ...
--                    option - else ���������� ��ȯ�� �⺻��)

-- ����) emp���̺��� JOB �÷��� ���� SALMESMAN �̸� SAL * 1.05 ����
--                                  MANAGER �̸� SAL * 1.1 ����
--                                  PRESIDENT �̸� SAL * 1.2 ����
--                                  �� ���� ������� SAL ����

SELECT ename, job, sal,
        DECODE(job, 'SALESMAN', sal*1.05,
                    'MANAGER', sal*1.1,
                    'PRESIDENT', sal*1.2, sal) bonus_sal
FROM emp
ORDER BY job;

-- ����) emp���̺��� JOB �÷��� ���� SALMESMAN �̸鼭 sal�� 1400���� ũ�� SAL * 1.05 ����
--                                  MANAGER �̸鼭 SAL�� 1400���� ������ SAL * 1.1 ����
--                                  PRESIDENT �̸� SAL * 1.2 ����
--                                  �� ���� ������� SAL ����

SELECT ename, job, sal,
        CASE
            WHEN job = 'SALESMAN' AND sal>1400 THEN sal* 1.05
            WHEN job = 'MANAGER' AND sal <1400 THEN sal* 1.1
            WHEN job = 'PRESIDENT' THEN sal* 1.2
            ELSE sal
       END bonus_sal
FROM emp
ORDER BY job;

-- 

SELECT ename, job, sal
FROM emp;







             







