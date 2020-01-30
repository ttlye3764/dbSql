-- emp���̺��� 10��, 30�� �μ��� ���ϴ� ��� �� �޿��� 1500�� �Ѵ� ����鸸 ��ȸ�ϰ�
-- �̸����� �������� �����ض�
SELECT *
FROM emp
WHERE deptno IN(10,30) AND sal > 1500
ORDER BY ename desc;

-- tool���� �����ִ� ���� ��ȣ�� �÷����� ��������
-- ROWNUM : �� ��ȣ�� ��Ÿ���� �÷�
-- ����¡ Ȥ�� ���İ� ���õ� ���� �������� �߿��ϰ� ���
-- 1.
SELECT ROWNUM, empno, ename
FROM emp;
WHERE deptno IN(10,30) AND sal > 1500;

-- 2.ROWNUM alies�ֱ�
SELECT ROWNUM rn, empno, ename
FROM emp;

-- 3. WHERE ������ ���
-- �����ϴ°� : ROWNUM = 1 (1�� �ǰ� 2�� �ȵ�)  
--             ROWNUM <= 2 (>=�� �ȵ�)
--  -->  ���� ���� : ROWNUM = 1, ROWNUM <= N, ROWNUM >= 1
--  -->  ���� �Ұ��� : ROWNUM = N(N�� 1�� �ƴ� ����), ROWNUM >= N (N�� 1�� �ƴ� ����)
SELECT ROWNUM rn, empno, ename
FROM emp
WHERE ROWNUM >= 1;

-- ROWNUM�� �̹� ���� �����Ϳ� ������ �ο�
-- **������1) ���� ���� ������ ����(ROWNUM�� �ο����� ���� ��)�� ��ȸ�� �� ����.
-- **������2) ORDER BY ���� SELECT�� ���Ŀ� ����
-- ���뵵 : 1. ����¡ ó��
--           2. �ٸ� ��� ���еǴ� ������ ������ �÷� ����/Ȱ��
-- ���̺� �ִ� ��� ���� ��ȸ�ϴ� ���� �ƴ϶� �츮�� ���ϴ� �������� �ش��ϴ� �� �����͸� ��ȸ�Ѵ�.
-- ����¡ ó���� ������� : 1�������� �Ǽ�, ���� ����
-- EX)
-- EMP ���̺� �� ROW �Ǽ� : 14
-- ����¡�� 5���� �����͸� ��ȸ
-- 1page = 1~5, 2page = 6~10, 3page = 11~15

SELECT ROWNUM rn, empno, ename
FROM emp
ORDER BY ename;

--�̷����ϸ� rn�� ���׹��� ����

--�׷��� ���ĵ� ����� ROWNUM�� �ο� �ϱ� ���ؼ��� IN LINE VIEW�� ����Ѵ�.
-- ������� ���� ���� : 1. ����,2.��ȣ�� ���� 3. ROWNUM�ο�
--1.����
SELECT empno, ename
FROM emp
ORDER BY ename; 

--2.��ȣ�� ���� (IN LINE VIEW)
-- ��ȣ�� ������ �ش� ����� ������ �ִ� ���̺�(������ ��)�̶�� �����ϸ� ��
-- �� ��ȣ�� ������ FROM ���̺� <- ���̺� ������ ����
(SELECT empno, ename
FROM emp
ORDER BY ename); 

-- 3. �ۿ� SELECT ,FROM�� �Է�
-- ������ : SELECT *�� ����� ��� �ٸ� EXPRESSTION�� ǥ�� �ϱ� ���ؼ� ���̺�� .*, ���̺��Ī.*�� ǥ���ؾ� �Ѵ�.
SELECT ROWNUM, * -- ���⼭ *�� ������ ���������� ������ ���̺��� �˻��� �÷��� ���ڿ� *�� �˻����� �� ������ �÷��� ���� �ٸ��� ����
FROM
    (SELECT empno, ename
    FROM emp
    ORDER BY ename);  
    
--a ���̺��̶�� ��Ī�� ������ְ� ���̺�.*�� �˻�
SELECT ROWNUM, a.* 
FROM
    (SELECT empno, ename
    FROM emp
    ORDER BY ename) a;

    
SELECT ROWNUM, emp.*
FROM emp;

-- �ѹ��� ��ȣ�� �����ָ� RN�̶�� �� �÷����� ��� ��
-- ��, ó���� ���� �Ұ��� �ߴ� ROWNUM = 2,3,4,...  , ROWNUM >= 5 ��� ���� ����
SELECT *
FROM
(SELECT ROWNUM rn, a.* 
FROM
    (SELECT empno, ename
    FROM emp
    ORDER BY ename) a)
WHERE rn =2;

