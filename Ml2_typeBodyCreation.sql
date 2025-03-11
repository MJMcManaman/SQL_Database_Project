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

-- fixed function for customer
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
      WHERE ac.poid.propertyDetail.listedPrice < self.pricePreferred * 1.2;
    RETURN c;
  END propertyPreferred;
END;
/
  
-- fixed function for buyer
-- returns the seller's information that matches the buyer's pricePreference 
-- (what we have before is matching the sellers information who already signed a contract with the buyers, thus useless)
CREATE OR REPLACE TYPE BODY buyer_t AS
  OVERRIDING MEMBER FUNCTION propertyPreferred RETURN SYS_REFCURSOR IS c SYS_REFCURSOR;
  BEGIN
    OPEN c FOR
      SELECT DEREF(sc.sellerid).pricePreferred AS sellerOffer, DEREF(sc.sellerid).phoneNum AS sellerPhoneNum
      FROM saleContract sc
      WHERE DEREF(sc.sellerid).pricePreferred < self.pricePreferred * 1.2;
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
      SELECT DEREF(rc.landlordid).pricePreferred AS landlordOffer, DEREF(rc.landlordid).phoneNum AS landlordPhoneNum
      FROM rentContract rc
      WHERE DEREF(rc.landlordid).pricePreferred < self.pricePreferred * 1.2;
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
/

-- fixed function for agent
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

-- fixed function for agentContract
CREATE OR REPLACE TYPE BODY agentContract_t AS
  MEMBER FUNCTION commission RETURN NUMBER IS
    sc saleContract_t;
  BEGIN
    SELECT DEREF(SELF.scoid) INTO sc FROM DUAL;
    RETURN SELF.commissionPercentage * sc.salePrice;
  END commission;
END;
/

-- function for listing (no need fixing)
CREATE OR REPLACE TYPE BODY listing_t AS
  MEMBER FUNCTION daysListed RETURN INT IS
  BEGIN
    RETURN TRUNC(SYSDATE) - listingStartDate;
  END daysListed;
END;
/

-- function for property (no need fixing)
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
