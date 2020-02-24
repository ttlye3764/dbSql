SELECT DECODE(d,1,iw+1,iw) i,
        MIN(DECODE(D,1,dt,DECODE(D-6,1,dt-6))) sun,
        MIN(DECODE(D,2,dt,DECODE(D-6,1,dt-5))) mon,
        MIN(DECODE(D,3,dt,DECODE(D-6,1,dt-4))) tue,
        MIN(DECODE(D,4,dt,DECODE(D-6,1,dt-3))) wed,
        MIN(DECODE(D,5,dt,DECODE(D-6,1,dt-2))) tur,
        MIN(DECODE(D,6,dt,DECODE(D-6,1,dt-1))) fri,
        MIN(DECODE(D,7,dt,DECODE(D-6,1,dt))) sat
FROM(
SELECT TO_DATE(:dt, 'yyyymm') + (LEVEL-1) DT,
        TO_CHAR(TO_DATE(:dt, 'yyyymm') + (LEVEL-1), 'D') d,
        TO_CHAR(TO_DATE(:dt, 'yyyymm') + (LEVEL-1), 'iw') iw
FROM dual
CONNECT BY LEVEL-2 <= TO_CHAR(LAST_DAY(TO_DATE(:dt, 'yyyymm')), 'DD'))
GROUP BY DECODE(d,1,iw+1,iw)
ORDER BY DECODE(d,1,iw+1,iw);



���� : ������¥ 1��, ������ ��¥ : �ش���� ������ ����;
SELECT TO_DATE('202002','YYYYMM') + (LEVEL-1)
FROM dual
CONNECT BY LEVEL <=29;
 
���� : ������¥ : �ش���� 1���ڰ� ���� ���� �Ͽ���
       ��������¥ : �ش���� ��������¥�� ���� ���� �����
       
SELECT TO_DATE(:dt,'YYYYMM') - (TO_CHAR(TO_DATE(:dt,'YYYYMM'),'D')-1) st,
        LAST_DAY(TO_DATE(:dt,'YYYYMM')) + (7-TO_CHAR(LAST_DAY(TO_DATE(:dt, 'YYYYMM')),'D')) ed,
        LAST_DAY(TO_DATE(:dt,'YYYYMM')) + (7-TO_CHAR(LAST_DAY(TO_DATE(:dt, 'YYYYMM')),'D')) -
            (TO_DATE(:dt,'YYYYMM') - (TO_CHAR(TO_DATE(:dt,'YYYYMM'),'D'))) daycnt
FROM dual;
       
       
       
       
       
SELECT TO_DATE('20200126','YYYYMMDD') + (LEVEL-1)
FROM dual
CONNECT BY LEVEL <=35;



SELECT DECODE(d,1,iw+1,iw) i,
        MIN(DECODE(D,1,dt)) sun,
        MIN(DECODE(D,2,dt)) mon,
        MIN(DECODE(D,3,dt)) tue,
        MIN(DECODE(D,4,dt)) wed,
        MIN(DECODE(D,5,dt)) tur,
        MIN(DECODE(D,6,dt)) fri,
        MIN(DECODE(D,7,dt)) sat
FROM(
SELECT TO_DATE(:dt, 'yyyymm') + (LEVEL-1) DT,
        TO_CHAR(TO_DATE(:dt, 'yyyymm') + (LEVEL-1), 'D') d,
        TO_CHAR(TO_DATE(:dt, 'yyyymm') + (LEVEL-1), 'iw') iw
FROM dual
CONNECT BY LEVEL-2 <= TO_CHAR(LAST_DAY(TO_DATE(:dt, 'yyyymm')), 'DD'))
GROUP BY DECODE(d,1,iw+1,iw)
ORDER BY DECODE(d,1,iw+1,iw);





SELECT dt,d,iw,
        (DECODE(D,1,dt)) sun,
        (DECODE(D,2,dt)) mon,
        (DECODE(D,3,dt)) tue,
        (DECODE(D,4,dt)) wed,
        (DECODE(D,5,dt)) tur,
        (DECODE(D,6,dt)) fri,
        (DECODE(D,7,dt)) sat
FROM(
SELECT TO_DATE(:dt, 'yyyymm') + (LEVEL-1) DT,
        TO_CHAR(TO_DATE(:dt, 'yyyymm') + (LEVEL-1), 'D') d,
        TO_CHAR(TO_DATE(:dt, 'yyyymm') + (LEVEL-1), 'iw') iw
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:dt, 'yyyymm')), 'DD'));

-- SQL�� �޷� ����� �����ؼ� ��������



