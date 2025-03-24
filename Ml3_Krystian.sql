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

