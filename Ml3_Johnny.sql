-- xmlattributes
-- 1. List all properties sold in the "Halifax" region, 
-- including their property price, age and size. 
select xmlroot( 
  xmlelement("Property_Sold_Price_in_Region",
    xmlattributes(ac.poid.pid as "Property_id"),
    xmlelement("Price", ac.scoid.salePrice),
    xmlelement("Age",ac.poid.age()),
    xmlelement("Size",ac.poid.propertySize())
  ), version '1.0'
)as document 
from agentContract ac
where ac.poid.roid.city ='Halifax';

-- xmlagg, group by
-- 2. list number of properties sold by types
-- show property type and sold number.
select xmlroot(
  xmlelement("Properties_Sold_By_Types",
    xmlagg(
      xmlelement("Property_Type",
        xmlattributes(ac.poid.propertyType as "Type"),
        xmlforest(count(ac.poid.propertyType) as "Number_of_Properties")
      )
      )
  ), version '1.0'
)as document
from agentContract ac
group by ac.poid.propertyType;

-- xmlforest
-- 3. list all properties sold by agents
-- including the agent's name, experience, and the properties they sold.
select xmlroot(
xmlelement("Properties_Sold_By_Agent",
  xmlattributes(ac.aoid.aid as "Agent_id"),
  xmlelement("Agent_Name", ac.aoid.aname),
  xmlelement("Agent_Experience", ac.aoid.yearOfExperience()),
    xmlelement("Property",
      xmlattributes(ac.poid.pid as "Property_id"),
      xmlforest(ac.poid.propertyType as "Type",
                ac.poid.address as "Address",
                ac.scoid.salePrice as "Sale_Price")
    )
  ), version '1.0'
)as document
from agentContract ac; 

-- xmlroot
--4. list all tenant who didn't rent any property
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

-- XSU 
--5. List all property listed for sale (which have a sale contract)
OracleXML getXML -user "grp2/here4grp2" -conn "jdbc:oracle:thin:@sit.itec.yorku.ca:1521/studb10g" "select distinct ac.poid.pid as Property_ID, ac.poid.address as Property_Address, ac.poid.propertyType as Property_Type, ac.poid.propertySize() as Property_Size, ac.scoid.salePrice as Sale_Price from agentContract ac where ac.scoid is not null"

-- Xquery 
--6 List the number of rent contracts signed by under each agent
-- using more than one XML file from Oracle XML DB repository
xquery
let $a := doc('/public/mj/agent.xml')
for $agent in $a/Agents/Agent
let $ac := doc("/public/mj/agentContract.xml")
let $rentedContracts := $ac/AgentContracts/AgentContract[agentID = $agent/@agentID and contractType = 'rentContract']
return <Agent>
  {$agent/agentName}
  <TotalRented>{count($rentedContracts)}</TotalRented>
</Agent>
/

--7 List the agent singed contract in 2025
--return values of XML elements without XML tags. 
--qualification conditions specified on attribute and element
xquery
let $a := doc('/public/mj/agent.xml')
for $agent in $a/Agents/Agent
let $ac := doc("/public/mj/agentContract.xml")
where $ac/AgentContracts/AgentContract/agentID = $agent/@agentID 
and $ac/AgentContracts/AgentContract/signatureTime >= '2025-01-01'
return $agent/agentName/text()
/

--8 find prperties that's larger than 1000 square feet
--qualification conditions specified on element
xquery
let $p := doc('/public/mj/property.xml')
for $property in $p/Properties/Property
where $property/propertyWidth * $property/propertyLength > 1000
return <Property>
  <PropertyID>{$property/@pid}</PropertyID>
  {$property/address}
  {$property/listing/listedPrice}
  <Size>{xs:integer($property/propertyWidth * $property/propertyLength)}</Size>
</Property>
/