-- 1page : 1~5 , 2page : 6~10, 3page : 11~15
-- ROWNUM -> rn
-- * pageSize : 5, ���� ������ ename
-- 1 page : rn 1~5 
-- 2 page : rn 6~10
-- 3 page : rn 11~15
-- ����ȭ :  n page : rn (n-1)*pagesize + 1 ~ n * pageSize

--1page
SELECT *
FROM
(SELECT ROWNUM rn, a.* 
FROM
    (SELECT empno, ename
    FROM emp
    ORDER BY ename) a)
WHERE rn >=1 AND rn <=5;

--2page
SELECT *
FROM
(SELECT ROWNUM rn, a.* 
FROM
    (SELECT empno, ename
    FROM emp
    ORDER BY ename) a)
WHERE rn BETWEEN 6 AND 10;

-- n page : rn (n-1)*pagesize + 1 ~ n * pageSize
SELECT *
FROM
(SELECT ROWNUM rn, a.* 
FROM
    (SELECT empno, ename
    FROM emp
    ORDER BY ename) a)
WHERE rn BETWEEN (1-1)*5 AND 1*5; 

--�ǽ� 1
-- emp ���̺��� ROWNUM ���� 1~10�� ���� ��ȸ�ϴ� ������ �ۼ�(���� ����)
-- IN LINE VIEW �ȽἭ
SELECT ROWNUM rn, empno, ename
FROM emp
WHERE ROWNUM BETWEEN 1 AND 10;

-- emp ���̺��� ROWNUM ���� 1~10�� ���� ��ȸ�ϴ� ������ �ۼ�(���� ����)
-- IN LINE VIEW�Ἥ
SELECT *
FROM
    (SELECT ROWNUM rn, empno, ename
    FROM emp)
WHERE rn BETWEEN 1 AND 10;

--�ǽ� 2
SELECT *
FROM
    (SELECT ROWNUM rn, empno, ename
    FROM emp)
WHERE rn BETWEEN 11 AND 20;

--�ǽ�3
--emp ���̺��� ��� ������ �̸��÷����� �������� ���� ���� ���� 11~14��° ���� ������ ���� ��ȸ
SELECT *
FROM
    (SELECT ROWNUM rn, a.empno, a.ename
     FROM
      (SELECT *
       FROM emp
       ORDER BY ename) a)
WHERE rn BETWEEN 11 AND 14;

-- ���ε� ���� ����ϱ�  - : ��� -
SELECT *
FROM
(SELECT ROWNUM rn, a.* 
FROM
    (SELECT empno, ename
    FROM emp
    ORDER BY ename) a)
WHERE rn BETWEEN (:page-1)*:pageSize+1 AND :page* :pageSize;

-- �޼ҵ� : �Լ�(Function)
-- INPUT X -> FUNCTION F -> OUTPUT F(X) ����
-- INPUT�� �Ѱ� : Single row
-- INPUT�� �ΰ� :  

-- character �Լ� * �˻��ؼ� �˾ƺ���
-- ��ҹ��� : 1. ���
-- ���ڿ� ���� : 1.concat, 2/substr,  ���



--  DUAL table 
-- 1. sys ������ �ִ� ���̺�
-- 2. ������ ��밡��
-- 3. DUMMY �÷� �ϳ��� ����, ���� X, �����ʹ� �� �ุ ����

-- ���뵵
-- 1. �����Ϳ� ���þ��� �Լ� ����, ������ ���� �� (�Լ��� �׽�Ʈ �غ� ����)
SELECT *
FROM dual;

-- TEST�� ���ڿ��� ����
SELECT LENGTH('TEST')
FROM dual;

-- ���ڿ��� ��ҹ���
-- LOWER, UPPER, INITCAP
SELECT LOWER('Hello, World'), UPPER('Hello, World'), INITCAP('Hello, World')
FROM dual;

SELECT LOWER('Hello, World'), UPPER('Hello, World'), INITCAP('Hello, World')
FROM emp;

-- �Լ��� WHERE�������� ��밡��
-- ��� �̸��� SMITH�� ����� ��ȸ

-- �Լ� �Ⱦ���, ���ε� ���� ���
SELECT *
FROM emp
WHERE ename = :ename;

-- �Լ� ���� ���ε� ���� ���
SELECT *
FROM emp
WHERE ename = UPPER(:ename);

--SQL�ۼ��� �Ʒ� ���´� ���� �ؾ� �Ѵ�.
--WHY? ���̺��� �÷��� �������� �ʴ� ���·� SQL���� �ۼ��ؾ� �ϱ� ������.
-- ���⼭ ename�� ������ ����ŭ LOWER�Լ� �����
SELECT *
FROM emp
WHERE LOWER(ename) = :ename;

-- ���ھ� : ����Ŭ 
-- �����ڵ��� ���� �ʾƾ� �� ö������ �˻��ؼ� ��������


