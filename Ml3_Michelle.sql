SET long 32000
SET pagesize 60

-- 1. List all properties in the "Vancouver" region , including their property type, 
-- listed price, and the number of days they have been listed.
SELECT XMLROOT(XMLELEMENT("Property", 
  XMLELEMENT("VancouverProperties",
    XMLAGG(XMLELEMENT("propertyDetails",
      XMLATTRIBUTES(p.pid AS "propertyID"),
        XMLFOREST(p.propertyType AS "propertyType",
            p.propertyDetail.listedPrice AS "listedPrice",
            p.propertyDetail.daysListed() AS "daysListed"))))), version '1.0') as doc
  FROM property p, region r WHERE p.roid.rid = r.rid AND r.city = 'Vancouver';

-- 2. List all landlords who have owned their properties for more than 10 years, 
-- including their contact information and the properties they own.
SELECT XMLELEMENT("Landlords",
  XMLFOREST(l.cname AS "landlordName",
            l.phoneNum AS "phoneNumber",
            p.pid AS "propertyID",
            p.propertyType AS "Type",
            p.address AS "Address")) as doc
  FROM landlord l, property p, agentContract ac, rentContract rc
  WHERE l.timeOwned() > 10
  AND ac.rcoid.rcid = rc.rcid AND rc.landlordid.cid = l.cid
  AND ac.poid.pid = p.pid;

-- 3. list all details of the sale contracts signed this year (2025), including
-- seller & buyer's name, sale price, and the property's address.
SELECT XMLROOT(XMLELEMENT("Contracts_2025", 
  XMLELEMENT("saleContract",
    XMLAGG(XMLELEMENT("contractDetails", 
      XMLATTRIBUTES(sc.scid AS "SCID"),
        XMLFOREST(s.cname AS "sellerName",
            b.cname AS "buyerName",
            sc.salePrice AS "salePrice",
            p.address AS "propertyAddress"))))), version '1.0') as doc
  FROM saleContract sc, seller s, buyer b, property p, agentContract ac
  WHERE sc.sellerid.cid = s.cid AND sc.buyerid.cid = b.cid 
  AND EXTRACT(YEAR FROM sc.signedTime) = 2025
  AND ac.poid.pid = p.pid AND ac.scoid.scid = sc.scid GROUP BY sc.scid;

-- 4. list all details of the rent contracts signed in the last 3 years, including
-- landlord & tenant's name, rent price, and the property's address.
SELECT XMLROOT(XMLELEMENT("Contracts", 
  XMLELEMENT("rentContract",
    XMLAGG(XMLELEMENT("contractDetails", 
      XMLATTRIBUTES(rc.rcid AS "RCID"),
        XMLFOREST(l.cname AS "landlordName",
            t.cname AS "tenantName",
            rc.rentPrice AS "rentPrice",
            p.address AS "propertyAddress"))))), version '1.0') as doc
  FROM rentContract rc, landlord l, tenant t, property p, agentContract ac
  WHERE rc.landlordid.cid = l.cid AND rc.tenantid.cid = t.cid 
  AND rc.signedTime >= ADD_MONTHS(SYSDATE, -37)
  AND ac.poid.pid = p.pid AND ac.rcoid.rcid = rc.rcid;

-- 5. list all the properties that are signed this year with the details of the 
-- property (property's type, address, the recommended price, open house's date,
-- for that property, and the number of days it has been on the market).
SELECT XMLROOT(XMLELEMENT("Listings",
  XMLAGG(XMLELEMENT("property",
    XMLATTRIBUTES(p.pid AS "propertyID"),
      XMLFOREST(p.propertyType AS "type",
                p.address AS "address",
                p.propertyDetail.listedPrice AS "listedPrice",
                p.propertyDetail.openHouse AS "openHouse",
                p.propertyDetail.daysListed() AS "daysOnMarket")))), version '1.0') as doc
  FROM property p WHERE EXTRACT(YEAR FROM p.propertyDetail.listingStartDate) = 2025;

-- 6. list all properties that matches Sophia Martin's price's preference.
SELECT XMLROOT(
  XMLELEMENT("Buyer",
    XMLFOREST(b.cid AS "buyerID",
              b.cname AS "buyerName",
                XMLELEMENT("PreferredProperties",
                  (SELECT XMLAGG(
                    XMLELEMENT("Property",
                      XMLFOREST(p.pid AS "propertyID",
                                p.propertyType AS "propertyType")))
                        FROM TABLE(b.propertyPreferred())))), version '1.0') as doc
  FROM buyer b WHERE b.cname = 'Sophia Martin';








