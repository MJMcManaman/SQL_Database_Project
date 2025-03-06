-- 1. Find the names of Tenants who rented properties of landlord James Bond with the help of agent Brett Fox.
SELECT t.cname AS tenantName FROM tenant t
JOIN rentContract rc ON DEREF(rc.tenantid).cid = t.cid
JOIN landlord ld ON ld.cid = DEREF(rc.landlordid).cid
JOIN agentContract ac ON DEREF(ac.rcoid).rcid = rc.rcid
JOIN agent a ON a.aid = DEREF(ac.aoid).aid
WHERE ld.cname = 'James Bond' AND a.aname = 'Brett Fox'; 

--Working
--2. Retrieve the time buyer named 'Diana White' spent searching for a property
SELECT b.cid, b.cname, b.timeSpentLooking() AS time_looking_buyer 
FROM buyer b WHERE b.cname = 'Diana White'; 

--3. Calculates total rental earnings for each landlord, list them from highest to lowest.
SELECT ld.cid AS landlord_id, ld.cname AS landlord_name, 
    SUM(rc.rentPrice * rc.rentLength) AS total_rent_earned
FROM landlord ld
JOIN rentContract rc ON rc.landlordid = REF(ld)
GROUP BY ld.cid, ld.cname
ORDER BY total_rent_earned DESC;

--Working
--4. Retrieve property IDs, addresses, and ages. If multiple properties have the same age, sort them by listing start date showing the most recent ones first.
SELECT p.pid, p.address, p.age() AS property_age, p.propertyDetail.listingStartDate AS listStartDate 
FROM property p ORDER BY VALUE(listStartDate);

--Working
--5. Retrieve property IDs with their calculated sizes (width × length) and sort them based on property size.
SELECT p.pid, p.propertySize() AS propertySize 
FROM property p ORDER BY VALUE (propertySize);
 
-- 6. Retrieves each agent's ID (aid) and name (aname), count the total number of contracts they are involved in, calculates the total commission earned, and sorts the results in descending order of commission value.
SELECT a.aid, a.aname, 
    COUNT(ac.acid) AS total_contracts,
    SUM(ac.commission()) AS total_commission
FROM agent a
LEFT JOIN agentContract ac ON ac.aoid = REF(a)
GROUP BY a.aid, a.aname
ORDER BY total_commission DESC;

--Working
--7. Finds customers (specifically sellers) who have owned their properties the longest.
SELECT s.cid, s.cname, s.timeOwned() AS years_owned
FROM seller s
WHERE s.dateOwned IS NOT NULL
ORDER BY years_owned DESC
FETCH FIRST 5 ROWS ONLY;

--Working
--8. Retrieve listing IDs, listing start dates, and the number of days properties have been listed to verify that the daysListed() function filters properties active for less than 60 days.
SELECT p.propertyDetail.lid, p.propertyDetail.listingStartDate, p.propertyDetail.daysListed() AS days_active 
FROM property p WHERE p.propertyDetail.daysListed()<60;

--Working
--9. Retrieve all region records and sort them by alphabetically.
SELECT * FROM region r ORDER BY VALUE(r) ;

--Working
--10. Retrieve all region record where the region name starts with ‘P’.
SELECT * FROM region WHERE regionName LIKE 'P%';

--Working
--11. Count the number of regions for each city by grouping based on the city.
SELECT city, COUNT(*) AS num_regions FROM region GROUP BY city; 

--Working but no join allowed
--12. Show how many property each agent has handled.
SELECT a.aid, a.aname, count(p.pid) AS properties_handled
FROM agent a
LEFT JOIN agentContract ac ON a.aid = DEREF(ac.aoid).aid
LEFT JOIN property p ON p.pid = DEREF(ac.poid).pid
GROUP BY a.aid, a.aname;

--13. Find the agent’s name and the property he/she can browse who’s agent ID is ‘a02’;
select a.aname, a.browseProperty() from agent a where a.aid = 'a02';

--14. Find property that Lucas White would prefer base on the price landlord offer on the property.
select t.propertyPreferred() from tenant t where t.cname = 'Lucas White';


--15. Find property that Lucas White would prefer base on the price landlord offer on the property.
select b.propertyPreferred() from buyer b WHERE b.cname = 'Sophia Martin';













