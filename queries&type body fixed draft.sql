-- function for supertype customer
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
      SELECT ac.poid.pid, ac.poid.propertyType
      FROM agentContract ac
      WHERE ac.poid.propertyDetail.listedPrice < ac.scoid.buyerid.pricePreferred * 1.2
      AND ac.coid.cid = SELF.cid;--may become an issueac.coid never properly defined
    RETURN c;
  END propertyPreferred;
END;
/

-- function for subtype buyer
CREATE OR REPLACE TYPE BODY buyer_t AS
  OVERRIDING MEMBER FUNCTION propertyPreferred RETURN SYS_REFCURSOR IS c SYS_REFCURSOR;
  BEGIN
    OPEN c FOR
      SELECT ac.poid.pid, ac.poid.propertyType, DEREF(ac.scoid).sellerid.pricePreferred
      FROM agentContract ac
      WHERE ac.poid.propertyDetail.listedPrice < DEREF(ac.scoid).buyerid.pricePreferred * 1.2
      AND DEREF(ac.scoid).buyerid.cid = SELF.cid;
    RETURN c;
  END propertyPreferred;
END;
/

-- query #2 modified:
SELECT b.propertyPreferred() AS preferred_properties
FROM buyer b
WHERE b.cname = 'Lucas White';
-- successed
POID POID.PROPERTYTY DEREF(AC.SCOID).SELLERID.PRICEPREFERRED
---- --------------- ---------------------------------------
p05  detached                                         250000

-- function for subtype tenant
create or replace type body tenant_t as
  OVERRIDING MEMBER FUNCTION propertyPreferred RETURN SYS_REFCURSOR IS c SYS_REFCURSOR;
  BEGIN
    OPEN c FOR
      SELECT ac.poid.pid, ac.poid.propertyType
      FROM agentContract ac
      WHERE ac.poid.propertyDetail.listedPrice < ac.rcoid.tenantid.pricePreferred * 1.2 
      AND ac.rcoid.tenantid.cid = SELF.cid;
    RETURN c;
  END propertyPreferred;
END;
/
-- query for testing tenant type body:
SELECT t.cid, t.cname, t.propertyPreferred() AS preferred_properties
FROM tenant t WHERE t.cname = 'Oliver Brown';


--above working b4 query14.  not enough value for tenant&rentContract?

-- function for property
CREATE OR REPLACE TYPE BODY property_t AS
  MEMBER FUNCTION age RETURN INT IS
  BEGIN
    RETURN EXTRACT(YEAR FROM SYSDATE) - builtYear;
  END age;

  MAP MEMBER FUNCTION propertySize RETURN NUMBER IS
  BEGIN
    RETURN propertyWidth * propertyLength;
  END propertySize;
END;
/
  
--recreate property type body b4 query4

CREATE OR REPLACE TYPE BODY agentContract_t AS
  MEMBER FUNCTION commission RETURN NUMBER IS
    sc saleContract_t;
  BEGIN
    SELECT DEREF(SELF.scoid) INTO sc FROM DUAL;
    RETURN SELF.commissionPercentage * sc.salePrice;
  END commission;
END;
/
--recreate agentContract type body b4 query6

CREATE OR REPLACE TYPE BODY seller_t AS 
  OVERRIDING MEMBER FUNCTION timeOwned RETURN INT IS
  BEGIN
    RETURN ROUND((TRUNC(SYSDATE) - dateOwned) / 365);
  END timeOwned;
END;
/
--recreate seller type body b4 query7

CREATE OR REPLACE TYPE BODY listing_t AS
  MEMBER FUNCTION daysListed RETURN INT IS
  BEGIN
    RETURN TRUNC(SYSDATE) - listingStartDate;
  END daysListed;
END;
/
--recreate listing type body b4 query8

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
--recreate region type body b4 query9


CREATE OR REPLACE TYPE BODY agent_t AS
  MAP MEMBER FUNCTION yearOfExperience RETURN INT IS
  BEGIN
    RETURN EXTRACT(YEAR FROM SYSDATE) - SELF.yearStarted;
  END yearOfExperience;

  MEMBER FUNCTION browseProperty RETURN SYS_REFCURSOR IS
    c SYS_REFCURSOR;
  BEGIN
    OPEN c FOR
      SELECT ac.poid.pid, ac.poid.propertyType, ac.poid.builtYear, ac.poid.address
      FROM agentContract ac
      WHERE ac.aoid.aid = SELF.aid;
    RETURN c;
  END browseProperty;
END;
/
--modify agent type body & b4 query13
--testing agent type body:
SELECT a.aid, a.aname, a.browseProperty() AS properties_browsed
FROM agent a WHERE a.aid = 'a03';

--tried incorrect approach about propertyPreferred
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
      SELECT p.pid, p.propertyType
      FROM property p, agentContract ac
      WHERE p.pid = DEREF(ac.poid).pid
      AND DEREF(ac.poid).propertyDetail.listedPrice < self.pricePreferred * 1.2
      AND DEREF(ac.coid).cid = SELF.cid;
    RETURN c;
  END propertyPreferred;
END;
/

MEMBER FUNCTION propertyPreferred RETURN SYS_REFCURSOR IS c SYS_REFCURSOR;
  BEGIN
    OPEN c FOR
      SELECT ac.poid.pid, ac.poid.propertyType
      FROM agentContract ac
      WHERE ac.poid.propertyDetail.listedPrice * 0.005 < self.pricePreferred * 1.2
      AND ac.rcoid.cid = SELF.cid;    
    RETURN c;
  END propertyPreferred;
END;
/

CREATE OR REPLACE TYPE BODY buyer_t AS
  OVERRIDING MEMBER FUNCTION propertyPreferred RETURN SYS_REFCURSOR IS c SYS_REFCURSOR;
  BEGIN
    OPEN c FOR
      SELECT ac.poid.pid, ac.poid.propertyType, DEREF(ac.scoid).sellerid.pricePreferred
      FROM agentContract ac
      WHERE deref(ac.scoid).sellerid.pricePreferred < deref(ac.scoid).buyerid.pricePreferred * 1.2
      AND DEREF(ac.scoid).buyerid.cid = SELF.cid;
    RETURN c;
  END propertyPreferred;
END;
/

CREATE OR REPLACE TYPE BODY tenant_t AS
  OVERRIDING MEMBER FUNCTION propertyPreferred RETURN SYS_REFCURSOR IS c SYS_REFCURSOR;
  BEGIN
    OPEN c FOR
      SELECT ac.poid.pid, ac.poid.propertyType, deref(ac.rcoid).landlord.pricePreferred
      FROM agentContract ac
      WHERE deref(ac.rcoid).landlord.pricePreferred < deref(ac.rcoid).tenantid.pricePreferred * 1.2
      AND deref(ac.rcoid).tenantid.cid = SELF.cid;
    RETURN c;
  END propertyPreferred;
END;
/

--testing buyer's propertyPreferred:
SELECT c.propertyPreferred() AS preferred_properties
FROM buyer c
WHERE c.cname = 'Sophia Martin';