SELECT DECODE(d, 1, iw+1, iw) i,
       MIN(DECODE(d, 1, dt)) sun,
       MIN(DECODE(d, 2, dt)) mon,
       MIN(DECODE(d, 3, dt)) tue,
       MIN(DECODE(d, 4, dt)) wed,
       MIN(DECODE(d, 5, dt)) tur,
       MIN(DECODE(d, 6, dt)) fri,
       MIN(DECODE(d, 7, dt)) sat
FROM 
(SELECT TO_DATE(:dt, 'yyyymm') - ( TO_CHAR(TO_DATE(:dt, 'yyyymm'), 'D') -1) + (level-1) dt,
        TO_CHAR(TO_DATE(:dt, 'yyyymm') - ( TO_CHAR(TO_DATE(:dt, 'yyyymm'), 'D') -1)  + (LEVEL-1), 'D') d,
        TO_CHAR(TO_DATE(:dt, 'yyyymm') - ( TO_CHAR(TO_DATE(:dt, 'yyyymm'), 'D') -1)  + (LEVEL-1), 'iw') iw
 FROM dual
 CONNECT BY LEVEL <=  last_day(to_date(:dt,'yyyymm'))+(7-to_char(last_day(to_date(:dt,'yyyymm')),'D'))
                    -to_date(:dt,'yyyymm')-(to_char(to_date(:dt,'yyyymm'),'D')-1)  )
 GROUP BY DECODE(d, 1, iw+1, iw)
 ORDER BY DECODE(d, 1, iw+1, iw);
 
 --- ���� �޷¸���� �����⵵���� ��µǰ� pt����
 
 
 
 create table sales as 
select to_date('2019-01-03', 'yyyy-MM-dd') dt, 500 sales from dual union all
select to_date('2019-01-15', 'yyyy-MM-dd') dt, 700 sales from dual union all
select to_date('2019-02-17', 'yyyy-MM-dd') dt, 300 sales from dual union all
select to_date('2019-02-28', 'yyyy-MM-dd') dt, 1000 sales from dual union all
select to_date('2019-04-05', 'yyyy-MM-dd') dt, 300 sales from dual union all
select to_date('2019-04-20', 'yyyy-MM-dd') dt, 900 sales from dual union all
select to_date('2019-05-11', 'yyyy-MM-dd') dt, 150 sales from dual union all
select to_date('2019-05-30', 'yyyy-MM-dd') dt, 100 sales from dual union all
select to_date('2019-06-22', 'yyyy-MM-dd') dt, 1400 sales from dual union all
select to_date('2019-06-27', 'yyyy-MM-dd') dt, 1300 sales from dual;

SELECT *
FROM sales;



SELECT SUM(JAN), SUM(FEB), SUM(MAR), SUM(APR), SUM(MAY), SUM(JUN)
FROM(
SELECT DECODE(TO_CHAR(dt,'MM'),'01',sum(sales),0) JAN,
        DECODE(TO_CHAR(dt,'MM'),'02',sum(sales),0) FEB,
        DECODE(TO_CHAR(dt,'MM'),'03',sum(sales),0) MAR,
        DECODE(TO_CHAR(dt,'MM'),'04',sum(sales),0) APR,
        DECODE(TO_CHAR(dt,'MM'),'05',sum(sales),0) MAY,
        DECODE(TO_CHAR(dt,'MM'),'06',sum(sales),0) JUN
FROM sales
GROUP BY TO_CHAR(DT,'MM'));




SELECT DECODE(dtdt,01,sum(sales)) JAN,
        DECODE(dtdt,02,sal) JAN,
        DECODE(dtdt,03,sal) JAN,
        DECODE(dtdt,04,sal) JAN,
        DECODE(dtdt,05,sal) JAN,
        DECODE(dtdt,06,sal) JAN
FROM
        (
            SELECT TO_CHAR(DT,'MM') dtdt, SUM(sales) sal
            FROM sales
            GROUP BY TO_CHAR(DT,'MM'));
            
1. dt(���� ) ==> ��, �������� SUM(SALES) ==> ���� ����ŭ ���� �׷��εȴ�.
SELECT DECODE(TO_CHAR(DT,'MM',SUM(sales) )),TO_CHAR(dt,'mm'), SUM(sales) sal
FROM sales
GROUP BY TO_CHAR(dt,'mm');

            

SELECT TO_CHAR(DT,'YYYY'), SUM(SALES)
FROM SALES
GROUP BY TO_CHAR(DT,'YYYY');


 
-- ��������

-- 


create table dept_h (
    deptcd varchar2(20) primary key ,
    deptnm varchar2(40) not null,
    p_deptcd varchar2(20),
    
    CONSTRAINT fk_dept_h_to_dept_h FOREIGN KEY
    (p_deptcd) REFERENCES  dept_h (deptcd) 
);

