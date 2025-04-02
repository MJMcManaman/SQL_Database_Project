-- 1. list all angents who have more than 12 years of experience and their contracts numbers
SELECT XMLROOT(
      XMLELEMENT("agentExpert",
         XMLAGG(XMLELEMENT("agent",
               XMLATTRIBUTES(ac.aoid.aid AS "aid"),
                   XMLFOREST(ac.aoid.aname AS "AgentName", 
                        (EXTRACT(YEAR FROM SYSDATE) - ac.aoid.yearStarted) AS "ExperienceYears"),
                XMLAGG(XMLELEMENT("contract",
                     XMLFOREST(ac.acid AS "contractID")))))), VERSION '1.0') AS doc
FROM agentContract ac
WHERE (EXTRACT(YEAR FROM SYSDATE) - ac.aoid.yearStarted) > 12
GROUP BY ac.aoid;

-- 2. list all buyers' information who buy house before year 2025
SELECT XMLROOT(
      XMLELEMENT("BuyersPre",
         XMLAGG(
            XMLELEMENT("Buyer",
               XMLATTRIBUTES(sc.buyerid.cid AS "BuyerID"),
               XMLFOREST(sc.buyerid.cname AS "BuyerName",
                         sc.buyerid.phoneNum AS "BuyerPhone", 
                         sc.buyerid.emailAddress AS "BuyerEmail"),
               XMLELEMENT("Purchases",
                  XMLAGG(
                     XMLELEMENT("Purchase",
                        XMLATTRIBUTES(sc.scid AS "SaleContractID"),
                        XMLFOREST(sc.salePrice AS "PurchasePrice", 
                                  sc.signedTime AS "PurchaseDate"))))))), VERSION '1.0') AS doc
FROM saleContract sc 
WHERE sc.signedTime < DATE '2025-01-01'
GROUP BY sc.buyerid;

-- 3. list all properties' details that has a region associated with possible agent.
-- modified: missed a XMLAGG so that it's one document, also added references to region, to fulfill requirement of more then one table.
SELECT XMLROOT(XMLELEMENT("PropertiesUn",
  XMLAGG(XMLELEMENT("PropertyTYPE",
   XMLATTRIBUTES(py.propertyType AS "Type"),
   XMLAGG(XMLELEMENT("Property",    
   XMLFOREST(py.builtYear AS "EstablishedYear", 
            py.address AS "Address", py.roid.city AS "City")))))), 
      VERSION '1.0') AS doc
FROM property py
WHERE py.roid IS NOT NULL
GROUP BY py.propertyType;

-- 4.XSU: find the sellers who have house before year 2018 and their price of property
--Ao: add rowtag and rowsettag following Joanne's advise.
OracleXML getXML \
-user "grp2/here4grp2" \
-conn "jdbc:oracle:thin:@sit.itec.yorku.ca:1521/studb10g" \
-rowTag "SaleContract" \
-rowsetTag "SaleContracts" \
"SELECT DISTINCT sc.sellerid.cname as sellerName, 
sc.sellerid.phoneNum as sellerPhone, sc.sellerid.emailAddress as sellerEmail, sc.sellerid.dateOwned as owningDate, 
sc.sellerid.cid as sellerID, sc.scid as saleContractID, sc.salePrice as propertyPrice
FROM saleContract sc WHERE sc.sellerid.dateOwned < DATE '2018-01-01'"


-- XQuery:
-- 5. calculate the average price of the all rented properties
xquery
let $agentC := doc("/public/group2m25/agentContract.xml")/AgentContracts/AgentContract
let $rentC := doc("/public/group2m25/rentContract.xml")/RentContracts/RentContract
let $rentedPrices := 
  for $ac in $agentC
  let $rc := $rentC[@rcid = $ac/rcoid/text()]
  where $ac/contractType = "rentContract"
  return $rc/rentPrice/text()
return format-number(avg($rentedPrices), "#.00")
/

-- 6. no one interests in the seventh property because of expensive, so its price is updated and return with property's information.
xquery
let $propery := doc("/public/group2m25/property.xml")/Properties
return
  copy $updatePrice := $propery  
  modify (  
    for $property in $updatePrice/Property
    where $property[@pid = "p07"] and $property/listing/listedPrice = 1750000.00
    return replace value of node $property/listing/listedPrice with 1400000.00  
  )
  return ($updatePrice/Property[@pid = "p07"],
    $updatePrice/Property[@pid = "p07"]/propertyType)
/


-- 7. find the buyer's ID who enrolled in real estate system after year 2017 and their info detail
-- modified: it's better to only display one element's value.
xquery
let $buy := doc("/public/group2m25/buyer.xml")/Buyers/Buyer
for $buyer in $buy
where xs:date($buyer/dateStarted) > xs:date("2018-01-01")  
return $buyer/@buyerID
/


