insert into region values(region_t('r001', 'Central', 'Ontario', 'Toronto'));
insert into region values(region_t('r002', 'West', 'British Columbia', 'Vancouver'));
insert into region values(region_t('r003', 'East', 'Quebec', 'Montreal'));
insert into region values(region_t('r004', 'Prairie', 'Alberta', 'Calgary'));

insert into listing values(listing_t('d011', '10-Oct-2024', '2010', '2695000', 4, 2, 7, 1, 2, 6, 0, '10-Feb-2025'));
insert into listing values(listing_t('d012', '5-Jan-2025', '2005', '1449000', 4, 2, 7, 1, 2, 1, 0, '10-Feb-2025'));
insert into listing values(listing_t('d013', '19-Nov-2024', '2021', '1240000', 4, 2, 7, 1, 2, 1, 0, '10-Feb-2025'));
insert into listing values(listing_t('d014', '3-Feb-2025', '1950', '798000', 4, 2, 7, 1, 2, 1, 0, '10-Feb-2025'));
insert into listing values(listing_t('d015', '01-Oct-2024', '1950', '586000', 4, 2, 7, 1, 2, 1, 0, '10-Feb-2025'));
insert into listing values(listing_t('d016', '08-Jan-2024', '1978', '1425000', 4, 2, 7, 1, 2, 1, 0, '10-Feb-2025'));

--solution fit current schema
insert into property values(property_t('d01', 
(select ref(r) from region r where r.rid = 'r001'), 
listing_t('d012', '5-Jan-2025', 2005, 1449000, 4, 2, 7, 1, 2, 1, 0, '10-Feb-2025'), 
'detached', 2010, '1 york lane', 'M1K2G3', 40, 104));

-- insertion format for property:
insert into property values(property_t('d02', (SELECT REF(r) FROM region r WHERE r.rid = 'r001'), listing_t('l012', DATE '2024-10-10', 2010, 2695000.00, 4, 2, 7, 1, 2, 1, 0, DATE '2025-10-02'), 'detached', 2010, '1 york lane', 'M1K2G3', 40.2, 104.1));

insert into property values(property_t('s02', 'r001', 'semidetached', '2005', '94 cook rd', 'M2K3G4', 24, 107));
insert into property values(property_t('c03', 'r001','condo', '2021', '47 university rd', 'M3K4G5', 27, 28));
insert into property values(property_t('s04', 'r004', 'semidetached', '1950', '57 alberta ave', 'M4K5G6', 17, 133));
insert into property values(property_t('s05', 'r004','semidetached', '1950', '19 alberta ave', 'M4K5G3', 20, 127));
insert into property values(property_t('d06', 'r002','detached', '1978', '25 ascot ave', 'M6K7G8', 30, 107));


insert into agent values(agent_t('a01', 'Eve Adams', '9876543210', 'eve@email.com', 2015, 'RealtyX', 'B1234567'));
insert into agent values(agent_t('a02', 'Frank Miller', '8765432109', 'frank@email.com', 2010, 'HomeFinders', 'B7654321'));
insert into agent values(agent_t('a03', 'Grace Hall', '7654321098', 'grace@email.com', 2018, 'SafeHomes', 'B2345678'));
insert into agent values(agent_t('a04', 'Harry King', '6543210987', 'harry@email.com', 2012, 'TopRealty', 'B8765432'));

-- insertion format for seller
insert into seller values(seller_t('c01', 'Alice Smith', '1234567890', 'alice@email.com', DATE '2020-06-15', empty_blob(), DATE '2001-04-15'));

insert into seller values(seller_t('c01'), customer_t('Alice Smith', '1234567890', 'alice@email.com', '2020-06-15'), true);
insert into seller values(seller_t('c02'), customer_t('Bob Johnson', '2345678901', 'bob@email.com', '2021-08-21'), false);
insert into seller values(seller_t('c03'), customer_t('Emma Green', '5678901234', 'emma@email.com', '2016-09-12'), true);
insert into seller values(seller_t('c04'), customer_t('Daniel Lee', '6789012345', 'daniel@email.com', '2017-12-03'), false);

-- insertion format for buyer
insert into buyer values(buyer_t('c05', 'Charlie Brown', '3456789012', 'charlie@email.com', DATE '2019-05-30', 250000.00));

insert into buyer values(buyer_t('c05'), customer_t('Charlie Brown', '3456789012', 'charlie@email.com', '2019-05-30'));
insert into buyer values(buyer_t('c06'), customer_t('Diana White', '4567890123', 'diana@email.com', '2018-11-10'));
insert into buyer values(buyer_t('c07'), customer_t('Lucas White', '1234509876', 'lucas@email.com', '2022-03-15'));
insert into buyer values(buyer_t('c08'), customer_t('Amelia Clark', '2345610987', 'amelia@email.com', '2021-09-05'));

-- insertion format for landlord
insert into landlord values(landlord_t('c09', 'Sophia Martin', '9012345678', 'sophia@email.com', DATE '2015-06-18', empty_blob(), DATE '2005-01-22'));

insert into landlord values(landlord_t('c09'), customer_t('Sophia Martin', '9012345678', 'sophia@email.com', '2015-06-18'), true);
insert into landlord values(landlord_t('c10'), customer_t('James Anderson', '0123456789', 'james@email.com', '2014-11-30'), false);
insert into landlord values(landlord_t('c11'), customer_t('Emily Davis', '3456723456', 'emily@email.com', '2013-05-25'), true);
insert into landlord values(landlord_t('c12'), customer_t('Michael Scott', '5678923456', 'michael@email.com', '2016-02-14'), false);

--  insertion format for tenant
insert into tenant values(tenant_t('c13', 'Lucas White', '1234509876', 'lucas@email.com', DATE '2022-03-15', 2200.00));

insert into tenant values(tenant_t('c13'), customer_t('Lucas White', '1234509876', 'lucas@email.com', '2022-03-15'));
insert into tenant values(tenant_t('c14'), customer_t('Amelia Clark', '2345610987', 'amelia@email.com', '2021-09-05'));
insert into tenant values(tenant_t('c15'), customer_t('Benjamin Harris', '3456789012', 'benjamin@email.com', '2020-01-10'));
insert into tenant values(tenant_t('c19'), customer_t('Emma Lewis', '4567890123', 'emma@email.com', '2019-04-20'));


