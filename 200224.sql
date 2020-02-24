--SQL�� ó������
--
--���� ���μ����� ���� PGA�� ���� ����
--
--�����м� ���� ��ȹ -> ���ε� -> ���� -> ����(FETCH)
--
--�����м� ���� ��ȹ : ���� Ǯ���� ������ ���� ��ȹ�� �ִ��� �˻�(Ŀ�� ����) * ���� ��ȹ�� ����� �۾��� ����� ���� ������ ���� �� �� ������ �Ϸ���
--                   SQL Syntax �˻� (���������� ������ ������)
--                   Semantic �˻�
--                   Data Dictionary
--                   ���� ��ü �˻�
--                   ��Ű��, ��, ����
--                   ���� ��ȹ �ۼ�
--                   
--���ε� : ���ε� ���� ���� �ִ� ��� �Ҵ�
--
--���� : ���� ��ȹ ����
--      ���࿡ �ʿ��� �۾� ���� - DB I/O �۾�
--                           - ����, ����
--
--���� : ���� ��� ����� �˻��Ͽ� ��ȯ
--      �˻��Ͽ� ��ȯ
--      �迭ó��
--      ����
--
--���� : ���� ��ȹ ����
--
--�� SQL����
--
--1. �̹� ������ ���� ��ȹ�� �����ؼ� ����
--   - 
--
--������ SQL �����̶�?
-- -> �ؽ�Ʈ�� �Ϻ��ϰ� ������ SQL
--   1. ��ҹ��� ����
--   2. ���鵵 �����ؾ���
--   3. ��ȸ ����� ���ٰ� ������ SQL���� �ƴ�
--   4. �ּ��� ������ ��ħ
--
--�׷��� ������ ������ SQL ������� ������ ������ �ƴ�
--select * FROM dept;
--SELECT * FROM dept;
--select   * FROM dept;
--select *
--FROM dept;

--SQL ����� v$SQL �信 �����Ͱ� ��ȸ�Ǵ��� Ȯ��;
SELECT /* sql_test*/ *
FROM dept
WHERE deptno = 10;

--�� �ΰ��� SQL�� �˻��ϰ��� �ϴ� �μ���ȣ�� �ٸ���
--������ �ؽ�Ʈ�� �����ϴ�. ������ �μ���ȣ�� �ٸ��� ������ DBMS ���忡���� ���� �ٸ� SQL�� �ν�
-- => �ٸ� SQL ���� ��ȹ�� �����
-- => ���� ��ȹ�� �������� ���Ѵ�
-- ==> �ذ�å : ���ε� ���� ���
-- 
-- SQL���� ����Ǵ� �κ��� ������ ������ �ϰ�
-- �����ȹ ������ ���Ŀ� ���ε� �۾��� ���� ���� ����ڰ� ���ϴ� ���� ������ ġȯ �� ����
--  ==> �����ȹ ���� ���� ==> �޸� �ڿ� ���� ����;
--  
SELECT /* sql_test*/ *
FROM dept
WHERE deptno = :deptno;

--�� Ŀ�� (Cursor)
-- - SQL���� �����ϱ� ���� �޸� ����
-- - ������ ����� SQL���� ������ Ŀ���� ���
--
-- - ������(�Ͻ���) Ŀ��
--    -> ����Ŭ���� �ڵ����� �������ִ� SQL Ŀ��
--    -> ?
--    
-- - ����� Ŀ��
--    -> ����ڰ� �����ϴ� SQL Ŀ��
--    -> ������ �����ϱ� ���� Ŀ��
--    
--����� Ŀ�� �������    
--    
--SELECT ��� �������� TABLE Ÿ���� ������ ������ �� ������ �޸𸮴� �������̱� ������ ���� ���� �����͸� ��⿡�� ������ ����
--
--SQL Ŀ���� ���� �����ڰ� ���� �����͸� FETCH �����ν� SELECT ����� ���� �ҷ����� �ʰ� ������ ����;
--
--����� Ŀ�� ����(���� ���� �˻��ϴ� SELECT)
-- CURSOR cursor_name IS
--   SUBQUERY;
--   
--�� Ŀ�� ���� ���
--
--�����(DECLARE)���� ����
--    CURSOR Ŀ���̸� IS
--        ������ ����;
--
--�����(BEGIN)���� Ŀ�� ����
--    OPEN Ŀ���̸�;
--    
--�����(BEGIN)���� Ŀ���� ���� ������ FETCH
--    FETCH Ŀ���̸� INTO ����;
--    
--�����(BEGIN)���� Ŀ�� �ݱ�
--    CLOSE Ŀ���̸�;
--
--�μ� ���̺��� Ȱ���Ͽ� ��� �࿡ ���� �μ���ȣ�� �μ� �̸��� CURSOR�� ���� FETCH, FETCH�� ����� Ȯ��;

SET SERVEROUTPUT ON;

DECLARE 
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
    CURSOR dept_cursor IS
        SELECT deptno, dname
        FROM dept;
