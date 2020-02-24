--����� ��������(leaf ==> root node(���� node))
--
--��ü ��带 �湮�ϴ°� �ƴ϶� �ڽ��� �θ��常 �湮 (����İ� �ٸ���)
--
--������ : ��������
--
--���� : �����μ�

SELECT dept_h.*, LEVEL, LPAD(' ', (LEVEL-1)*4) || deptnm
FROM dept_h
START WITH deptnm = '��������'  
CONNECT BY PRIOR p_deptcd = deptcd;

create table h_sum as
select '0' s_id, null ps_id, null value from dual union all
select '01' s_id, '0' ps_id, null value from dual union all
select '012' s_id, '01' ps_id, null value from dual union all
select '0123' s_id, '012' ps_id, 10 value from dual union all
select '0124' s_id, '012' ps_id, 10 value from dual union all
select '015' s_id, '01' ps_id, null value from dual union all
select '0156' s_id, '015' ps_id, 20 value from dual union all

select '017' s_id, '01' ps_id, 50 value from dual union all
select '018' s_id, '01' ps_id, null value from dual union all
select '0189' s_id, '018' ps_id, 10 value from dual union all
select '11' s_id, '0' ps_id, 27 value from dual;

SELECT LPAD(' ',(LEVEL-1)*4)||s_id s_id, VALUE
FROM h_sum
START WITH s_id = '0'
CONNECT BY PRIOR s_id = ps_id;

SELECT *
FROM h_sum;

create table no_emp(
    org_cd varchar2(100),
    parent_org_cd varchar2(100),
    no_emp number
);
insert into no_emp values('XXȸ��', null, 1);
insert into no_emp values('�����ý��ۺ�', 'XXȸ��', 2);
insert into no_emp values('����1��', '�����ý��ۺ�', 5);
insert into no_emp values('����2��', '�����ý��ۺ�', 10);
insert into no_emp values('������ȹ��', 'XXȸ��', 3);
insert into no_emp values('��ȹ��', '������ȹ��', 7);
insert into no_emp values('��ȹ��Ʈ', '��ȹ��', 4);
insert into no_emp values('�����κ�', 'XXȸ��', 1);
insert into no_emp values('��������', '�����κ�', 7);

commit;

SELECT *
FROM no_emp;

SELECT LPAD(' ', (LEVEL-1)*4)||ORG_CD, NO_EMP
FROM no_emp
START WITH org_cd = 'XXȸ��'
CONNECT BY PRIOR ORG_CD = PARENT_ORG_CD;

-- ������ ������ �� ���� ���� ��� ��ġ�� ���� ��� �� (pruning branch - ����ġ��)


FROM => START WITH, CONNECT BY => WHERE

1. WHERE : ���� ������ �ϰ� ���� ���� ����
2. CONNECT BY : ���� ������ �ϴ� �������� ���� �����ϰ� ���� ����

-- WHERE �� ��� �� : �� 9���� ROW
SELECT LPAD
(' ', (LEVEL-1)*4)||ORG_CD, NO_EMP
FROM no_emp
START WITH org_cd = 'XXȸ��'
CONNECT BY PRIOR ORG_CD = PARENT_ORG_CD;

-- WHERE �� (deptnm != '������ȹ��') :
-- ��, �ٸ� ���̺���� ���� �������� �̿�Ǿ��� ��� ���ο� ����
SELECT LPAD(' ', (LEVEL-1)*4)||ORG_CD, NO_EMP
FROM no_emp
WHERE org_cd != '������ȹ��'
START WITH org_cd = 'XXȸ��'
CONNECT BY PRIOR ORG_CD = PARENT_ORG_CD;

--CONNECT BY ���� ������ ���
-- ������ȹ�� �ؿ� ���鵵 ��ȸ�� �ȉ�
SELECT LPAD(' ', (LEVEL-1)*4)||ORG_CD, NO_EMP
FROM no_emp
START WITH org_cd = 'XXȸ��'
CONNECT BY PRIOR ORG_CD = PARENT_ORG_CD AND org_cd != '������ȹ��';

--���� ���� Ư���Լ�
--1. CONNECT BY_ROOT(col) : �ֻ��� �������� �÷� ���� ��ȸ
--2. SYS_CONNECT_BY_PATH(col, '-') : ���� ��ȸ ��� ǥ��, * �ι��� ���� : �� �� ǥ�� ������
--3. CONNECT_BY_ISLEAF ISLEAF : ���� ���� ������ LEAF������� ����, * 1: ������� 0 : ������� �ƴ�

--CONNECT_BY_ROOT(�÷�) : �ش� �÷��� �ֻ��� ���� ���� ����
SELECT LPAD(' ', (LEVEL-1)*4)||ORG_CD, NO_EMP,
       CONNECT_BY_ROOT(org_cd) root
FROM no_emp
START WITH org_cd = 'XXȸ��'
CONNECT BY PRIOR ORG_CD = PARENT_ORG_CD AND org_cd != '������ȹ��';

