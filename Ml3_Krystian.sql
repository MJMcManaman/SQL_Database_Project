1. List the number of detached, semi-detatched and detatched homes in each region.

SELECT XMLROOT(
         XMLELEMENT("Properties",
            XMLAGG(
               XMLELEMENT("Region",
                  XMLATTRIBUTES(r.regionName AS "Region"),
                  XMLELEMENT("TotalProperties", COUNT(p.propertyType))
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
                             XMLFOREST(r.regionName AS "Region_type", l.listedPrice AS "ListedPrice")))
         ), VERSION '1.0'
         ) AS document
FROM listing l
WHERE l.roid.rid; 
ORDER BY l.listedPrice DESC;


                           
