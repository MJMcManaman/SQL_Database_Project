
-- modify so we don't get marks deducted:
-- List all property's details, mostly concerned about the number of rooms and parking space.
1. 

SELECT XMLROOT(XMLELEMENT("Properties_Sold",
 XMLAGG(XMLELEMENT("Properties",
   XMLATTRIBUTES(ac.poid.pid AS "PID"),
     XMLFOREST(ac.poid.propertyType AS "Property_Type",
         ac.poid.propertyDetail.livingroomNum AS "Number_of_LivingRoom",
         ac.poid.propertyDetail.washroomNum AS "Number_of_WashRoom",
         ac.poid.propertyDetail.bedroomNum AS "Number_of_BedRoom",
         ac.poid.propertyDetail.elevator AS "Number_of_Elevator")))),
VERSION '1.0') AS doc
FROM agentContract ac WHERE ac.scoid IS NOT NULL;




-- fixed:
-- problem: references was not introduced correctly.

-- 2. List the number of detached, semi-detached and detached homes in each region.
SELECT XMLROOT(XMLELEMENT("Properties",
 XMLAGG(XMLELEMENT("Region",
   XMLATTRIBUTES(p.roid.regionName AS "Region"),
   XMLFOREST(
     COUNT(CASE WHEN p.propertyType = 'condo' THEN 1 END) AS "condo",
     COUNT(CASE WHEN p.propertyType = 'semidetached' THEN 1 END) AS "semidetached",
     COUNT(CASE WHEN p.propertyType = 'detached' THEN 1 END) AS "detached")))), VERSION '1.0'
) AS document
FROM property p GROUP BY p.roid.regionName;





-- 3. List the price of each listing from greatest to least
-- fixed:
-- problem: ORDER BY should be GROUP BY? I'm not sure about why though; DESC isn't allowed in XML queries; 
-- references was not introduced correctly, usage of XMLAGG was incorrectly.
SELECT XMLROOT(XMLELEMENT("Properties",
  XMLAGG(XMLELEMENT("RegionPrice",
    XMLAGG(XMLELEMENT("Region",
    XMLELEMENT("ID", p.propertyDetail.lid),
    XMLFOREST(p.roid.regionName AS "Region_type", 
              p.propertyDetail.listedPrice AS "ListedPrice")))))),
         VERSION '1.0') AS document
FROM property p GROUP BY p.propertyDetail.listedPrice;




--4. List all buyers that have bought a property
-- fixed:
-- small problem: because you are trying to list all the buyers that has a property,
-- we should be referencing the buyer through the saleContract. Unless you wanted to list
-- all sellers with a property, then we don't really need to go through saleContract.
SELECT XMLROOT(
         XMLELEMENT("BuyerWithProperty", 
           XMLAGG(
             XMLELEMENT("Buyer", 
               XMLFOREST(
                 sc.buyerid.cname AS "Name",
                 sc.buyerid.phoneNum AS "Phone")  
             )
           )
         ), 
         VERSION '1.0'
       ) AS document
FROM saleContract sc
WHERE sc.buyerid.cid IS NOT NULL;

-----------------------------------------------------------------------------------------------------------------------------------------
-- (since we only need 3 xml queries for question 2, for the rest, I didn't double check, you can still use these query ideas
-- to create XSU SQL query for question 3 and Xqueries for question 5).
-----------------------------------
--5. XSU
OracleXML getXML \
-user "grp2/here4grp2" \
-conn "jdbc:oracle:thin:@sit.itec.yorku.ca:1521/studb10g" \
-rowTag SaleContractInfo \
-rowsetTag AllSaleContract \
"select distinct ac.scoid.scid as SCID, ac.scoid.buyerid.cname as Buyer_Name, 
 ac.scoid.salePrice as Sale_Price, ac.poid.address as property_address, 
 ac.scoid.signedTime as Signed_Date from agentContract ac where ac.scoid is not null"



-- 6.
xquery
         let $p := doc("/public/group2m25/property.xml")
         for $property in $p/Properties/Property
         where $property/address/text()
         return $property/address/text()
         /


--7. 
xquery
         let $t := doc("/public/group2m25/tenant.xml")
         let $rc := doc("/public/group2m25/rentContract.xml")
         for $tenant in $t/Tenants/Tenant, 
         $rentContract in $rc/RentContracts/RentContract
         where $tenant/@tenantID = $rentContract/tenantID/text()
         return 
         <TenantRentInfo>
         <tenantName>{$tenant/tenantName/text()}</tenantName>
         <contractID>{$rentContract/@rcid}</contractID>
         </TenantRentInfo>
         /

--8.
xquery
         let $b := doc("/public/group2m25/buyer.xml")
         for $c in $b/Buyers/Buyer
         where $c/pricePreferred > "200000"
         return $c
         / 



--- EXTRA -------------------------------------------------------------------------        
3. 

SELECT XMLROOT(XMLELEMENT("Contracts", 
         XMLELEMENT("Sale Contract", 
         XMLAGG(XMLELEMENT("Contract Details",
                  XMLATTRIBUTES(ac.scoid.scid AS "SCID"),
         XMLFOREST(ac.scoid.buyerid.cname AS "Buyer Name", 
         ac.scoid.sellerid.cname AS "Seller Name", 
         ac.scoid.salePrice AS "Sale Price", 
         ac.poid.address AS "Property Address",
         ac.scoid.signedTime AS "Signed Date"))))), version '1.0')
         AS document
         FROM agentContract ac 



-- 6.
xquery
         let $t := doc("/public/mj/tenant.xml")
         let $rc := doc("/public/mj/rentContract.xml")
         for $tenant in $t/Tenants/Tenant, 
         $rentContract in $rc/RentContracts/RentContract
         where $tenant/@tenantID = $rentContract/tenantID/text()
         return 
         <TenantRentInfo>
         <tenantName>{$tenant/tenantName/text()}</tenantName>
         <tenantID>{$rentContract/@rcid}</contractID>
         </Tenant

--7. 
xquery
          let $p := doc('/public/mj/property.xml')
          for $property in $p/Properties/Property
          where $property/salePrice
          return salePrice
          /

          xquery
let $b := doc("/public/mj/buyer.xml")/Buyers/Buyer
for $buyer in $buy
where xs:date($buyer/dateStarted) > xs:date("2018-01-01")  
return $buyer/@buyerID
/

-- 5. 
--SELECT XMLELEMENT(
  --  "Property_Sold_Price_in_Region",
   -- XMLATTRIBUTES(ac.poid.pid AS "Property_id"),
   -- XMLELEMENT("Price", ac.scoid.salePrice),
   -- XMLELEMENT("Age", ac.poid.age()),
   -- XMLELEMENT("Size", ac.poid.propertySize())
--) AS document
--FROM agentContract ac
--WHERE ac.poid.roid.city = 'Halifax';
