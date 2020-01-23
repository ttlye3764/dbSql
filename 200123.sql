-- ���ǿ� �´� ������ ��ȸ�ϱ�
--emp ���̺��� �Ի� ���ڰ� 1982�� 1�� 1�� ���ĺ��� 1983�� 1�� 1�� ������ ����� ename, hiredate�� ��ȸ�ϴ� ������ �ۼ��Ͻÿ�
--�����ڴ� �� ������ ���
SELECT ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('19820101','YYYYMMDD') AND  hiredate <= TO_DATE('19830101','YYYYMMDD');

-- WHER���� ����ϴ� ���ǿ� ������ ��ȸ ����� ������ ��ġ�� �ʴ´�.
-- SQL�� �⺻������ ������ ������ ���� �ִ�.
-- ���� : Ű�� 186CM �̻��̰� �����԰� 70KG �̻��� ������� ����
--             -> �����԰� 70KG �̻��̰� Ű�� 186�̻��� ������� ���� 
--             ������ ������ �ٲ����� ������ �������� ������ ���� ���� �ʱ� ������ ����� ��� X (������ ������ ����.)
--        �߻��� ����� ���� --> ����X (������ ��Ȯ���� �ʱ� ������)
-- ���̺��� ������ ������� ����
-- SELECT ��� ������ �ٸ����� ���� �����ϸ� �������� ����
--  * ���� ��� ���� (ORDER BY)


-- IN ������
-- Ư�� ���տ� ���ԵǴ��� ���θ� Ȯ��
SELECT empno, ename, deptno
FROM emp;
-- �μ� ��ȣ�� 10�� Ȥ�� 20���� ���ϴ� ���
-- IN
SELECT empno, ename, deptno
FROM emp
WHERE deptno IN(10,20);
-- OR
SELECT empno, ename, deptno
FROM emp
WHERE deptno = 10 OR deptno = 20;

-- emp���̺��� ����̸��� SMITH, JONES�� ������ ��ȸ(empno, ename, deptno)
-- IN
SELECT empno, ename, deptno
FROM emp
WHERE ename IN('SMITH','JONES');
-- OR
SELECT empno, ename, deptno
FROM emp
WHERE ename ='SMITH' OR ename ='JONES';

SELECT *
FROM users
WHERE 1=1;

-- users ���̺��� userid�� brown, cony, sally�� �����͸� ������ ���� ��ȸ�Ͻÿ� 
-- IN ������ ���
SELECT userid AS ���̵�,usernm AS �̸�, alias AS ����
FROM users
WHERE userid IN('brown', 'cony', 'sally');

-- ���ڿ� ��Ī ������ : LIKE, %, _
-- * ���ڿ� ��Ī������ = ��� LIKE Ű���带 ���
-- * % : � ���ڿ�(�ѱ���, ���� �������� �ְ�, ���� ���ڿ��� �ü��� �ִ�.)
-- * _ : ��Ȯ�� �ѹ��� 
-- ������ ������ ������ ���ڿ� ��ġ�� ���ؼ� �ٷ�
-- �̸��� BR�� �����ϴ� ����� ��ȸ
-- �̸��� R���ڿ��� ���� ����� ��ȸ

-- ��� �̸��� S�� �����ϴ� ��� ��ȸ
-- % ���
SELECT *
FROM emp
WHERE ename LIKE 'S%';
-- ���� �̸��� S�� �����ϰ� �̸��� ��ü ���̰� 5������ ����
-- _ ���
SELECT *
FROM emp
WHERE ename LIKE 'S____';
--��� �̸��� S���ڰ� ���� ��� ��ȸ
SELECT *
FROM emp
WHERE ename LIKE '%S%';

-- member ���̺��� ȸ���� ���� [��]���� ����� mem_id, mem_name�� ��ȸ�ϴ� ������ �ۼ��Ͻÿ�
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '��%';

-- member ���̺��� ȸ���� �̸��� ���� [��]�� ���� ��� ������� mem_id, mem_name�� ��ȸ�ϴ� ������ �ۼ��Ͻÿ�
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '%��%';

-- null �� ����(IS)
-- comm �÷��� ���� null�� �����͸� ��ȸ (WHERE comm = null)
-- null�� ���� ���� IS�� �� ����� ��
SELECT *
FROM emp
where comm = null;

SELECT *
FROM emp
where comm = '';

SELECT *
FROM emp
where comm IS null;

-- emp ���̺��� ��(comm)�� �ִ� ȸ���� ������ ������ ���� ��ȸ�ǵ��� ������ �ۼ��Ͻÿ�
-- NOT null
SELECT *
FROM emp
where comm IS not null;

-- NOT IN
-- ����� �����ڰ� 7698, 7839 �׸��� NULL�� �ƴ� ������ ��ȸ
-- NOT IN �����ڿ����� NULL���� ��ȣ �ȿ� ���� ��ų �� ����.
SELECT *
FROM emp
WHERE mgr NOT IN(7698, 7839) AND mgr IS NOT NULL;




-- emp ���̺��� �μ���ȣ�� 10���� �ƴϰ� �Ի����ڰ� 1981�� 6�� 1�� ������ ������ ������
-- ������ ���� ��ȸ�ϼ��� (IN, NOT IN ������ ������)
SELECT *
FROM emp
WHERE deptno != 10 AND hiredate > TO_DATE('19810601', 'YYYYMMDD');

-- emp ���̺��� �μ���ȣ�� 10���� �ƴϰ� �Ի����ڰ� 1981�� 6�� 1�� ������ ������ ������
-- ������ ���� ��ȸ�ϼ��� (IN, NOT IN ������ ���)
SELECT *
FROM emp
WHERE deptno NOT IN( 10) AND hiredate > TO_DATE('19810601', 'YYYYMMDD');



