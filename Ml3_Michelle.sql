SET long 32000
SET pagesize 60

--------------------------------------------------------------------------------------------------------------
-- requests (total number of 3 + extra one)
-- 1. List all properties in the "Vancouver" region (r02), including their property type, 
-- listed price, and the number of days they have been listed.
SELECT XMLROOT(XMLELEMENT("Vancouver_properties", 
    XMLAGG(XMLELEMENT("propertyDetails",
      XMLATTRIBUTES(p.pid AS "PID"),
        XMLFOREST(p.propertyType AS "propertyType",
            p.propertyDetail.listedPrice AS "listedPrice",
            p.propertyDetail.daysListed() AS "daysListed")))), version '1.0') as doc
  FROM property p WHERE p.roid.regionName = 'Vancouver';


-- 2. List all landlords who has a rentContract with tenant Mia Peterson.
SELECT XMLROOT(XMLELEMENT("landlords",
  XMLAGG(XMLELEMENT("landlord_information",
    XMLATTRIBUTES(rc.landlordid.cid AS "CID"),
      XMLAGG(XMLELEMENT("info",
        XMLFOREST(rc.landlordid.cname AS "landlordName",
                rc.landlordid.phoneNum AS "phoneNumber",
                rc.landlordid.pricePreferred AS "landlord_price")))))), version '1.0') as doc
  FROM rentContract rc WHERE rc.tenantid.cname = 'Mia Peterson' GROUP BY rc.landlordid.cid;

-- 3. list all details of the sale contracts signed this year (2025), including
-- seller & buyer's name, sale price, and the property's address.
SELECT XMLROOT(XMLELEMENT("Contracts_2025", 
  XMLELEMENT("saleContract",
    XMLAGG(XMLELEMENT("contractDetails", 
      XMLATTRIBUTES(ac.scoid.scid AS "SCID"),
        XMLAGG(XMLELEMENT("info",
        XMLFOREST(ac.scoid.sellerid.cname AS "sellerName",
            ac.scoid.buyerid.cname AS "buyerName",
            ac.scoid.salePrice AS "salePrice",
            ac.poid.address AS "propertyAddress",
            ac.scoid.signedTime AS "signedDate"))))))), version '1.0') as doc
  FROM agentContract ac WHERE EXTRACT(YEAR FROM ac.scoid.signedTime) = 2025 GROUP BY ac.scoid.scid;

-- 4. list all details of the rent contracts signed in the last 3 years, including
-- landlord & tenant's name, rent price, and the property's address.
SELECT XMLROOT(XMLELEMENT("Contracts", 
  XMLELEMENT("rentContract",
    XMLAGG(XMLELEMENT("contractDetails", 
      XMLATTRIBUTES(ac.rcoid.rcid AS "RCID"),
          XMLFOREST(ac.rcoid.landlordid.cname AS "landlordName",
            ac.rcoid.tenantid.cname AS "tenantName",
            ac.rcoid.rentPrice AS "rentPrice",
            ac.poid.address AS "propertyAddress",
            ac.rcoid.signedTime AS "signedDate"))))), version '1.0') as doc
  FROM agentContract ac WHERE ac.rcoid.signedTime >= ADD_MONTHS(SYSDATE, -37) 
  GROUP BY ac.rcoid.signedTime;


--------------------------------------------------------------------------------------------------------------
-- XSU (total number of 1)
OracleXML getXML -user "grp2/here4grp2" -conn "jdbc:oracle:thin:@sit.itec.yorku.ca:1521/studb10g" "SELECT DISTINCT ac.aoid.aname AS agentName, ac.aoid.yearOfExperience() AS experienceYears, ac.poid.pid AS propertyID, ac.poid.address AS propertyAddress FROM agentContract ac"

--------------------------------------------------------------------------------------------------------------
-- Xquery (total number of 3)
-- 1. List all seller's information where their preferred price is more than 400000.00
-- use qualification conditions specified on elements
xquery
let $s := doc("/public/group2m25/seller.xml")
for $c in $s/Sellers/Seller
where $c/pricePreferred > " 400000.00"
return $c
/

