1. List the number of detached, semi-detatched and detatched homes in each region.

  SELECT XMLROOT(XMLELEMENT("Properties", XMLAGG(XMLELEMENT("Region", XMLATTRIBUTES(r.regionName AS "Region", XMLFOREST(p.propertyType = "Condo" AS "Number of Condos",
  p.propertyType = "Semi