-- emp ���̺��� �μ���ȣ�� 10���� �ƴϰ� �Ի����ڰ� 1981�� 6�� 1�� ������ ������
-- ������ ������ ���� ��ȸ �ϼ��� (�μ��� 10, 20, 30�� �ִٰ� ����, IN ������ ���)
SELECT *
FROM emp
WHERE deptno IN(20, 30) AND hiredate > TO_DATE('19810601', 'YYYYMMDD');


-- emp ���̺��� job�� SALEMAN�̰� �Ի����ڰ� 1981�� 6�� 1�� ������ ������ ������
-- ������ ���� ��ȸ �ϼ���
SELECT *
FROM emp
WHERE job = 'SALESMAN' AND hiredate >= TO_DATE('19810601', 'YYYYMMDD');

-- emp ���̺��� job�� SALEMAN�̰ų� �����ȣ�� 78�� �����ϴ� ������ ������
-- ������ ���� ��ȸ �ϼ���
SELECT *
FROM emp
WHERE job = 'SALESMAN' OR empno LIKE '78%';

-- emp ���̺��� job�� SALEMAN�̰ų� �����ȣ�� 78�� �����ϴ� ������ ������
-- ������ ���� ��ȸ �ϼ��� ( LIKE�����ڸ� ������� ������ )

SELECT *
FROM emp
WHERE job = 'SALESMAN' OR empno BETWEEN 7800 AND 7899;

--������ �켱����
-- 1. ���������
-- 2. ���ڿ�����
-- 3. �񱳿���
-- 4. IS, [NOT]NULL, LIKE
-- 5. 
-- 6.
-- 7. 
-- �켱���� ���� : ()
-- AND > OR !!!

-- emp ���̺��� ��� �̸��� SMITH �̰ų�, ��� �̸��� ALLEN �̸鼭 �������� SALESMAN�� ��� ��ȸ
SELECT *
FROM emp
WHERE ename = 'SMITH' 
OR (ename = 'ALLEN' AND job ='SALESMAN') ;

-- ��� �̸��� SMITH �̰ų� ALLEN�̸鼭 ��� ������ SALESMAN�� ��� ��ȸ
SELECT *
FROM emp
WHERE ename IN ('SMITH', 'ALLEN')
AND job LIKE 'S%' ;

-- emp ���̺��� job�� SALESMAN�̰ų� �����ȣ�� 78�� �����ϸ鼭 �Ի����ڰ� 1981�� 6�� 1�� ������ ������ ������ ��ȸ
SELECT *
FROM emp
WHERE job ='SALESMAN' 
OR (empno LIKE '78%' AND hiredate > TO_DATE('19810601','YYYYMMDD'));





-- < ������ ���� >
-- TABLE ��ü���� �����͸� ���� / ��ȸ�� ������ �������� ����
-- ���������� �����Ͱ� �Էµ� ������� ��ȸ��
-- �����Ͱ� �׻� ������ ������ ��ȸ�Ǵ� ���� �������� �ʴ´�
-- �����Ͱ� �����ǰ�, �ٸ� �����Ͱ� ��� �� ���� ����

-- < ORDER BY >
-- ASC : �������� (dafult)
-- DESC : ��������
-- ����
-- SELECT *
-- FROM TABLE
-- [WHERE]
-- ORDER BY {���� ���� �÷� | ALIAS(��Ī) | �÷���ȣ [ASC | DESC]}

-- emp ���̺��� ��� ����� ename �÷� ���� �������� �������� ������ ����� ��ȸ�ϼ���
SELECT *
FROM emp
ORDER BY ename;

-- emp ���̺��� ��� ����� ename �÷� ���� �������� �������� ������ ����� ��ȸ�ϼ���
SELECT *
FROM emp
ORDER BY ename DESC;

DESC emp; -- DESC : DESCRIBE (�����ϴ�)
ORDER BY ename DESC -- DESC : DESCENDING (����)

-- emp ���̺��� ��� ������ ename �÷����� ��ħ����, ename ���� ���� ��� mgr �÷����� �������� �����ϴ� ������ �ۼ��ϼ���
SELECT *
FROM emp
ORDER BY ename DESC, mgr;

-- ��Ī���� ����
SELECT empno, ename AS nm, sal*12 AS year_sal 
FROM emp
ORDER BY nm ;

-- �÷� �ε����� ����
-- java array���� INDEX ������ 0����
-- SQL INDEX�� 1���� ����
SELECT empno , ename AS nm, sal*12 AS year_sal 
FROM emp
ORDER BY  2;

-- dept ���̺��� ��� ������ �μ��̸����� �������� ���ķ� ��ȸ
SELECT *
FROM dept
ORDER BY dname;

-- dept ���̺��� ��� ������ �μ���ġ�� �������� ���ķ� ��ȸ
SELECT *
FROM dept
ORDER BY loc DESC;

-- emp ���̺��� ��(comm) ������ �ִ� ����鸸 ��ȸ�ϰ�, ��(comm)�� ���� �޴� ����� ���� ��ȸ�ǵ��� �ϰ�,
-- �󿩰� ���� ��� ������� �������� �����ϼ��� (�󿩰� 0�λ���� �󿩰� ���� ������ ����)
SELECT *
FROM emp
WHERE comm IS NOT NULL 
AND comm != 0 
ORDER BY comm DESC, empno;

SELECT *
FROM emp
WHERE comm > 0
ORDER BY comm DESC, empno;

-- emp ���̺��� �����ڰ� �ִ� ����鸸 ��ȸ�ϰ�, ����(job)������ �������� �����ϰ�, ������ ���� ��� ����� ū ����� ���� ��ȸ
SELECT *
FROM emp
WHERE mgr IS NOT NULL
ORDER BY job, empno DESC;
