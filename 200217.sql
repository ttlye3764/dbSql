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



기존 : 시작일짜 1일, 마지막 날짜 : 해당월의 마지막 일자;
SELECT TO_DATE('202002','YYYYMM') + (LEVEL-1)
FROM dual
CONNECT BY LEVEL <=29;
 
변경 : 시작일짜 : 해당월의 1윌자가 속한 주의 일요일
       마지막날짜 : 해당월의 마지막일짜가 속한 주의 토요일
       
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

-- SQL로 달력 만들기 복습해서 공부하자



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
 
 --- 과제 달력만들기 다음년도꺼도 출력되게 pt보자
 
 
 
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
            
1. dt(일자 ) ==> 월, 월단위별 SUM(SALES) ==> 월의 수만큼 행이 그룹핑된다.
SELECT DECODE(TO_CHAR(DT,'MM',SUM(sales) )),TO_CHAR(dt,'mm'), SUM(sales) sal
FROM sales
GROUP BY TO_CHAR(dt,'mm');

            

SELECT TO_CHAR(DT,'YYYY'), SUM(SALES)
FROM SALES
GROUP BY TO_CHAR(DT,'YYYY');


 
-- 계층쿼리

-- 


create table dept_h (
    deptcd varchar2(20) primary key ,
    deptnm varchar2(40) not null,
    p_deptcd varchar2(20),
    
    CONSTRAINT fk_dept_h_to_dept_h FOREIGN KEY
    (p_deptcd) REFERENCES  dept_h (deptcd) 
);

insert into dept_h values ('dept0', 'XX회사', '');
insert into dept_h values ('dept0_00', '디자인부', 'dept0');
insert into dept_h values ('dept0_01', '정보기획부', 'dept0');
insert into dept_h values ('dept0_02', '정보시스템부', 'dept0');
insert into dept_h values ('dept0_00_0', '디자인팀', 'dept0_00');
insert into dept_h values ('dept0_01_0', '기획팀', 'dept0_01');
insert into dept_h values ('dept0_02_0', '개발1팀', 'dept0_02');
insert into dept_h values ('dept0_02_1', '개발2팀', 'dept0_02');
insert into dept_h values ('dept0_00_0_0', '기획파트', 'dept0_01_0');
commit;

SELECT *
FROM dept_h;

오라클 계층형 쿼리 문법
SELECT ...
FROM ...
WHERE ...
START WITH 조건 : 어떤 행을 시작점으로 삼을지

CONNECT BY 행과 행을 연결하는 기준
    PRIOR : 이미 읽은 행
    "  " : 앞으로 읽을 행
    
하향식 : 상위에서 자식노드로 연결;

XX회사 (최상위 조직)에서 시작하여 하위 부서로 내려가는 계층 쿼리

SELECT dept_h.*, level, RPAD(LPAD(deptnm, 15, '*'),25,'*') DEPTNM, LPAD(' ',(LEVEL-1)*4,' ')|| deptnm
FROM dept_h
START WITH DEPTNM ='XX회사'
CONNECT BY PRIOR deptcd = p_deptcd;


P_DEPTCD = DEPTCD : (PRIOR xx회사 - " " 3가지부 (디자인부, 정보기획부, 정보시스템부))
PRIOR XX.회사 = 디자인부p.deptcd
PRIOR XX회사.Dept = 디자인팀.p_deptno

prior xx회사.deptcd  = 정보기획부.p.deptcd
prior 정보기획부.deptcd = 기획

SELECT SYSDATE, LEVEL
FROM dual
CONNECT BY LEVEL <11;

SELECT TO_DATE(:dt, 'YYYYMMDD') + LEVEL -1 dt,
        TO_CHAR(TO_DATE(:dt,'YYYYMMDD') + LEVEL-1, 'DAY') day,  -- 'TO_CHAR(해당일자,'D')' -> 01, 02 처럼 요일이 숫자로 표현됌
                                                                      -- 'TO_CHAR(해당일자,'DAY')' -> 한글로 월요일, 화요일 처럼 표현됌
        TO_CHAR(TO_DATE(:dt,'YYYYMMDD')+LEVEL-1,'W') W,  -- TO_CHAR(해당일자, 'W') -> 그 월의 주차 (한달중에 몇주차 인지) * 매월 1일을 주의 시작
        TO_CHAR(TO_DATE(:dt,'YYYYMMDD')+LEVEL-1,'WW') WW,   -- TO_CHAR(해당일자, 'W') -> 그 해의 주차 (일년중에 몇주차 인지) * 매년 1일을 주의 시작
        
        TO_CHAR(TO_DATE(:dt,'YYYYMMDD')+LEVEL-1,'IW') IW   -- TO_CHAR(해당일자, 'W') -> 그 해의 주차 (일년중에 몇주차 인지) * 월요일을 주의 시작
FROM dual                                                           
CONNECT BY LEVEL <= 20;

-- 특정 년월의 모든 일자 구하기
SELECT TO_DATE(:dt, 'YYYYMM')+ (LEVEL-1) dt
FROM dual
CONNECT BY LEVEL <= LAST_DAY(TO_DATE(:dt,'YYYYMM')) - TO_DATE(:dt, 'YYYYMM')+1;

-- 일자의 주차, 요일 구하기
SELECT dt,
        TO_CHAR(dt, 'iw') iw,
        TO_CHAR(dt, 'day') day,
        TO_CHAR(dt, 'd') d
FROM(
SELECT TO_DATE(:dt, 'YYYYMM')+ (LEVEL-1) dt
FROM dual
CONNECT BY LEVEL <= LAST_DAY(TO_DATE(:dt,'YYYYMM')) - TO_DATE(:dt, 'YYYYMM')+1);


-- 세로 데이터 가로로 변경
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




--과제
SELECT dept_h.*,level,lpad('  ',(level-1)*4, '  ')||deptnm
FROM dept_h
START WITH deptcd = 'dept0_02'
CONNECT BY PRIOR deptcd = p_deptcd;


-- 1월 ~ 말일자

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
 
 
-- 1일자가 속한 주의 일요일구하기
--마지막일자가 속한 주의 토요일구 하기
--일수 구하기; 
SELECT 
        TO_DATE(:dt, 'yyyymm') - ( TO_CHAR(TO_DATE(:dt, 'yyyymm'), 'D') -1) st,
        LAST_DAY(TO_DATE(:dt, 'yyyymm')) + (7- TO_CHAR(LAST_DAY(TO_DATE(:dt, 'yyyymm')), 'D')) ed,
        LAST_DAY(TO_DATE(:dt, 'yyyymm')) + (7- TO_CHAR(LAST_DAY(TO_DATE(:dt, 'yyyymm')), 'D'))
                      - ( TO_DATE(:dt, 'yyyymm') - ( TO_CHAR(TO_DATE(:dt, 'yyyymm'), 'D'))) daycnt
FROM dual;      

--1일자, 말일자가 속한 주차까지 표현한 달력
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


 