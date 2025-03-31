-- xmlagg, xmlattributes--  
SELECT XMLELEMENT("Listed_Properties",
        XMLAGG(
            XMLELEMENT("Property",
                XMLATTRIBUTES(p.pid AS "Property_ID", p.propertyDetail.lid AS "Listing_ID"),
                XMLELEMENT("Type", p.propertyType),
                XMLELEMENT("Address", p.address),
                XMLELEMENT("Washrooms", p.propertyDetail.washroomNum)
            )
    )
   ) AS document
   FROM property p
   WHERE p.propertyDetail.washroomNum = 2;

DOCUMENT
----------------------------------------------------------------------------------------------------
<Listed_Properties><Property Property_ID="p04 " Listing_ID="l04 "><Type>semidetached</Type><Address>
57 alberta ave</Address><Washrooms>2</Washrooms></Property><Property Property_ID="p08 " Listing_ID="
l08 "><Type>semidetached</Type><Address>56 oak st</Address><Washrooms>2</Washrooms></Property><Prope
rty Property_ID="p12 " Listing_ID="l12 "><Type>semidetached</Type><Address>67 spruce rd</Address><Wa
shrooms>2</Washrooms></Property></Listed_Properties>

--xmlroot, xmlattribute, xmlforest, groupby-- 
SELECT XMLROOT(
    XMLELEMENT("Regions",
    XMLAGG(
    XMLELEMENT("Region",
    XMLATTRIBUTES(r.regionName AS "Name"),
    XMLFOREST(COUNT(p.pid) AS "Total_Listed_Properties",AVG(p.propertyDetail.listedPrice) AS "Average_Listed_Price")
    ))),VERSION '1.0'
    ) AS document
    FROM property p, region r
   WHERE p.roid.rid = r.rid 
   AND p.propertyDetail.lid IS NOT NULL
   GROUP BY r.regionName;

----modified: references corrected.
SELECT XMLROOT(
  XMLELEMENT("Regions",
    XMLAGG(XMLELEMENT("Region",
      XMLATTRIBUTES(p.roid.regionName AS "Name"),
      XMLFOREST(COUNT(p.pid) AS "Total_Listed_Properties",
                AVG(p.propertyDetail.listedPrice) AS "Average_Listed_Price")))),VERSION '1.0') AS document
FROM property p WHERE p.roid.rid IS NOT NULL GROUP BY p.roid.regionName;


DOCUMENT
----------------------------------------------------------------------------------------------------
<?xml version="1.0"?>
<Regions>
  <Region Name="Prairie">
    <Total_Listed_Properties>2</Total_Listed_Properties>
    <Average_Listed_Price>1220000</Average_Listed_Price>
  </Region>
  <Region Name="East">
    <Total_Listed_Properties>3</Total_Listed_Properties>
    <Average_Listed_Price>1216000</Average_Listed_Price>
  </Region>
  <Region Name="West">
    <Total_Listed_Properties>2</Total_Listed_Properties>
    <Average_Listed_Price>1275000</Average_Listed_Price>
  </Region>
  <Region Name="Atlantic">
    <Total_Listed_Properties>2</Total_Listed_Properties>
    <Average_Listed_Price>925000</Average_Listed_Price>
  </Region>
</Regions>

--xmlroot,xmlattribute,xmlforest--
--this needs to be updated --
SELECT XMLROOT(
        XMLELEMENT("Top_Agent",
            XMLELEMENT("Agent",
                XMLATTRIBUTES(a.aid AS "Agent_ID", a.agency AS "Agency"),
                XMLFOREST(
                    a.aname AS "Name",
                    a.yearOfExperience() AS "Experience",
                    ac.commission() AS "Total_Commission"
                )
           )
       ),
       VERSION '1.0'
) AS document
   FROM agentContract ac, agent a
   WHERE ac.aoid.aid = a.aid
   AND ac.commission() = (SELECT MAX(ac2.commission()) FROM agentContract ac2);

------ update version:
SELECT XMLROOT(
        XMLELEMENT("Top_Agent",
            XMLELEMENT("Agent",
                XMLATTRIBUTES(ac.aoid.aid AS "Agent_ID", ac.aoid.agency AS "Agency"),
                XMLFOREST(
                    ac.aoid.aname AS "Name",
                    ac.aoid.yearOfExperience() AS "Experience",
                    ac.commission() AS "Total_Commission"))),VERSION '1.0') AS document