-- 2. List the buyer's ID, name and pricePreferred which their ID is c10.
-- use qualification conditions specified on tag attributes
xquery
let $b := doc("/public/group2m25/buyer.xml")
for $c in $s/Buyers/Buyer
where $c/@buyerID > " c10"
return element buyer {element buyerID {$c/buyer/@buyerID},
    element buyerName {$c/buyerName/text()},
    element pricePreferred {$c/pricePreferred/text()}}
/

-- 3. List the agent that currently has a contract with customers, return their IDs.
-- formulated using more than one XML file from Oracle XML DB repository
xquery
let $a := doc("/public/group2m25/agent.xml")
for $e in $a/Agents/Agent
let $ac := doc("/public/group2m25/agentContract.xml")
for $b in $ac/AgentContracts/AgentContract
where $e/@agentID = $b/agentID
return element agentID {element agentID {$e/@agentID},
    element agency {$e/agency/text()},
    element yearStarted {$a/yearStarted/text()}}
/



    







    
-------------------------------------------------------------------------------------------------------------
-- the rest of the requests are not used for now, just ideas.
-- can be used later for xquery or if anyone can't think of a request.
-- these contain issues though, let me know if you wanna use these

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

-- 6. list all buyers' pricePreferences and properties that matches's their price range.
SELECT XMLROOT(XMLELEMENT("Buyer",
  XMLATTRIBUTES(b.cid AS "buyerID"),
    XMLFOREST(b.cname AS "buyerName",
              b.pricePreferred AS "perferredPrice"),
      XMLELEMENT("Properties",
        (SELECT XMLELEMENT("Property",
          XMLATTRIBUTES(p.pid AS "propertyID"),
            XMLFOREST(p.address AS "propertyAddres",
                      p.propertyType AS "propertyType",
                      p.age() AS "propertyAge"))
        FROM property p WHERE p.propertyDetail.listedPrice < b.pricePreferred))), version '1.0') as doc
  FROM buyer b;

-- 7. List property and its details handled by agent Frank Miller and his years of
-- experiences.
SELECT XMLROOT(
  XMLELEMENT("Property", 
   XMLAGG(XMLELEMENT("propertyDetails",
     XMLATTRIBUTES(p.pid AS "propertyID"),
      XMLFOREST(p.propertyType AS "propertyType",
           p.propertyDetail.listedPrice AS "listedPrice",
           p.builtYear AS "builtYear",
           p.age() AS "propertyAge")
      XMLELEMENT("Agents",
         (SELECT XMLAGG(
          XMLELEMENT("agent",
           XMLATTRIBUTES(a.aid AS "agentID"),
             XMLFOREST(a.aname AS "agentName",
                      a.yearOfExperience() AS "yearsOfExperiences")))
      FROM agent a, agentContract ac WHERE a.aid = ac.aoid.aid
      AND ac.poid.pid = p.pid AND a.aname = 'Frank Miller'))))), version '1.0') as doc
  FROM property p WHERE a.aname = 'Frank Miller'
  AND a.aid = ac.aoid.aid AND ac.poid.pid = p.pid;

-- working one
SELECT XMLROOT(
XMLELEMENT("Property",
XMLAGG(
XMLELEMENT("propertyDetails",
XMLATTRIBUTES(p.pid AS "propertyID"),
XMLFOREST(p.propertyType AS "propertyType",
p.propertyDetail.listedPrice AS "listedPrice",
p.builtYear AS "builtYear"),
XMLELEMENT("Agents",
(SELECT XMLAGG(
XMLELEMENT("agent",
XMLATTRIBUTES(a.aid AS "agentID"),
XMLFOREST(a.yearOfExperience() AS "yearsOfExperience")))
FROM agent a, agentContract ac
WHERE a.aid = ac.aoid.aid
AND ac.poid.pid = p.pid))))), VERSION '1.0') AS doc
FROM property p
WHERE EXISTS (SELECT * FROM agentContract ac, agent a WHERE ac.aoid.aid = a.aid 
  AND ac.poid.pid = p.pid AND a.aname = 'Frank Miller');