--SYS_CONNECT_BY_PATH(�÷�, ������)  : �ش� ���� �÷��� ���Ŀ� �÷� ���� ����, �����ڷ� �̾��ش�.
SELECT LPAD(' ', (LEVEL-1)*4)||ORG_CD, NO_EMP,
       LTRIM(SYS_CONNECT_BY_PATH(org_cd,'-'),'-') PATH
FROM no_emp
START WITH org_cd = 'XXȸ��'
CONNECT BY PRIOR ORG_CD = PARENT_ORG_CD;

-- CONNECT_BY_ISLEAF : �ش� ���� LEAF �������(����� �ڽ��� ������) ���� ���� 1:LEAF ���, 0: NOT LEAF
SELECT LPAD(' ', (LEVEL-1)*4)||ORG_CD, NO_EMP,
       CONNECT_BY_ISLEAF LEAF
FROM no_emp
START WITH org_cd = 'XXȸ��'
CONNECT BY PRIOR ORG_CD = PARENT_ORG_CD;




CREATE table board_test (
 seq number,
 parent_seq number,
 title varchar2(100) );

insert into board_test values (1, null, 'ù��° ���Դϴ�');
insert into board_test values (2, null, '�ι�° ���Դϴ�');
insert into board_test values (3, 2, '����° ���� �ι�° ���� ����Դϴ�');
insert into board_test values (4, null, '�׹�° ���Դϴ�');
insert into board_test values (5, 4, '�ټ���° ���� �׹�° ���� ����Դϴ�');
insert into board_test values (6, 5, '������° ���� �ټ���° ���� ����Դϴ�');
insert into board_test values (7, 6, '�ϰ���° ���� ������° ���� ����Դϴ�');
insert into board_test values (8, 5, '������° ���� �ټ���° ���� ����Դϴ�');
insert into board_test values (9, 1, '��ȩ��° ���� ù��° ���� ����Դϴ�');
insert into board_test values (10, 4, '����° ���� �׹�° ���� ����Դϴ�');
insert into board_test values (11, 10, '���ѹ�° ���� ����° ���� ����Դϴ�');
commit;


SELECT *
FROM BOARD_TEST;

SELECT seq, LPAD(' ',(LEVEL-1)*4)||title TITLE,
        LTRIM(SYS_CONNECT_BY_PATH(TITLE,' - '),' - ') PATH,
        CONNECT_BY_ISLEAF LEAF,
        CONNECT_BY_ROOT(TITLE) ROOT
FROM board_test
START WITH parent_seq IS null
CONNECT BY PRIOR SEQ = parent_seq;


SELECT * 
FROM BOARD_TEST;

-- ORDER BY SIBLINGS BY �÷� DESC
SELECT seq, LPAD(' ',(LEVEL-1)*4)||title TITLE
FROM board_test
START WITH parent_seq IS null
CONNECT BY PRIOR SEQ = parent_seq
ORDER SIBLINGS BY SEQ DESC; --> �귻ġ ������ ������ �������� ��ȸ�ȴ�.

-- ����  ROOT���� DES, �귻ġ������ ASC �ض�
ALTER TABLE board_test ADD (gn NUMBER);

-- �׷��ȣ �÷� �߰�
UPDATE board_test SET gn = 4
WHERE seq IN(4,5,6,7,8,10,11);

UPDATE board_test SET gn = 2
WHERE seq IN(2,3);

UPDATE board_test SET gn = 1
WHERE seq IN(1,9);

commit;

SELECT seq, LPAD(' ',(LEVEL-1)*4)||title TITLE,
        LTRIM(SYS_CONNECT_BY_PATH(TITLE,' - '),' - ') PATH,
        CONNECT_BY_ISLEAF LEAF,
        CONNECT_BY_ROOT(TITLE) ROOT
FROM board_test
START WITH parent_seq IS null
CONNECT BY PRIOR SEQ = parent_seq
ORDER SIBLINGS BY gn DESC, SEQ ASC; 


--WINDOW�Լ� 
--�ణ ������ �������ִ� �Լ�
--�ش����� ������ �Ѿ� �ٸ� �ణ ������ ����
--   1. SQL�� ��������  
--   2. �������� Ư�� �÷� �� ��ȸ
--   3. Ư�� ������ ����� �÷� �� ��ȸ
--   4. Ư�� ������ ���� Ư�� Į���� �������� �� ����, ROW ��ȣ ��ȸ
--     EX) SUM, COUNT, RANK, LEAD ���

SELECT emp.ename, emp.deptno, c.LV
FROM 
(SELECT *
FROM (
        SELECT LEVEL LV
        FROM dual
        CONNECT BY LEVEL <=14) A,
        
        (SELECT deptno, COUNT(*) cnt
        FROM emp
        GROUP BY deptno) B
WHERE b.cnt >= a.LV
ORDER BY B.deptno, a.lv) C, emp
WHERE C.deptno = emp.deptno
ORDER BY C.DEPTNO, C.LV;

SELECT 

FROM EMP




   