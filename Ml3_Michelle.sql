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
                p.propertyDetail.daysListed() AS "daysListed"),
      XMLELEMENT("propertyPrice", 
      XMLELEMENT("listedPrice", p.propertyDetail.listedPrice))))), 
    VERSION '1.0') AS doc
FROM property p
WHERE p.roid.city = 'Vancouver';

-- did not use this one:
-- 2. List all landlords who has a rentContract with agent Brett Fox.
SELECT XMLROOT(XMLELEMENT("landlords",
  XMLAGG(XMLELEMENT("landlord_information",
    XMLATTRIBUTES(ac.rcoid.landlordid.cid AS "CID"),
        XMLFOREST(ac.rcoid.landlordid.cname AS "landlordName",
                ac.rcoid.landlordid.phoneNum AS "phoneNumber",
                ac.rcoid.landlordid.pricePreferred AS "landlord_price")) ORDER BY ac.rcoid.landlordid.cid)), version '1.0') as doc
  FROM agentContract ac WHERE ac.aoid.aname = 'Brett Fox' GROUP BY ac.rcoid.landlordid.pricePreferred;

-- 3. list all details of the sale contracts signed and the commission price of for the agent, including
-- seller & buyer's name, sale price, and the property's address, grouped by they final sale's price of the house.
SELECT XMLROOT(XMLELEMENT("Contracts_2025", 
  XMLAGG(XMLELEMENT("saleContract",
    XMLAGG(XMLELEMENT("contractDetails", 
      XMLATTRIBUTES(ac.scoid.scid AS "SCID"),
        XMLFOREST(ac.scoid.sellerid.cname AS "sellerName",
            ac.scoid.buyerid.cname AS "buyerName",
            ac.scoid.salePrice AS "salePrice",
            (ac.commissionPercentage * ac.scoid.salePrice) AS "commission",
            ac.poid.address AS "propertyAddress",
            ac.scoid.signedTime AS "signedDate")))))), version '1.0') as doc
FROM agentContract ac WHERE ac.scoid IS NOT NULL GROUP BY ac.scoid.salePrice;

-- 4. list all details of the rent contracts signed in the last 3 years, including
-- landlord & tenant's name, rent price, and the property's address.
SELECT XMLROOT(XMLELEMENT("Contracts", 
  XMLAGG(XMLELEMENT("rentContract",
    XMLAGG(XMLELEMENT("contractDetails", 
      XMLATTRIBUTES(ac.rcoid.rcid AS "RCID"),
          XMLFOREST(ac.rcoid.landlordid.cname AS "landlordName",
            ac.rcoid.tenantid.cname AS "tenantName",
            ac.rcoid.rentPrice AS "rentPrice",
            ac.poid.address AS "propertyAddress",
            ac.rcoid.signedTime AS "signedDate")))))), version '1.0') as doc
  FROM agentContract ac WHERE ac.rcoid.signedTime >= ADD_MONTHS(SYSDATE, -37) GROUP BY ac.rcoid.tenantid.cname;


--------------------------------------------------------------------------------------------------------------
-- XSU (total number of 1)
OracleXML getXML \
-user "grp2/here4grp2" \
-conn "jdbc:oracle:thin:@sit.itec.yorku.ca:1521/studb10g" \
-rowTag InformationDetail \
-rowsetTag PropertyAgentList \
"SELECT DISTINCT ac.aoid.aname AS agentName, ac.aoid.yearOfExperience() AS experienceYears, ac.poid.pid AS propertyID, ac.poid.address AS propertyAddress FROM agentContract ac"

--------------------------------------------------------------------------------------------------------------
-- Xquery (total number of 3)
-- 1. List all seller's information where their preferred price is more than 400000.00
-- use qualification conditions specified on elements
xquery
let $s := doc("/public/group2m25/seller.xml")
for $c in $s/Sellers/Seller
where $c/pricePreferred > "400000.00"
return $c
/

-- 2. List the preferred price of the buyer whose ID is c10.
-- use qualification conditions specified on tag attributes
xquery
let $b := doc("/public/group2m25/buyer.xml")
for $c in $b/Buyers/Buyer
where $c/@buyerID = "c10"
return $c/pricePreferred/text()
/

-- 3. List the agent that currently has a contract with customers, return their IDs.
-- formulated using more than one XML file from Oracle XML DB repository
xquery
let $a := doc('/public/group2m25/agent.xml')
for $agent in $a/Agents/Agent
let $ac := doc("/public/group2m25/agentContract.xml")
for $agentContract in $ac/AgentContracts/AgentContract
where $agent/@agentID = $agentContract/agentID
return element agentID {element agentID {$agent/@agentID},
    element agency {$agent/agency/text()},
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



