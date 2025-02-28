insert into region values(region_t('r001', 'Central', 'Ontario', 'Toronto'));
insert into region values(region_t('r002', 'West', 'British Columbia', 'Vancouver'));
insert into region values(region_t('r003', 'East', 'Quebec', 'Montreal'));
insert into region values(region_t('r004', 'Prairie', 'Alberta', 'Calgary'));

--------------------------------------------------------------------------------------

--- insertion format for property:
insert into property values(property_t('d01', 
(SELECT REF(r) FROM region r WHERE r.rid = 'r001'), 
listing_t('l001', DATE '2024-10-10', 2695000.00, 4, 2, 7, 1, 2, 1, 0, DATE '2025-01-02'), 
'detached', 2010, '1 york lane', 'M1K2G3', 40.2, 104.1));
insert into property values(property_t('s02', (SELECT REF(r) FROM region r WHERE r.rid = 'r001'), listing_t('l002', DATE '2025-01-05', 1449000.00, 1, 1, 2, 1, 2, 2, 0, DATE '2025-02-01'), 'semidetached', 2005, '94 cook rd', 'M2K3G4', 24.5, 107.0));
insert into property values(property_t('c03', (SELECT REF(r) FROM region r WHERE r.rid = 'r004'), listing_t('l003', DATE '2024-11-19', 1240000.00, 3, 1, 5, 3, 1, 4, 0, DATE '2025-02-21'), 'condo', 2021, '47 university rd', 'M3K4G5', 27.2, 28.5));
insert into property values(property_t('s04', (SELECT REF(r) FROM region r WHERE r.rid = 'r005'), listing_t('l004', DATE '2024-10-01', 798000.00, 2, 2, 3, 0, 1, 2, 1, DATE '2025-03-02'), 'semidetached', 1960, '57 alberta ave', 'M4K5G6', 17.4, 133.6));
insert into property values(property_t('s05', (SELECT REF(r) FROM region r WHERE r.rid = 'r005'), listing_t('l005', DATE '2024-10-05', 1425000.00, 4, 2, 6, 4, 2, 3, 0, DATE '2025-02-12'), 'detached', 1978, '25 ascot ave', 'M6K7G8', 30.0, 107.0));

--------------------------------------------------------------------------------------

insert into agent values(agent_t('a01', 'Eve Adams', '9876543210', 'eve@email.com', 2015, 'RealtyX', 'B1234567'));
insert into agent values(agent_t('a02', 'Frank Miller', '8765432109', 'frank@email.com', 2010, 'HomeFinder', 'B7654321'));
insert into agent values(agent_t('a03', 'Grace Hall', '7654321098', 'grace@email.com', 2018, 'SafeHomes', 'B2345678'));
insert into agent values(agent_t('a04', 'Harry King', '6543210987', 'harry@email.com', 2012, 'TopRealty', 'B8765432'));

--------------------------------------------------------------------------------------

insert into seller values(seller_t('c01', 'Alice Smith', '1234567890', 'alice@email.com', DATE '2020-06-15', 1, DATE '2001-04-15'));
insert into seller values(seller_t('c02', 'Bob Johnson', '2345678901', 'bob@email.com', DATE '2021-08-21', 1, DATE '2021-08-21'));
insert into seller values(seller_t('c03', 'Alice Smith', '1234567890', 'alice@email.com', DATE '2020-06-15', 0, DATE '2016-09-12'));
insert into seller values(seller_t('c04', 'Alice Smith', '1234567890', 'alice@email.com', DATE '2020-06-15', 0, DATE '2017-12-03'));

--------------------------------------------------------------------------------------

insert into buyer values(buyer_t('c05', 'Charlie Brown', '3456789012', 'charlie@email.com', DATE '2019-05-30', 250000.00, 0.11));
insert into buyer values(buyer_t('c06', 'Diana White', '4567890123', 'diana@email.com', DATE '2018-11-10', 340000.00, 0.09));
insert into buyer values(buyer_t('c07', 'Lucas White', '1234509876', 'lucas@email.com', '2022-03-15', 700000.00, 0.08));
insert into buyer values(buyer_t('c08', 'Amelia Clark', '2345610987', 'amelia@email.com', 225000.00, 0.11));

--------------------------------------------------------------------------------------

insert into landlord values(landlord_t('c09', 'Sophia Martin', '9012345678', 'sophia@email.com', DATE '2015-06-18', 1, DATE '2005-01-22'));
insert into landlord values(landlord_t('c10', 'James Anderson', '0123456789', 'james@email.com', DATE '2014-11-30', 0, DATE '2010-10-28'));
insert into landlord values(landlord_t('c11', 'Emily Davis', '3456723456', 'emily@email.com', DATE '2013-05-25', 1, DATE '2002-11-02'));
insert into landlord values(landlord_t('c12', 'Michael Scott', '5678923456', 'michael@email.com', '2016-02-14', 0, DATE '2014-06-20'));

--------------------------------------------------------------------------------------

insert into tenant values(tenant_t('c13', 'Lucas White', '1234509876', 'lucas@email.com', DATE '2022-03-15', 2200.00, 0.15));
insert into tenant values(tenant_t('c14', 'Amelia Clark', '2345610987', 'amelia@email.com', DATE '2021-09-05', 3100.00, 0.10));
insert into tenant values(tenant_t('c15', 'Benjamin Harris', '3456789012', 'benjamin@email.com', DATE '2020-01-10', 4100.00, 0.07));
insert into tenant values(tenant_t('c19', 'Emma Lewis', '4567890123', 'emma@email.com', DATE '2019-04-20', 1500.00, 0.15));


