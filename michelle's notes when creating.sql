drop table rentContract;
drop table saleContract;
drop table tenant;
drop table landlord;
drop table seller;
drop table buyer;
drop table property;
drop table listing;
drop table region;
drop table agentContract;
drop table customer;
drop table agent;

Create type customer_t as object(
  cid char(4),
  cname varchar2(20),
  phoneNum char(10),
  emailAddress varchar2(20),
  dataStarted Date,
  map member function timeSpentLooking return int,
  member function timeOwned return int,
  MEMBER FUNCTION priceFluctuation RETURN DOUBLE PRECISION) NOT FINAL;
/

Create type buyer_t under customer_t(
  pricePreference double precision,
  priceFluctuation double precision,
  overriding map member function timeSpentLooking return int,
  member function sort (propertyRequirement double precision) return integer);
/

Create type seller_t under customer_t(
  propertyRegister int,
  dataOwned Date,
  Overriding member function timeOwned return int)
/

Create type tenant_t under customer_t(
  pricePreference double precision,
  priceFluctuation double precision,
  overriding map member function timeSpentLooking return int,
  member function sort (propertyRequirement double precision) return integer);
/

Create type landlord_t under customer_t(
  propertyRegister int,
  dateOwned Date,
  Overriding member function timeOwned return int)
/

Create type region_t as object(
  rid varchar2(10),
  regionName varchar(20),
  province varchar2(20),
  city varchar2(10),
  Member function regionDisplay return varchar2)
/

Create type listing_t as object(
  lid char(4),
  listingStartDate date,
  listedPrice double precision,
  washroomNum int,
  livingroomNum int,
  bedroomNum int,
  balcony int,
  kitchenNum int,
  parkingSpace int,
  elevator int,
  openHouse date,
  map member function daysListed return int)
/

Create type property_t as object(
  pid char(3),
  roid ref region_t,
  propertyDetail listing_t,
  propertyType varchar2(15),
  builtYear int,
  address varchar2(30),
  postalCode varchar2(6),
  propertyWidth double precision,
  propertyLength double precision,
  map member function age return int,
  member function propertySize return double precision)
/

Create type agent_t as object(
  aid char(3),
  aname varchar2(20),
  phoneNumber char(10),
  emailAddress varchar2(20),
  yearStarted int,
  agency varchar2(10),
  brokerLicense varchar2(10),
  map member function yearOfExperience return int,
  member function browseProperty return char)
/

Create type saleContract_t as object(
  scid char(4),
  sellerid ref seller_t,
  aoid ref agent_t,
  poid ref property_t,
  buyerid ref buyer_t,
  salePrice double precision,
  signedTime Date)
/

Create type rentContract_t as object(
  rcid char(4),
  landlordid ref landlord_t,
  aoid ref agent_t,
  tenantid ref tenant_t,
  rentPrice double precision,
  signedTime Date,
  rentLength int)
/

Create type agentContract_t as object(
  acid char(4),
  aoid ref agent_t,
  coid ref customer_t,
  signature_time Date,
  commissionPercentage double precision,
  Member function commission return double precision)
/

--Creat table 
Create table region of region_t(rid primary key);
Create table listing of listing_t (lid primary key);
Create table property of property_t(pid primary key, foreign key (roid) references region);
Create table agent of agent_t(aid primary key);
Create table customer of customer_t(cid primary key);
Create table buyer of buyer_t(cid primary key);
Create table seller of seller_t(cid primary key);
Create table landlord of landlord_t(cid primary key);
Create table tenant of tenant_t(cid primary key);
Create table saleContract of saleContract_t(scid primary key, foreign key (aoid) references agent, foreign key (buyerid) references buyer, foreign key (sellerid) references seller);
Create table rentContract of rentContract_t(rcid primary key, foreign key (aoid) references agent, foreign key (landlordid) references landlord, foreign key (tenantid) references tenant);
Create table agentContract of agentContract_t(acid primary key, foreign key (aoid) references agent, foreign key (coid) references customer);
