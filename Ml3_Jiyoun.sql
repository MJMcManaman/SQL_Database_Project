-- xmlagg, xmlattributes--  
SELECT XMLELEMENT("Listed_Properties",
  2      XMLAGG(
  3          XMLELEMENT("Property",
  4              XMLATTRIBUTES(p.pid AS "Property_ID", p.propertyDetail.lid AS "Listing_ID"),
  5              XMLELEMENT("Type", p.propertyType),
  6              XMLELEMENT("Address", p.address),
  7              XMLELEMENT("Washrooms", p.propertyDetail.washroomNum)
  8          )
    )
 10  ) AS document
 11  FROM property p
 12  WHERE p.propertyDetail.washroomNum = 2;

DOCUMENT
----------------------------------------------------------------------------------------------------
<Listed_Properties><Property Property_ID="p04 " Listing_ID="l04 "><Type>semidetached</Type><Address>
57 alberta ave</Address><Washrooms>2</Washrooms></Property><Property Property_ID="p08 " Listing_ID="
l08 "><Type>semidetached</Type><Address>56 oak st</Address><Washrooms>2</Washrooms></Property><Prope
rty Property_ID="p12 " Listing_ID="l12 "><Type>semidetached</Type><Address>67 spruce rd</Address><Wa
shrooms>2</Washrooms></Property></Listed_Properties>

--xmlroot, xmlattribute, xmlforest, groupby-- 
SQL> SELECT XMLROOT(
  2  XMLELEMENT("Regions",
  3  XMLAGG(
  4  XMLELEMENT("Region",
  5  XMLATTRIBUTES(r.regionName AS "Name"),
  6  XMLFOREST(COUNT(p.pid) AS "Total_Listed_Properties",AVG(p.propertyDetail.listedPrice) AS "Average_Listed_Price")
  7  ))),VERSION '1.0'
  8  ) AS document
  9  FROM property p, region r
 10  WHERE p.roid.rid = r.rid 
 11  AND p.propertyDetail.lid IS NOT NULL
 12  GROUP BY r.regionName;

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
  2      XMLELEMENT("Top_Agent",
  3          XMLELEMENT("Agent",
  4              XMLATTRIBUTES(a.aid AS "Agent_ID", a.agency AS "Agency"),
  5              XMLFOREST(
  6                  a.aname AS "Name",
  7                  a.yearOfExperience() AS "Experience",
  8                  ac.commission() AS "Total_Commission"
  9              )
 10          )
 11      ),
 12      VERSION '1.0'
) AS document
 14  FROM agentContract ac, agent a
 15  WHERE ac.aoid.aid = a.aid
 16  AND ac.commission() = (SELECT MAX(ac2.commission()) FROM agentContract ac2);

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
  
SQL> xquery
  2  let $b := doc("/public/mj/buyer.xml")
  3  for $buyer in $b/Buyers/Buyer
  4  where $buyer/dateStarted < "2020-01-01"
  5  return $buyer/buyerName/text()
  6  /

Result Sequence
--------------------------------------------------------------------------------
Charlie Brown
Diana White
Sophia Martin
James Anderson
  
--6 Xquery-- 
  
  2  let $b := doc("/public/mj/buyer.xml")
  3  let $sc := doc("/public/mj/saleContract.xml")
  4  for $buyer in $b/Buyers/Buyer, 
  5      $salecontract in $sc/SaleContracts/SaleContract
  6  where $buyer/@buyerID = $salecontract/buyerID/text()
  7    and $salecontract/salePrice < 500000.00
  8  return
  9    <BuyerSaleInfo>
    <buyerName>{$buyer/buyerName/text()}</buyerName>
 11      <buyerID>{$buyer/@buyerID}</buyerID>
 12      <contractID>{$salecontract/@scid}</contractID>
 13    </BuyerSaleInfo>
 14  /

Result Sequence
--------------------------------------------------------------------------------
<BuyerSaleInfo><buyerName>Diana White</buyerName><buyerID buyerID="c11"></buyerI
D><contractID scid="sc02"></contractID></BuyerSaleInfo>

<BuyerSaleInfo><buyerName>Lucas White</buyerName><buyerID buyerID="c12"></buyerI
D><contractID scid="sc03"></contractID></BuyerSaleInfo>

--7 xquery--
  
  2  let $p := doc("/public/mj/property.xml")
  3  for $property in $p/Properties/Property
  4  where $property/propertyType = "semidetached"
  5  return $property/address/text()
  6  /

Result Sequence
--------------------------------------------------------------------------------
94 cook rd
57 alberta ave
56 oak st
67 spruce rd