insert into dept_h values ('dept0', 'XXȸ��', '');
insert into dept_h values ('dept0_00', '�����κ�', 'dept0');
insert into dept_h values ('dept0_01', '������ȹ��', 'dept0');
insert into dept_h values ('dept0_02', '�����ý��ۺ�', 'dept0');
insert into dept_h values ('dept0_00_0', '��������', 'dept0_00');
insert into dept_h values ('dept0_01_0', '��ȹ��', 'dept0_01');
insert into dept_h values ('dept0_02_0', '����1��', 'dept0_02');
insert into dept_h values ('dept0_02_1', '����2��', 'dept0_02');
insert into dept_h values ('dept0_00_0_0', '��ȹ��Ʈ', 'dept0_01_0');
commit;

SELECT *
FROM dept_h;

����Ŭ ������ ���� ����
SELECT ...
FROM ...
WHERE ...
START WITH ���� : � ���� ���������� ������

CONNECT BY ��� ���� �����ϴ� ����
    PRIOR : �̹� ���� ��
    "  " : ������ ���� ��
    
����� : �������� �ڽĳ��� ����;

XXȸ�� (�ֻ��� ����)���� �����Ͽ� ���� �μ��� �������� ���� ����

SELECT dept_h.*, level, RPAD(LPAD(deptnm, 15, '*'),25,'*') DEPTNM, LPAD(' ',(LEVEL-1)*4,' ')|| deptnm
FROM dept_h
START WITH DEPTNM ='XXȸ��'
CONNECT BY PRIOR deptcd = p_deptcd;


P_DEPTCD = DEPTCD : (PRIOR xxȸ�� - " " 3������ (�����κ�, ������ȹ��, �����ý��ۺ�))
PRIOR XX.ȸ�� = �����κ�p.deptcd
PRIOR XXȸ��.Dept = ��������.p_deptno

prior xxȸ��.deptcd  = ������ȹ��.p.deptcd
prior ������ȹ��.deptcd = ��ȹ

SELECT SYSDATE, LEVEL
FROM dual
CONNECT BY LEVEL <11;

SELECT TO_DATE(:dt, 'YYYYMMDD') + LEVEL -1 dt,
        TO_CHAR(TO_DATE(:dt,'YYYYMMDD') + LEVEL-1, 'DAY') day,  -- 'TO_CHAR(�ش�����,'D')' -> 01, 02 ó�� ������ ���ڷ� ǥ����
                                                                      -- 'TO_CHAR(�ش�����,'DAY')' -> �ѱ۷� ������, ȭ���� ó�� ǥ����
        TO_CHAR(TO_DATE(:dt,'YYYYMMDD')+LEVEL-1,'W') W,  -- TO_CHAR(�ش�����, 'W') -> �� ���� ���� (�Ѵ��߿� ������ ����) * �ſ� 1���� ���� ����
        TO_CHAR(TO_DATE(:dt,'YYYYMMDD')+LEVEL-1,'WW') WW,   -- TO_CHAR(�ش�����, 'W') -> �� ���� ���� (�ϳ��߿� ������ ����) * �ų� 1���� ���� ����
        
        TO_CHAR(TO_DATE(:dt,'YYYYMMDD')+LEVEL-1,'IW') IW   -- TO_CHAR(�ش�����, 'W') -> �� ���� ���� (�ϳ��߿� ������ ����) * �������� ���� ����
FROM dual                                                           
CONNECT BY LEVEL <= 20;

-- Ư�� ����� ��� ���� ���ϱ�
SELECT TO_DATE(:dt, 'YYYYMM')+ (LEVEL-1) dt
FROM dual
CONNECT BY LEVEL <= LAST_DAY(TO_DATE(:dt,'YYYYMM')) - TO_DATE(:dt, 'YYYYMM')+1;

-- ������ ����, ���� ���ϱ�
SELECT dt,
        TO_CHAR(dt, 'iw') iw,
        TO_CHAR(dt, 'day') day,
        TO_CHAR(dt, 'd') d
FROM(
SELECT TO_DATE(:dt, 'YYYYMM')+ (LEVEL-1) dt
FROM dual
CONNECT BY LEVEL <= LAST_DAY(TO_DATE(:dt,'YYYYMM')) - TO_DATE(:dt, 'YYYYMM')+1);