FROM agentContract ac
WHERE ac.commission() = (SELECT MAX(ac2.commission()) FROM agentContract ac2);

DOCUMENT
----------------------------------------------------------------------------------------------------
<?xml version="1.0"?>
<Top_Agent>
  <Agent Agent_ID="a03 " Agency="SafeHomes">
    <Name>Grace Hall</Name>
    <Experience>7</Experience>
    <Total_Commission>40500</Total_Commission>
  </Agent>
</Top_Agent>

--4 XSU--
  
[jyshim@sit ~]$ OracleXML getXML \
-user "grp2/here4grp2" \
-conn "jdbc:oracle:thin:@sit.itec.yorku.ca:1521/studb10g" \
-rowTag BuyerAgentSummary \
-rowsetTag BuyerAgentSummaryList \
"SELECT b.cid AS buyer_id, b.cname AS buyer_name, b.timeSpentLooking() AS time_spent, a.aid AS agent_id, a.aname AS agent_name FROM saleContract sc, buyer b, agentContract ac, agent a WHERE sc.buyerid.cid = b.cid AND ac.scoid.scid = sc.scid AND ac.aoid.aid = a.aid"

-----modified: I don't think we need -rowTag and -rowsetTag, professor used these for inserting XML data into XSU, I don't think
  -- that what the professor wants. So deleted those and returned the same result you desired.
OracleXML getXML -user "grp2/here4grp2" 
-conn "jdbc:oracle:thin:@sit.itec.yorku.ca:1521/studb10g" 
"SELECT ac.scoid.buyerid.cid AS buyer_id, ac.scoid.buyerid.cname AS buyer_name, 
ac.scoid.buyerid.timeSpentLooking() AS time_spent, ac.aoid.aid AS agent_id, ac.aoid.aname AS agent_name 
FROM agentContract ac WHERE ac.scoid IS NOT NULL"
  
<?xml version = '1.0'?>
<BuyerAgentSummaryList>
   <BuyerAgentSummary num="1">
      <BUYER_ID>c11 </BUYER_ID>
      <BUYER_NAME>Diana White</BUYER_NAME>
      <TIME_SPENT>2323</TIME_SPENT>
      <AGENT_ID>a03 </AGENT_ID>
      <AGENT_NAME>Grace Hall</AGENT_NAME>
   </BuyerAgentSummary>
   <BuyerAgentSummary num="2">
      <BUYER_ID>c12 </BUYER_ID>
      <BUYER_NAME>Lucas White</BUYER_NAME>
      <TIME_SPENT>1102</TIME_SPENT>
      <AGENT_ID>a02 </AGENT_ID>
      <AGENT_NAME>Frank Miller</AGENT_NAME>
   </BuyerAgentSummary>
</BuyerAgentSummaryList>

  
--5 Xquery-- 
  
xquery
let $b := doc("/public/mj/buyer.xml")
for $buyer in $b/Buyers/Buyer
where $buyer/dateStarted < "2020-01-01"
return $buyer/buyerName/text()
/

Result Sequence
--------------------------------------------------------------------------------
Charlie Brown
Diana White
Sophia Martin
James Anderson
  
--6 Xquery-- 

xquery
let $b := doc("/public/mj/buyer.xml")
let $sc := doc("/public/mj/saleContract.xml")
for $buyer in $b/Buyers/Buyer, 
    $salecontract in $sc/SaleContracts/SaleContract
where $buyer/@buyerID = $salecontract/buyerID/text()
and $salecontract/salePrice < 500000.00
return
  <BuyerSaleInfo>
  <buyerName>{$buyer/buyerName/text()}</buyerName>
  <buyerID>{$buyer/@buyerID}</buyerID>
  <contractID>{$salecontract/@scid}</contractID>
  </BuyerSaleInfo>
/

Result Sequence
--------------------------------------------------------------------------------
<BuyerSaleInfo><buyerName>Diana White</buyerName><buyerID buyerID="c11"></buyerI
D><contractID scid="sc02"></contractID></BuyerSaleInfo>

<BuyerSaleInfo><buyerName>Lucas White</buyerName><buyerID buyerID="c12"></buyerI
D><contractID scid="sc03"></contractID></BuyerSaleInfo>

--7 xquery--

xquery
let $p := doc("/public/mj/property.xml")
for $property in $p/Properties/Property
where $property/propertyType = "semidetached"
return $property/address/text()
/

Result Sequence
--------------------------------------------------------------------------------
94 cook rd
57 alberta ave
56 oak st
67 spruce rd




