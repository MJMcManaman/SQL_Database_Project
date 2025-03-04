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
  dateStarted Date,
  dateOwned Date,
  member function timeSpentLooking return int,
  member function timeOwned return int,
  MEMBER FUNCTION selections RETURN SYS_REFCURSOR) NOT FINAL;
/

Create type buyer_t under customer_t(
  pricePreference NUMBER,
  priceFluctuation NUMBER,
  overriding member function timeSpentLooking return int,
  overriding MEMBER FUNCTION selections RETURN SYS_REFCURSOR);
/

Create type seller_t under customer_t(
  propertyRegister int,
  Overriding member function timeOwned return int)
/

Create type tenant_t under customer_t(
  pricePreference NUMBER,
  priceFluctuation NUMBER,
  overriding member function timeSpentLooking return int,
  overriding MEMBER FUNCTION selections RETURN SYS_REFCURSOR);
/

Create type landlord_t under customer_t(
  propertyRegister int,
  Overriding member function timeOwned return int)
/

CREATE OR REPLACE TYPE region_t AS OBJECT (
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
  member function propertySize return NUMBER)
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
  aoid ref agent_t,
  poid ref property_t,
  buyerid ref buyer_t,
  salePrice NUMBER,
  signedTime Date)
/

Create type rentContract_t as object(
  rcid char(4),
  landlordid ref landlord_t,
  aoid ref agent_t,
  tenantid ref tenant_t,
  rentPrice NUMBER,
  signedTime Date,
  rentLength int)
/

Create type agentContract_t as object(
  acid char(4),
  aoid ref agent_t,
  coid ref customer_t,
  poid ref property_t,
  signature_time Date,
  saleContract REF saleContract_t,
  commissionPercentage NUMBER,
  Member function commission return NUMBER)
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

-- function for region
CREATE OR REPLACE TYPE BODY region_t AS 
ORDER MEMBER FUNCTION sort (r region_t) RETURN INTEGER IS 
  BEGIN
    IF SELF.regionName < r.regionName THEN
      RETURN -1;
    ELSIF SELF.regionName > r.regionName THEN
      RETURN 1;
    ELSEIF SELF.regionName IS NULL OR r.regionName IS NULL THEN
      RETURN 0;
    ELSE
      RETURN 0;
  END IF;
END;
/

-- function for customer
CREATE OR REPLACE TYPE BODY customer_t AS 
  MEMBER FUNCTION timeSpentLooking RETURN INT IS 
  BEGIN 
    RETURN TRUNC(SYSDATE) - dateStarted;
  END timeSpentLooking;
    
  MEMBER FUNCTION timeOwned RETURN INT IS
  BEGIN
    RETURN TRUNC(SYSDATE) - dateOwned;
  END timeOwned;

  MEMBER FUNCTION selections RETURN SYS_REFCURSOR IS
    c SYS_REFCURSOR;
  BEGIN
    OPEN c FOR 
      SELECT * 
      FROM buyer b
      JOIN saleContract sc ON DEREF(sc.buyerid).cid = b.cid
      JOIN agentContract ac ON ac.aoid = sc.aoid
      JOIN property p ON DEREF(sc.poid).pid = p.pid;
    RETURN c;
  END selections;
END;
/

  
-- function for buyer
CREATE OR REPLACE TYPE BODY buyer_t AS 
  OVERRIDING MAP MEMBER FUNCTION timeSpentLooking RETURN INT IS 
  BEGIN 
    RETURN TRUNC(SYSDATE) - dateStarted;
  END timeSpentLooking;

  OVERRIDING MEMBER FUNCTION selections RETURN SYS_REFCURSOR IS
    c SYS_REFCURSOR;
  BEGIN
    OPEN c FOR 
      SELECT * 
      FROM buyer b
      JOIN saleContract sc ON DEREF(sc.buyerid).cid = b.cid
      JOIN agentContract ac ON ac.aoid = sc.aoid
      JOIN property p ON DEREF(sc.poid).pid = p.pid;
    RETURN c;
  END selections;
END;

-- function for seller
CREATE OR REPLACE TYPE BODY seller_t AS 
  OVERRIDING MEMBER FUNCTION timeOwned RETURN INT IS
  BEGIN
    RETURN TRUNC(SYSDATE) - dateOwned;
  END timeOwned;
END;

-- function for tenant
CREATE OR REPLACE TYPE BODY tenant_t AS 
  OVERRIDING MAP MEMBER FUNCTION timeSpentLooking RETURN INT IS 
  BEGIN 
    RETURN TRUNC(SYSDATE) - dateStarted;
  END timeSpentLooking;

  OVERRIDING MEMBER FUNCTION selections RETURN SYS_REFCURSOR IS
    c SYS_REFCURSOR;
  BEGIN
    OPEN c FOR 
      SELECT * 
      FROM buyer b
      JOIN saleContract sc ON DEREF(sc.buyerid).cid = b.cid
      JOIN agentContract ac ON ac.aoid = sc.aoid
      JOIN property p ON DEREF(sc.poid).pid = p.pid;
    RETURN c;
  END selections;
END;

-- function for landlord
CREATE OR REPLACE TYPE BODY landlord_t AS 
  OVERRIDING MEMBER FUNCTION timeOwned RETURN INT IS
  BEGIN
    RETURN TRUNC(SYSDATE) - dateOwned;
  END timeOwned;
END;


-- function for agent
CREATE OR REPLACE TYPE BODY agent_t AS
  MAP MEMBER FUNCTION yearOfExperience RETURN INT IS
  BEGIN
    RETURN EXTRACT(YEAR FROM SYSDATE) - SELF.yearStarted DESC;
  END yearOfExperience;
  
  MEMBER FUNCTION browseProperty RETURN SYS_REFCURSOR IS
    c SYS_REFCURSOR;
  BEGIN
    OPEN c FOR 
      SELECT a.*
      FROM agent a
      JOIN agentContract ac ON DEREF(ac.aoid).aid = a.aid
      JOIN property p ON p.pid = DEREF(ac.poid).pid;
    RETURN c;
  END browseProperty;
END;
/

  
SELECT a.aid, a.aname, a.yearOfExperience() AS experience FROM agent a;

-- function for agentContract
CREATE OR REPLACE TYPE BODY agentContract_t AS
  MEMBER FUNCTION commission RETURN NUMBER IS
    sc saleContract_t;
  BEGIN
    SELECT DEREF(SELF.saleContract) INTO sc FROM DUAL;
    RETURN SELF.commissionPercentage * sc.salePrice;
  END commission;
END;
/


-- function for listing
CREATE OR REPLACE TYPE BODY listing_t AS
  MEMBER FUNCTION daysListed RETURN INT IS
  BEGIN
    RETURN TRUNC(SYSDATE) - listingStartDate;
  END daysListed;
END;
/

-- function for property
CREATE OR REPLACE TYPE BODY property_t AS
  MEMBER FUNCTION age RETURN INT IS
  BEGIN
    RETURN EXTRACT(YEAR FROM SYSDATE) - builtYear;
  END age;

  MEMBER FUNCTION propertySize RETURN NUMBER IS
  BEGIN
    RETURN propertyWidth * propertyLength;
  END propertySize;
END;
/


