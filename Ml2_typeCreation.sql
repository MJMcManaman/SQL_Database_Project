drop table agentContract;
drop table saleContract;
drop table rentContract;
drop table tenant;
drop table landlord;
drop table seller;
drop table buyer;
drop table listing;
drop table property;
drop table region;
drop table customer;
drop table agent;



Create type customer_t as object(
  cid char(4),
  cname varchar2(20),
  phoneNum char(10),
  emailAddress varchar2(20),
  dateStarted Date,
  dateOwned Date,
  pricePreferred NUMBER,
  member function timeSpentLooking return int,
  member function timeOwned return int,
  MEMBER FUNCTION propertyPreferred RETURN SYS_REFCURSOR) NOT FINAL;
/

Create type buyer_t under customer_t(
  overriding MEMBER FUNCTION propertyPreferred RETURN SYS_REFCURSOR);
/

Create type seller_t under customer_t(
  Overriding member function timeOwned return int)
/

Create type tenant_t under customer_t(
  overriding MEMBER FUNCTION propertyPreferred RETURN SYS_REFCURSOR);
/

Create type landlord_t under customer_t(
  Overriding member function timeOwned return int)
/

CREATE TYPE region_t AS OBJECT (
  rid VARCHAR2(10),
  regionName VARCHAR2(20),
  province VARCHAR2(20),
  city VARCHAR2(10),
  ORDER MEMBER FUNCTION sort (r region_t) RETURN INTEGER);
/

Create type listing_t as object(
  lid char(4),
  listingStartDate date,
  listedPrice NUMBER,
  washroomNum int,
  livingroomNum int,
  bedroomNum int,
  balcony int,
  kitchenNum int,
  parkingSpace int,
  elevator int,
  openHouse date,
  member function daysListed return int)
/

Create type property_t as object(
  pid char(4),
  roid ref region_t,
  propertyDetail listing_t,
  propertyType varchar2(15),
  builtYear int,
  address varchar2(30),
  postalCode varchar2(6),
  propertyWidth NUMBER,
  propertyLength NUMBER,
  member function age return int,
  map member function propertySize return NUMBER)
/

Create type agent_t as object(
  aid char(4),
  aname varchar2(20),
  phoneNumber char(10),
  emailAddress varchar2(20),
  yearStarted int,
  agency varchar2(10),
  brokerLicense varchar2(10),
  map member function yearOfExperience return int,
  member function browseProperty return sys_refcursor)
/

Create type saleContract_t as object(
  scid char(4),
  sellerid ref seller_t,
  buyerid ref buyer_t,
  salePrice NUMBER,
  signedTime Date)
/

Create type rentContract_t as object(
  rcid char(4),
  landlordid ref landlord_t,
  tenantid ref tenant_t,
  rentPrice NUMBER,
  signedTime Date,
  rentLength int)
/

Create type agentContract_t as object(
  acid char(4),
  aoid ref agent_t,
  poid ref property_t,
  coid ref customer_t,
  signature_time Date,
  scoid ref saleContract_t,
  rcoid REF rentContract_t,
  commissionPercentage NUMBER,
  Member function commission return NUMBER)
/
