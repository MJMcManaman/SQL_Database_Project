-- 1. Find the names of Tenants who rented properties of landlord James Bond with the help of agent Brett Fox.
SELECT ac.rcoid.tenantid.cname AS tenantName FROM agentContract ac
WHERE ac.rcoid.landlordid.cname = 'James Bond' AND ac.aoid.aname = 'Brett Fox'; 

--2. Retrieve the time buyer named 'Diana White' spent searching for a property
SELECT b.cid, b.cname, b.timeSpentLooking() AS time_looking_buyer 
FROM buyer b WHERE b.cname = 'Diana White'; 

--3. Calculates total rental earnings for each landlord, list them from highest to lowest.
SELECT rc.landlordid.cid AS landlord_id, rc.landlordid.cname AS landlord_name, 
    SUM(rc.rentPrice * rc.rentLength) AS total_rent_earned
FROM rentContract rc
GROUP BY rc.landlordid.cid, rc.landlordid.cname
ORDER BY total_rent_earned DESC;

--4. Retrieve property IDs, addresses, and ages. If multiple properties have the same age, sort them by listing start date showing the most recent ones first.
SELECT p.pid, p.address, p.age() AS property_age, p.propertyDetail.listingStartDate AS listStartDate 
FROM property p ORDER BY VALUE(listStartDate);

--5. Retrieve property IDs with their calculated sizes (width × length) and sort them based on property size.
SELECT p.pid, p.propertySize() AS propertySize 
FROM property p ORDER BY VALUE (propertySize);

--6. Retrieves each agent's ID (aid) and name (aname), count the total number of contracts they are involved in, calculates the total commission earned, and sorts the results in descending order of commission value.
SELECT ac.aoid.aid, ac.aoid.aname, 
    COUNT(ac.acid) AS total_contracts,
    SUM(ac.commission()) AS total_commission
FROM agentContract ac
GROUP BY ac.aoid.aid, ac.aoid.aname
ORDER BY total_commission DESC;

--7. Finds customers (specifically sellers) who have owned their properties the longest.
SELECT s.cid, s.cname, s.timeOwned() AS years_owned
FROM seller s
WHERE s.dateOwned IS NOT NULL
ORDER BY years_owned DESC
FETCH FIRST 5 ROWS ONLY;

--8. Retrieve listing IDs, listing start dates, and the number of days properties have been listed to verify that the daysListed() function filters properties active for less than 60 days.
SELECT p.propertyDetail.lid, p.propertyDetail.listingStartDate, p.propertyDetail.daysListed() AS days_active 
FROM property p WHERE p.propertyDetail.daysListed()<60;

--9. Retrieve all region records and sort them by alphabetically.
SELECT * FROM region r ORDER BY VALUE(r) ;

--10. Retrieve all region record where the region name starts with ‘P’.
SELECT * FROM region WHERE regionName LIKE 'P%';

--11. Count the number of regions for each city by grouping based on the city.
SELECT city, COUNT(*) AS num_regions FROM region GROUP BY city; 

--12. Show how many property each agent has handled.
SELECT ac.aoid.aid, ac.aoid.aname, count(ac.poid) AS properties_handled
FROM agentContract ac
GROUP BY ac.aoid.aid, ac.aoid.aname;

--13. Find the agent’s name and the property he/she can browse who’s agent ID is ‘a02’;
select a.aname, a.browseProperty() from agent a where a.aid = 'a02';

--14. Find property that James Sullivan would prefer base on the price landlord offer on the property.
select t.cid, t.propertyPreferred() from tenant t where t.cname = 'James Sullivan';


--15. Find property that Sophia Martin would prefer base on the price buyer offer on the property.
select b.cid, b.propertyPreferred() from buyer b where b.cname = 'Sophia Martin';
