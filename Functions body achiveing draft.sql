drop table customer;
drop type customer_t;
-drop ... b4 required type body
-using CONSTRAINT to determine primary keys
    

create or replace type body customer_t as 
  map member function timeSpentLooking return int
	is begin 
	return trunc(sysdate) - dataStarted;
  end timeSpentLooking;
  member function priceFluctuation return double
	is begin
	return priceFluctuation
  end priceFluction;
end;

create or replace type body buyer_t as
  member function propertyRequirement return integer 
	is pricePreference, priceFluctuation
	begin
	select propertyID 
    from SaleContract_t
    where (ABS(pricePreference - salePrice) <= priceFluctuation) order by ASC;
	end propertyRequirement;
  end;

create or replace type body seller_t as
  member function timeOwned return int
	is begin 
	return dataOwned
  end timeOwned;
end;

create or replace type body tenant_t as
  member function propertyRequirement return integer  
	is pricePreference, priceFluctuation
	begin
	select propertyID 
    from RentContract_t
    where (ABS(pricePreference - rentPrice) <= priceFluctuation) order by ASC;
	end propertyRequirement;
  end;

create or replace type body landlord_t as
  member function timeOwned return int
	is begin 
	return dataOwned
  end timeOwned;
end;
/


create or replace type body agent_t as
  map member function yearOfExperience return int
	is begin
	return extract(year from sysdate) - yearStarted
  end yearOfExperience;
  member function browseProperty return char
	is begin
	select *
	from property_t
  end browseProperty;
end;

create or replace type body agentContract_t as
  member function commission return double precision
	is begin 
	return commissionPercentage
  end commission;
end;
/


create or replace type body property_t as 
  map member function age return int
	is begin
	return extract(year from sysdate) - builtYear
  end;
  member function propertySize(desiredSize number) return number 
	is actualSize number
	begin
	actualSize = propertyWidth * propertyLength
	if desiredSize < actualSize  AND actualSize - desiredSzie < 60 then
	return 1
	else
	return 0
  end if;
end;
/


create or replace type body region_t as
  member function regionDisplay return varchar2
	is begin
	return city || ', ' || regionName;
  end regionDisplay;
end;
/


create or replace type body listing_t as
  map member function daysListed return int
	is begin
	return trunc(sysdate) - listingStartDate;
  end daysListed;
end;
/
