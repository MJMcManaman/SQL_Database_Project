create type name_t as object (
  firstn varchar2(10),
  lastn varchar2(10)
);

create type student_t as object (
  sid char(2),
  sname name_t,
  dofb date,
  map member function comps return integer,
  member function fullname return varchar2
);

alter type student_t not final;

create type ugstudent_t under student_t (major char(4));


create type gstudent_t under student_t (degree char(3), 
overriding member function fullname return varchar2);

create type faculty_t as object (fid char(4),ftitle varchar2(15));

create type course_t as object (
  cid char(6),
  ctitle varchar2(15), 
  pcode char(4), 
  foid ref faculty_t
);

create type transcript_t as object (
  rid char(3),
  soid ref student_t, 
  coid ref course_t, 
  lg char(2)
);

create table faculty of faculty_t(fid primary key);
create table course of course_t (cid primary key);
create table ugstudent of ugstudent_t (sid primary key);
create table gstudent of gstudent_t (sid primary key);
create table transcript of transcript_t (rid primary key);

--lab2insert1.sql
insert into ugstudent values (ugstudent_t('53',name_t('John','Smith'), 
'18-Jan-2002','ITEC'));

insert into ugstudent values 
(ugstudent_t('55',name_t('Kate','Spade'),'15-Mar-2003','ITEC'));

insert into ugstudent values 
(ugstudent_t('57',name_t('Nick','Wolf'),'10-Oct-2000','COSC'));

insert into gstudent values 
(gstudent_t('73',name_t('Mike','Kors'),'15-Jul-1997','MSc'));

insert into gstudent values 
(gstudent_t('75',name_t('Anna','Green'),'21-Aug-1995','PhD'));

insert into gstudent values 
(gstudent_t('77',name_t('Dave','Brown'),'31-Oct-1999','MA'));

insert into faculty values (faculty_t('LAPS','Arts'));

insert into faculty values (faculty_t('LE','Lassonde'));

insert into course values (course_t ('IT1010','Information','ITEC',
  (select ref(f) from faculty f where f.fid = 'LAPS')));

insert into course values (course_t('IT4010','SDLC2','ITEC',
  (select ref(f) from faculty f where f.fid = 'LAPS')));

insert into course values (course_t('IT6310','Research','ITEC',
  (select ref(f) from faculty f where f.fid = 'LAPS')));

insert into course values (course_t('CS3421','DBMS','EECS',
  (select ref(f) from faculty f where f.fid = 'LE')));

insert into course values (course_t('AD2511','MIS','ADMS',
  (select ref(f) from faculty f where f.fid = 'LAPS')));


--lab2insert2.sql
insert into transcript values (transcript_t('r01',
  (select ref(s) from ugstudent s where s.sid = '53'),
  (select ref(c) from course c where c.cid = 'IT1010'),'B'));

insert into transcript values (transcript_t('r02',
  (select ref(s) from ugstudent s where s.sid = '53'),
  (select ref(c) from course c where c.cid = 'AD2511'),'C+'));

insert into transcript values (transcript_t('r03',
  (select ref(s) from ugstudent s where s.sid = '55'),
  (select ref(c) from course c where c.cid = 'IT1010'),'B+'));

insert into transcript values (transcript_t('r04',
  (select ref(s) from ugstudent s where s.sid = '55'),
  (select ref(c) from course c where c.cid = 'CS3421'),'B'));

insert into transcript values (transcript_t('r05',
  (select ref(s) from ugstudent s where s.sid = '55'),
  (select ref(c) from course c where c.cid = 'IT4010'),'B+'));

insert into transcript values (transcript_t('r06',
  (select ref(s) from ugstudent s where s.sid = '57'),
  (select ref(c) from course c where c.cid = 'IT1010'), 'A'));

insert into transcript values (transcript_t('r07',
  (select ref(s) from gstudent s where s.sid = '73'),
  (select ref(c) from course c where c.cid = 'IT4010'),'A'));

insert into transcript values (transcript_t('r08',
  (select ref(s) from gstudent s where s.sid = '73'),
  (select ref(c) from course c where c.cid = 'IT6310'),'A+'));

insert into transcript values (transcript_t('r09',
  (select ref(s) from gstudent s where s.sid = '75'),
  (select ref(c) from course c where c.cid = 'CS3421'),'A'));

insert into transcript values (transcript_t('r10',
  (select ref(s) from gstudent s where s.sid = '75'),
  (select ref(c) from course c where c.cid = 'IT6310'),'A'));

insert into transcript values (transcript_t('r11',
  (select ref(s) from gstudent s where s.sid = '77'),
  (select ref(c) from course c where c.cid = 'IT4010'),'A+'));

create type body student_t as map member
function comps return integer
 is
 begin
 return sysdate - self.dofb;
 end;
 member function fullname return varchar2
 is
 begin
 return self.sname.firstn||''||self.sname.lastn;
 end;
 end;
 /

create type body gstudent_t as overriding
member function fullname return varchar2
 is
 begin
 return self.sname.lastn||''||self.sname.firstn;
 end;
 end;
 /

select t.soid.sid, t.soid.sname.lastn, t.coid.cid, t.lg 
from transcript t;


