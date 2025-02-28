-- for displaying properties
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