SELECT CONCAT('Hello', ', World') CONCAT, --���ڿ� ����
       SUBSTR('Hello, World', 1, 5) SUB, --  oralce������ 1������ 5������ ���, java������ 1������ 4������ ���
       LENGTH('Hello, World') LEN,
       INSTR('Hello, World', 'o') INS, -- o�� ó�� ������ ���ڿ��� �ε��� �˻�
       INSTR('Hello, World', 'o', 6) INS2, -- 6��° ���ڿ����� o�� ��ġ �ε��� �˻�
       LPAD('Hello, World', 15, '*') LP, -- ���ڿ��� 15������ ä���, ä�� ���ڿ��� *, ���ʺ��� ä��
       RPAD('Hello, World', 15, '*') RP, -- ���ڿ��� 15������ ä���, ä�� ���ڿ��� *, �����ʺ��� ä��
       REPLACE('Hello, World', 'H', 'T') REP, -- H���ڿ��� T�� ��ü
       TRIM('               Hello, World               ') TR, -- ���ڿ��� ��, �� ������ ����
       TRIM('d' FROM 'Hello, World') TR2, -- ������ �ƴ� �ҹ��� d ����
       TRIM('��' FROM '������ �����̴� �ٺ�') TR3,
       TRIM('��' FROM '������ �����̿��� �ٺ�') TR3
FROM dual;

--���� �Լ�
-- ROUND : �ݿø� (10.6�� �Ҽ��� ù° �ڸ����� �ݿø�) -> 11
-- TRUNC : ����(����) (10.6�� �Ҽ��� ù° �ڸ����� ����) -> 10
-- ROUND, TURNC : ���° �ڸ����� �ݿø�/ ����
-- MOD : ������ (���� �ƴ϶� ������ ������ �� ������ ��) (13/5 -> �� 2, ������ 3)

--ROUND (��� ����, ���� ��� �ڸ�)
SELECT ROUND(105.54,1) ROD,--�ݿø� ����� �Ҽ��� ù��° �ڸ����� �������� --> �ι�° �ڸ����� �ݿø�
       ROUND(105.55,1) ROD2,
       ROUND(105.55,0) ROD3,  -- �ݿø� ����� �����α��� --> �Ҽ��� ù��° �ڸ����� �ݿø�
       ROUND(105.55,-1) ROD4, -- ���� �ڸ����� �ݿø�
       ROUND(105.55) ROD5  -- ROD3�� ���� ���� ��, dafult���� 0
FROM dual;

SELECT TRUNC(105.54,1) TRU, -- ������ ����� �Ҽ��� ù��° �ڸ����� �������� --> �ι�° �ڸ����� ����
       TRUNC(105.55,1) TRU2, -- �����̱� ������ TRU�� ����
       TRUNC(105.55,0) TRU3, --������ ����� ������(���� �ڸ�) ���� �������� --> �Ҽ��� ù��° �ڸ����� ����
       TRUNC(105.55,-1) TRU4, --������ ����� ���� �ڸ����� �������� --> ���� �ڸ����� ����
       TRUNC(105.55) TRU5 --TRU3�� ���� ���� ��, dafult���� 0
FROM dual;

--emp ���̺��� ����� �޿�(sal)�� 1000����  ������ �� ��
SELECT ename, sal, TRUNC(sal/1000) ��, MOD(sal,1000) ������ -- mod�� ����� divisor(������ ��) ���� �׻� �۴�. 0~999
FROM emp;

desc emp;

--�⵵ 2�ڸ� �� 2�ڸ�, �� 2�ڸ�
SELECT ename, hiredate
FROM emp;

-- SYSDATE : ���� ����Ŭ ������ ��, ��, �ʰ� ���Ե� ��¥ ������ �������ִ� Ư�� �Լ�
-- �Ϲ������� �Լ��� ����� ���� �Լ�(����1, ����2)
-- BUT SYSDATE�� Ư�� �Լ��� �Լ������� ����
SELECT SYSDATE
FROM dual;

--����
--date + ���� = ���� ����
-- 1=�Ϸ�
-- 1�ð� = 1/24
SELECT SYSDATE+5, SYSDATE +1/24
FROM dual;

-- ���� ǥ�� : ���� --> 100
-- ���� ǥ�� : �̱� �����̼� --> '���ڿ�'
-- ��¥ ǥ�� : TO_DATE('���ڿ� ��¥ ��', '���ڿ� ��¥ ���� ǥ�� ����') --> TO_DATE('19941011', 'YYYYMMDD')
                                                                                                                                                                                    
--���� ppt function(date �ǽ� fn1) 
--ppt 129���� �߾��

SELECT TO_DATE('20191231','YYYYMMDD') LASTDAY, TO_DATE('20191231','YYYYMMDD')-5 LASTDAY_BEFORE5, 
       SYSDATE NOW, SYSDATE-3 NOW_BEFORE3
FROM dual;

                    