BEGIN
    OPEN dept_cursor;
    
    LOOP
        FETCH dept_cursor INTO v_deptno, v_dname;
        EXIT WHEN dept_cursor%NOTFOUND;   
        DBMS_OUTPUT.PUT_LINE(v_deptno || ' : ' || v_dname);
    END LOOP;
END;    
/

--CURSOR�� ���� �ݴ� ������ �ټ� �����彺����
--CURSOR�� �Ϲ������� LOOP�� �Բ� ����ϴ� ��찡 ����
-- ==> ����� Ŀ���� FOR LOOP���� ����� �� �ְ� �� �������� ����

--JAVA
--LIST<String> UserNameList = new ArrayList<String>();
--userNameList.add("brown");
--userNameList.add("cony");
--userNameList.add("sally");
--
--�Ϲ� for 
--for(int i = 0 ; i < userNameList.size(); i++){
--    userNameList.get(i);
--}
--
--���� for
--for(String UserName : userNameList){
--    UserName ���� ���..;
--}

--JAVA ���� FOR�� ���¿� ����
--
--FOR record_name(�� ���� ������ ���� �����̸� / ������ ���� �������) IN Ŀ���̸� LOOP
--    record_name.�÷���
--END LOOP;

DECLARE
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
    
    CURSOR dept_cursor IS
        SELECT deptno, dname
        FROM dept;
BEGIN
    FOR rec IN dept_cursor LOOP
        DBMS_OUTPUT.PUT_LINE(rec.deptno || ' : ' || rec.dname);
    END LOOP;
END;
/

--���ڰ� �ִ� Ŀ��;
--���� Ŀ�� ���� ���
--    CURSOR Ŀ���̸� IS
--        ��������..;
--        
--���ڰ� �ִ� Ŀ�� ������
--    CURSOR Ŀ���̸�(����1 ����1 Ÿ��, ����2 ����2 Ÿ��, ...) IS
--        ��������;
--            (Ŀ�� ����ÿ� �ۼ��� ���ڸ� ������������ ����� �� �ִ�.)

DECLARE
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
    
    CURSOR dept_cursor(p_deptno dept.deptno%TYPE) IS
        SELECT deptno, dname
        FROM dept
        WHERE deptno <= p_deptno;
BEGIN
    FOR rec IN dept_cursor(:deptno) LOOP
        DBMS_OUTPUT.PUT_LINE(rec.deptno || ' : ' || rec.dname);
    END LOOP;
END;
/


select *
from dept;


--Ŀ�� �Ӽ�
--1. SQL%ROWCOUNT
--2. SQL%FOUND
--3. SQL%NOTFOUND
--4. 
--
--FOR LOOP ���� Ŀ���� �ζ��� ���·� �ۼ�
--FOR ���ڵ� �̸� IN Ŀ���̸�
--==>
--FOR ���ڵ� �̸� IN (��������);
--
--�ǽ�;

DECLARE
BEGIN
    FOR rec IN (SELECT deptno, dname FROM dept) LOOP
        DBMS_OUTPUT.PUT_LINE(rec.deptno || ' : ' || rec.dname);
    END LOOP;
END;
/

SELECT *
FROM dept;

 CREATE TABLE DT
(	DT DATE);

insert into dt
select trunc(sysdate + 10) from dual union all
select trunc(sysdate + 5) from dual union all
select trunc(sysdate) from dual union all
select trunc(sysdate - 5) from dual union all
select trunc(sysdate - 10) from dual union all
select trunc(sysdate - 15) from dual union all
select trunc(sysdate - 20) from dual union all
select trunc(sysdate - 25) from dual;

commit;
SELECT *
FROM dt;






DECLARE 
    TYPE dt_tab IS TABLE OF dt%ROWTYPE INDEX BY BINARY_INTEGER;
    v_dt_tab dt_tab;
    v_sum number(5) := 0;
    v_avg number(5) := 0;
BEGIN
    SELECT * BULK COLLECT INTO v_dt_tab
    FROM dt;

    FOR i IN 1..(v_dt_tab.count-1) LOOP
        v_sum := v_sum + TO_NUMBER(TO_CHAR(v_dt_tab(i).dt - v_dt_tab(i+1).dt));
        DBMS_OUTPUT.PUT_LINE(v_sum);
    END LOOP;
    v_avg := v_sum/(v_dt_tab.count-1);
    DBMS_OUTPUT.PUT_LINE(v_avg || ' , '|| v_sum);
END;
/
    
-- cursor�ε� �غ��ô�~ ����

--�м��Լ�
SELECT avg(gap)
from
(
SELECT DT, lead_dt, dt-lead_dt GAP
FROM
(
SELECT dt, 
        LEAD(DT) OVER(ORDER BY DT DESC) lead_dt
FROM dt));

SELECT (MAX(dt) - MIN(dt)) / (COUNT(dt)-1) avg
FROM dt;
    
    
    
    