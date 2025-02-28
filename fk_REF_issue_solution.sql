--solution fit current schema
insert into property values(property_t('d01', 
(select ref(r) from region r where r.rid = 'r001'), 
listing_t('d012', '5-Jan-2025', 2005, 1449000, 4, 2, 7, 1, 2, 1, 0, '10-Feb-2025'), 
'detached', 2010, '1 york lane', 'M1K2G3', 40, 104));

insert into property values(property_t('d02', 
(SELECT REF(r) FROM region r WHERE r.rid = 'r001'), 
listing_t('l012', DATE '2024-10-10', 2010, 2695000.00, 4, 2, 7, 0, 2, 1, 0, DATE '2025-10-02'), 
'detached', 2010, '1 york lane', 'M1K2G3', 40.2, 104.1));

--sample solution with int freign key
Create type region_t as object(
  rid int(10),
  regionName varchar(20),
  province varchar2(20),
  city varchar2(10),
  Member function regionDisplay return varchar2)
/
    
Create type property_t as object(
  pid int(3),
  roid int(10),
  propertyType varchar2(15),
  builtYear int,
  address varchar2(30),
  postalCode varchar2(6),
  propertyWidth double precision,
  propertyLength double precision,
  member function age return int,
  member function propertySize return double precision)
/

Create table region of region_t(rid primary key);
Create table property of property_t(
  pid primary key,
  FOREIGN KEY (roid) REFERENCES region(rid)
  on delete cascade
);

insert into region values(region_t(1001, 'Central', 'Ontario', 'Toronto'));
insert into property values(property_t(1, 1001,'detached', 2010, '1 york lane', 'M1K2G3', 40, 104));

select p.pid, r.city
from property p
join region r on p.roid = r.rid;

--sample solution with curernt 
Create type region_t as object(
  rid char(10),
  regionName varchar(20),
  province varchar2(20),
  city varchar2(10),
  Member function regionDisplay return varchar2)
/
    
Create type property_t as object(
  pid char(3),
  roid ref region_t,
  propertyType varchar2(15),
  builtYear int,
  address varchar2(30),
  postalCode varchar2(6),
  propertyWidth double precision,
  propertyLength double precision,
  member function age return int,
  member function propertySize return double precision)
/

Create table region of region_t(rid primary key);
Create table property of property_t(
  pid primary key,
  FOREIGN KEY (roid) REFERENCES region 
);

insert into region values(region_t('1001', 'Central', 'Ontario', 'Toronto'));
insert into property values(property_t('1', 
(SELECT REF(r) FROM region r WHERE r.rid = '1001'), 
'detached', 2010, '1 york lane', 'M1K2G3', 40, 104));

select p.pid, r.city 
from property p
join region r on deref(p.roid).rid = r.rid;