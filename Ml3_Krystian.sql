1. List the number of detached, semi-detatched and detatched homes in each region.

  SELECT XMLROOT(XMLELEMENT("Properties", XMLAGG(XMLELEMENT("Region", XMLATTRIBUTES(r.regionName AS "Region", XMLFOREST(COUNT(p.propertyType = "condo" AS "Numberof Condos",
  p.propertyType = "semidetached" AS "Number of semidetached", p.propertyType = "detached" AS "Number of detached houses"))))))), VERSION '1.0') 
  AS document 
  FROM property p, region r  
