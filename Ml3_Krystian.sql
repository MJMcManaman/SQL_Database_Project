1. List the number of detached, semi-detatched and detatched homes in each region.

SELECT XMLROOT(
         XMLELEMENT("Properties_Sold_By_Types",
            XMLAGG(
               XMLELEMENT("Property_Type",
                  XMLATTRIBUTES(ac.poid.propertyType AS "Type"),
                  XMLFOREST(COUNT(ac.poid.propertyType) AS "Number_of_Properties")
               )
            )
         ),
         VERSION '1.0'
       ) AS doc
FROM agentContract ac
GROUP BY ac.poid.propertyType;


2. List the number of detached, semi-detatched and detatched homes in each region.

         
SELECT XMLROOT(
         XMLELEMENT("Properties",
            XMLAGG(
               XMLELEMENT("Region",
                  XMLATTRIBUTES(r.regionName AS "Region"),
                  XMLFOREST(
                     COUNT(CASE WHEN p.propertyType = 'condo' THEN 1 END) AS "condo",
                     COUNT(CASE WHEN p.propertyType = 'semidetached' THEN 1 END) AS "semidetached",
                     COUNT(CASE WHEN p.propertyType = 'detatched' THEN 1 END) AS "detached"
                  )
               )
            )
         ), VERSION '1.0'
       ) AS document
  FROM property p, region r
  WHERE p.roid.rid = r.rid
  GROUP BY r.regionName;




2. List the price of each listing from greatest to least
         
SELECT XMLROOT(
         XMLELEMENT("RegionPrice",
            XMLAGG(
                  XMLELEMENT("Region",
                             XMLELEMENT("ID", l.lid),
                             XMLFOREST(r.regionName AS "Region_type", l.listedPrice AS "ListedPrice")))),
         VERSION '1.0'
         ) AS document
FROM listing l, region r
WHERE l.roid.rid 
ORDER BY listedPrice DESC;



3. 
SELECT XMLROOT(
         XMLELEMENT("BuyerWithProperty", 
           XMLAGG(
             XMLELEMENT("Buyer", 
               XMLFOREST(
                 b.cname AS "Name",
                 b.phoneNum AS "Phone")  
             )
           )
         ), 
         VERSION '1.0'
       ) AS document
FROM buyer b
WHERE b.cid IS NOT NULL;




4. 
SELECT XMLELEMENT(
    "Property_Sold_Price_in_Region",
    XMLATTRIBUTES(ac.poid.pid AS "Property_id"),
    XMLELEMENT("Price", ac.scoid.salePrice),
    XMLELEMENT("Age", ac.poid.age()),
    XMLELEMENT("Size", ac.poid.propertySize())
) AS document
FROM agentContract ac
WHERE ac.poid.roid.city = 'Halifax';


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
