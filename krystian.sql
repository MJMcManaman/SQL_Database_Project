Query 1: Verify if timeSpentLooking() works for customer_t.

SELECT c.cid, c.name, TREAT(VALUE(c) AS customer_t).timeSpentLooking() AS time_looking FROM customer c;

Query 2: 

SELECT b.cid, b.cname, TREAT(VALUE(b) AS buyer_t).timeSpentLooking() AS time_looking_buyer FROM buyer b;


SELECT t.cid, t.cname, TREAT(VALUE(t) AS tenant_t).timeSpentLooking() AS time_looking_tenant

FROM tenant t;

Formulate a query demonstrating that the MAP method declared in the corresponding abstract data type works. You are to use ORDER BY VALUE(...) clause.


Using ORDER BY VALUE (p) on the MAP method (age), it orders properties by age (newer first). 

Query 3 :  
SELECT p.pid, p.address, p.age() AS property_age FROM property p ORDER BY VALUE(p);



Since we have two properties (p11 and p02) with same age, I wanted to set a secondary ordering criterion using listingStartDate to have them sorted by descending order. 
(ie., SELECT p.pid, p.address, p.age() AS property_age, p.propertyDetail.listingStartDate FROM property p ORDER BY VALUE(p), p.propertyDetail.listingStartDate; ) 
However, this query returned with an error message that the type body Property_t is missing. 
I could recreate the type body, but for now I’d not make any changes to the file. 

Query 4: Ordering properties by property size

SELECT p.pid, (p.propertyWidth * p.propertyLength) AS propertySize 
FROM property p
ORDER BY p.propertySize();

Query 5: 

SELECT ac.acid, ac.aoid, ac.commission() AS commission_value 
FROM agentContract ac 
ORDER BY ac.commission;

Query 6: 

SELECT ac.acid, ac.aoid, ac.commission() AS commission_value 
FROM agentContract 
ac ORDER BY ac.commission() DESC FETCH FIRST 3 ROWS ONLY;
