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
  poid ref property_t,
  rentPrice NUMBER,
  signedTime Date,
  rentLength int)
/

Create type agentContract_t as object(
  acid char(4),
  aoid ref agent_t,
  foid ref customer_t,
  toid ref customer_t,
  poid ref property_t,
  signature_time Date,
  saleContract REF saleContract_t,
  rentContract REF rentContract_t,
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
Create table saleContract of saleContract_t(scid primary key, foreign key (aoid) references agent, foreign key (buyerid) references buyer, foreign key (sellerid) references seller, foreign key (poid) references property);
Create table rentContract of rentContract_t(rcid primary key, foreign key (aoid) references agent, foreign key (landlordid) references landlord, foreign key (tenantid) references tenant, foreign key (poid) references property);
Create table agentContract of agentContract_t(acid primary key, foreign key (aoid) references agent, foreign key (coid) references customer, foreign key (poid) references property);

-- function for region
CREATE OR REPLACE TYPE BODY region_t AS 
ORDER MEMBER FUNCTION sort (r region_t) RETURN INTEGER IS 
  BEGIN
    IF SELF.regionName < r.regionName THEN
      RETURN -1;
    ELSIF SELF.regionName > r.regionName THEN
      RETURN 1;
    ELSIF SELF.regionName IS NULL OR r.regionName IS NULL THEN
      RETURN 0;
    ELSE
      RETURN 0;
    END IF;
  END SORT;
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

  MEMBER FUNCTION propertyPreferred RETURN SYS_REFCURSOR IS c SYS_REFCURSOR;
  BEGIN
    OPEN c FOR
      SELECT *
      FROM saleContract sc
      JOIN agentContract ac ON DEREF(ac.poid).pid = DEREF(sc.poid).pid
      JOIN property p ON p.pid = DEREF(sc.poid).pid
      WHERE p.propertyDetail.listedPrice > self.pricePreferred * 1.2;
    RETURN c;
  END propertyPreferred;
END;
/

-- function for buyer
CREATE OR REPLACE TYPE BODY buyer_t AS 
  OVERRIDING MEMBER FUNCTION timeSpentLooking RETURN INT IS 
  BEGIN 
    RETURN TRUNC(SYSDATE) - dateStarted;
  END timeSpentLooking;

  OVERRIDING MEMBER FUNCTION propertyPreferred RETURN SYS_REFCURSOR IS c SYS_REFCURSOR;
  BEGIN
    OPEN c FOR
      SELECT *
      FROM saleContract sc
      JOIN agentContract ac ON DEREF(ac.poid).pid = DEREF(sc.poid).pid
      JOIN property p ON p.pid = DEREF(sc.poid).pid
      WHERE p.propertyDetail.listedPrice > self.pricePreferred * 1.2;
    RETURN c;
  END propertyPreferred;
END;
/

-- function for seller
CREATE OR REPLACE TYPE BODY seller_t AS 
  OVERRIDING MEMBER FUNCTION timeOwned RETURN INT IS
  BEGIN
    RETURN ROUND((TRUNC(SYSDATE) - dateOwned) / 365);
  END timeOwned;
END;
/

-- function for tenant
CREATE OR REPLACE TYPE BODY tenant_t AS
  OVERRIDING MEMBER FUNCTION propertyPreferred RETURN SYS_REFCURSOR IS c SYS_REFCURSOR;
  BEGIN
    OPEN c FOR
      SELECT p.pid, p.propertyDetail.listedPrice
      FROM rentContract rc
      JOIN agentContract ac ON DEREF(ac.poid).pid = DEREF(rc.poid).pid
      JOIN property p ON p.pid = DEREF(rc.poid).pid
      JOIN landlord ld ON ld.cid = DEREF(ac.foid).cid
      WHERE ld.pricePreferred <= self.pricePreferred * 1.1;
    RETURN c;
  END propertyPreferred;
END;
/

CREATE OR REPLACE TYPE BODY tenant_t AS
  OVERRIDING MEMBER FUNCTION propertyPreferred RETURN SYS_REFCURSOR IS c SYS_REFCURSOR;
  BEGIN
    OPEN c FOR
      SELECT ld.pricePreferred
      FROM landlord ld
      JOIN rentContract rc ON DEREF(rc.landlordid).cid = ld.cid
      JOIN agentContract ac ON DEREF(ac.poid).pid = DEREF(rc.poid).pid
      JOIN property p ON p.pid = DEREF(ac.poid).pid
      WHERE ld.pricePreferred <= self.pricePreferred * 1.1;
    RETURN c;
  END propertyPreferred;
END;
/

CREATE OR REPLACE TYPE BODY tenant_t AS
  OVERRIDING MEMBER FUNCTION propertyPreferred RETURN SYS_REFCURSOR IS
    c SYS_REFCURSOR;
    v_pricePref NUMBER;
  BEGIN
    v_pricePref := self.pricePreferred;
    OPEN c FOR
      SELECT p.propertyDetail.listedPrice, p.address, p.propertyType
      FROM rentContract rc
      JOIN agentContract ac ON DEREF(ac.poid).pid = DEREF(rc.poid).pid
      JOIN property p ON p.pid = DEREF(rc.poid).pid
      JOIN landlord ld ON DEREF(rc.landlordid).cid = ld.cid
      WHERE p.propertyDetail.listedPrice <= v_pricePref * 1.1
        AND DEREF(rc.tenantid).cid = SELF.cid;
    RETURN c;
  END propertyPreferred;
END;
/


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
    RETURN EXTRACT(YEAR FROM SYSDATE) - SELF.yearStarted;
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


