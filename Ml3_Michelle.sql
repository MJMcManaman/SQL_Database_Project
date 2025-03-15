SET long 32000
SET pagesize 60

-- List all properties in the "Vancouver" region , including their property type, 
-- listed price, and the number of days they have been listed.
SELECT XMLELEMENT("Property",
  XMLFOREST(p.pid AS "propertyID", 
            p.propertyType AS "propertyType",
            p.propertyDetail.listedPrice AS "listedPrice".
            p.propertyDetail.daysListed() AS "daysListed")) as doc
  FROM property p, region r WHERE p.roid.rid = r.rid AND r.regionName = "Vancouver";

-- List all landlords who have owned their properties for more than 10 years, 
-- including their contact information and the properties they own.
SELECT XMLELEMENT("Landlord",
  XMLFOREST(l.cname AS "landlordName",
            l.phoneNum AS "phoneNumber",
            XMLELEMENT("Properties",
              XMLAGG(
                XMLELEMENT("Property",
                  XMLFOREST(p.pid AS "propertyID",
                            p.propertyType AS "propertyType",
                            p.address AS "address")))))) as doc
  FROM landlord l, property p WHERE l.timeOwned() > 10 GROUP BY l.cname;
