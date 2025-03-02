-- for displaying everything in properties
SELECT 
    p.propertyDetail.lid AS listing_id, 
    p.propertyDetail.pid AS property_id, 
    p.propertyDetail.listingStartDate, 
    p.propertyDetail.builtYear, 
    p.propertyDetail.listedPrice, 
    p.propertyDetail.washroomNum, 
    p.propertyDetail.livingroomNum, 
    p.propertyDetail.bedroomNum, 
    p.propertyDetail.kitchenNum, 
    p.propertyDetail.parkingSpace, 
    p.propertyDetail.elevator, 
    p.propertyDetail.openHouse
FROM property p;

---------------------------------------------------
-- if you wanna display listing of a property:
select p.propertyDetail.attributeRequire from property p;
-- example:
select p.propertyDetail.openHouse from property p;
-- more specifically:
select p.propertyDetail.openHouse from property p  where p.pid = 'p02';

---------------------------------------------------

-- selecting region id from property
select p.roid.rid from property p where p.pid = 'p02'

-- shown region in property
select p.roid.rid, p.roid.regionName, p.roid.province, p.roid.city, p.propertyDetail.lid, p.propertyDetail.listingStartDate, p.propertyDetail.listedPrice, p.propertyDetail.washroomNum, p.propertyDetail.livingroomNum, p.propertyDetail.bedroomNum, p.propertyDetail.balcony, p.propertyDetail.kitchenNum, p.propertyDetail.parkingSpace, p.propertyDetail.elevator, p.propertyDetail.openHouse, p.propertyType, p.builtYear, p.address, p.postalCode, p.propertyWidth, p.propertyLength
from property p;
