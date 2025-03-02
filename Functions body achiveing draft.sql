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

-- MODIFIED (Michelle): didn't add "priceFluctuation" in the superclass, since it's not technically overriding it
CREATE OR REPLACE TYPE BODY customer_t AS 
  MAP MEMBER FUNCTION timeSpentLooking RETURN INT IS 
  BEGIN 
    RETURN CASE 
             WHEN dataStarted IS NOT NULL THEN TRUNC(SYSDATE)
             ELSE 0
           END;
  END timeSpentLooking;
  
  MEMBER FUNCTION timeOwned RETURN INT IS
  BEGIN
    RETURN 0;
  END timeOwned;
END;
/
----------------------------------------------------------------------------------------------------------------
create or replace type body buyer_t as
  member function propertyRequirement return integer 
	is pricePreference, priceFluctuation
	begin
	select propertyID 
    from SaleContract_t
    where (ABS(pricePreference - salePrice) <= priceFluctuation) order by ASC;
	end propertyRequirement;
  end;

-- MODIFIED:
CREATE OR REPLACE TYPE BODY buyer_t AS
  MEMBER FUNCTION propertyRequirement RETURN INTEGER IS
    v_propertyID SaleContract_t.propertyID%TYPE;
  BEGIN
    -- Fetch a single propertyID based on the condition
    SELECT propertyID
    INTO v_propertyID
    FROM SaleContract_t
    WHERE ABS(pricePreference - salePrice) <= priceFluctuation
    ORDER BY salePrice ASC
    FETCH FIRST 1 ROW ONLY;
    
    RETURN v_propertyID;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN NULL; 
    WHEN TOO_MANY_ROWS THEN
      RETURN NULL;
  END propertyRequirement;
END;
/

----------------------------------------------------------------------------------------------------------------

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