-- ���� ������ ���η� ����
SELECT iw,
        MIN(DECODE(d,2,dt)) mon,
        MIN(DECODE(d,3,dt)) wed,
        MIN(DECODE(d,4,dt)) thu,
        MIN(DECODE(d,6,dt)) fri,
        MIN(DECODE(d,7,dt)) sat,
        MIN(DECODE(d,1,dt)) sun
FROM(
    SELECT dt,
        TO_CHAR(dt, 'iw') iw,
        TO_CHAR(dt, 'day') day,
        TO_CHAR(dt, 'd') d
    FROM(
    SELECT TO_DATE(:dt, 'YYYYMM')+ (LEVEL-1) dt
    FROM dual
    CONNECT BY LEVEL <= LAST_DAY(TO_DATE(:dt,'YYYYMM')) - TO_DATE(:dt, 'YYYYMM')+1))
GROUP BY iw
ORDER BY IW;




--����
SELECT dept_h.*,level,lpad('  ',(level-1)*4, '  ')||deptnm
FROM dept_h
START WITH deptcd = 'dept0_02'
CONNECT BY PRIOR deptcd = p_deptcd;


-- 1�� ~ ������

SELECT DECODE(d, 1, iw+1, iw) i,
       MIN(DECODE(d, 1, dt)) sun,
       MIN(DECODE(d, 2, dt)) mon,
       MIN(DECODE(d, 3, dt)) tue,
       MIN(DECODE(d, 4, dt)) wed,
       MIN(DECODE(d, 5, dt)) tur,
       MIN(DECODE(d, 6, dt)) fri,
       MIN(DECODE(d, 7, dt)) sat
FROM 
(SELECT TO_DATE(:dt, 'yyyymm') + (level-1) dt,
        TO_CHAR(TO_DATE(:dt, 'yyyymm')  + (LEVEL-1), 'D') d,
        TO_CHAR(TO_DATE(:dt, 'yyyymm')  + (LEVEL-1), 'iw') iw
 FROM dual
 CONNECT BY LEVEL <=  TO_CHAR(last_day(to_date(:dt,'yyyymm')), 'DD'))
 GROUP BY DECODE(d, 1, iw+1, iw)
 ORDER BY DECODE(d, 1, iw+1, iw);
 
 
-- 1���ڰ� ���� ���� �Ͽ��ϱ��ϱ�
--���������ڰ� ���� ���� ����ϱ� �ϱ�
--�ϼ� ���ϱ�; 
SELECT 
        TO_DATE(:dt, 'yyyymm') - ( TO_CHAR(TO_DATE(:dt, 'yyyymm'), 'D') -1) st,
        LAST_DAY(TO_DATE(:dt, 'yyyymm')) + (7- TO_CHAR(LAST_DAY(TO_DATE(:dt, 'yyyymm')), 'D')) ed,
        LAST_DAY(TO_DATE(:dt, 'yyyymm')) + (7- TO_CHAR(LAST_DAY(TO_DATE(:dt, 'yyyymm')), 'D'))
                      - ( TO_DATE(:dt, 'yyyymm') - ( TO_CHAR(TO_DATE(:dt, 'yyyymm'), 'D'))) daycnt
FROM dual;      

--1����, �����ڰ� ���� �������� ǥ���� �޷�
SELECT DECODE(d, 1, iw+1, iw) i,
       MIN(DECODE(d, 1, dt)) sun,
       MIN(DECODE(d, 2, dt)) mon,
       MIN(DECODE(d, 3, dt)) tue,
       MIN(DECODE(d, 4, dt)) wed,
       MIN(DECODE(d, 5, dt)) tur,
       MIN(DECODE(d, 6, dt)) fri,
       MIN(DECODE(d, 7, dt)) sat
FROM 
(SELECT TO_DATE(:dt, 'yyyymm') - ( TO_CHAR(TO_DATE(:dt, 'yyyymm'), 'D') -1) + (level-1) dt,
        TO_CHAR(TO_DATE(:dt, 'yyyymm') - ( TO_CHAR(TO_DATE(:dt, 'yyyymm'), 'D') -1)  + (LEVEL-1), 'D') d,
        TO_CHAR(TO_DATE(:dt, 'yyyymm') - ( TO_CHAR(TO_DATE(:dt, 'yyyymm'), 'D') -1)  + (LEVEL-1), 'iw') iw
 FROM dual
 CONNECT BY LEVEL <=  last_day(to_date(:dt,'yyyymm'))+(7-to_char(last_day(to_date(:dt,'yyyymm')),'D'))
                    -to_date(:dt,'yyyymm')-(to_char(to_date(:dt,'yyyymm'),'D')-1)  )
 GROUP BY DECODE(d, 1, iw+1, iw)
 ORDER BY DECODE(d, 1, iw+1, iw);


 