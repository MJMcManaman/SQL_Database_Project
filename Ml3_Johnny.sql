-- xmlattributes
-- 1. List all properties sold in the "Halifax" region, 
-- including their property price, age and size. 
select xmlelement("Property_Sold_Price_in_Region",
	xmlattributes(ac.poid.pid as "Property_id"),
	xmlelement("Price", ac.scoid.salePrice),
	xmlelement("Age",ac.poid.age()),
	xmlelement("Size",ac.poid.propertySize())
)
as document 
from agentContract ac, property p, region r
where ac.poid.roid.rid = r.rid 
AND ac.scoid.salePrice IS NOT NULL
AND r.city ='Halifax'
GROUP BY ac.poid.pid, ac.scoid.salePrice, ac.poid.age(), ac.poid.propertySize();

-- xmlagg, group by
-- 2. list number of properties sold by types
-- show property type and sold number.
select xmlelement("Properties_Sold_By_Types",
  xmlagg(
    xmlelement("Property_Type",
      xmlattributes(ac.poid.propertyType as "Type"),
      xmlforest(count(ac.poid.propertyType) as "Number_of_Properties")
    )
    )
) as document
from agentContract ac
group by ac.poid.propertyType;

-- xmlforest
-- 3. list all properties sold by agents
-- including the agent's name, experience, and the properties they sold.
select xmlelement("Properties_Sold_By_Agent",
  xmlattributes(a.aid as "Agent_id"),
  xmlelement("Agent_Name", a.aname),
  xmlelement("Agent_Experience", a.yearOfExperience()),
    xmlelement("Property",
      xmlattributes(ac.poid.pid as "Property_id"),
      xmlforest(ac.poid.propertyType as "Type",
                ac.poid.address as "Address",
                ac.scoid.salePrice as "Sale_Price")
    )
  )
as document
from agentContract ac, agent a
where a.aid = ac.aoid.aid;

-- xmlroot
--4.list all tenant who didn't rent any property
select xmlroot(
  xmlelement("Tenant_Without_Rent",
    xmlagg(
      xmlelement("Tenant",
        xmlforest(t.cname as "Name",
                  t.phoneNum as "Phone_Number")
      )
    )
  ), version '1.0'
) as document
from tenant t
where t.cid not in (select rc.tenantid.cid from rentContract rc);


