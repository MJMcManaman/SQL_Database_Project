insert into region values(region_t('r01', 'Central', 'Ontario', 'Toronto'));
insert into region values(region_t('r02', 'West', 'British Columbia', 'Vancouver'));
insert into region values(region_t('r03', 'East', 'Quebec', 'Montreal'));
insert into region values(region_t('r04', 'Prairie', 'Alberta', 'Calgary'));
insert into region values(region_t('r05', 'Atlantic', 'Nova Scotia', 'Halifax'));

--------------------------------------------------------------------------------------

--- insertion format for property:
insert into property values(property_t('d01', (SELECT REF(r) FROM region r WHERE r.rid = 'r01'), listing_t('l01', DATE '2024-10-10', 2695000.00, 4, 2, 7, 1, 2, 1, 0, DATE '2025-01-02'), 'detached', 2010, '1 york lane', 'M1K2G3', 40.2, 104.1));
insert into property values(property_t('p02', (SELECT REF(r) FROM region r WHERE r.rid = 'r01'), listing_t('l02', DATE '2025-01-05', 1449000.00, 1, 1, 2, 1, 2, 2, 0, DATE '2025-02-01'), 'semidetached', 2005, '94 cook rd', 'M2K3G4', 24.5, 107.0));
insert into property values(property_t('p03', (SELECT REF(r) FROM region r WHERE r.rid = 'r04'), listing_t('l03', DATE '2024-11-19', 1240000.00, 3, 1, 5, 3, 1, 4, 0, DATE '2025-02-21'), 'condo', 2021, '47 university rd', 'M3K4G5', 27.2, 28.5));
insert into property values(property_t('p04', (SELECT REF(r) FROM region r WHERE r.rid = 'r03'), listing_t('l04', DATE '2024-10-01', 798000.00, 2, 2, 3, 0, 1, 2, 1, DATE '2025-03-02'), 'semidetached', 1960, '57 alberta ave', 'M4K5G6', 17.4, 133.6));
insert into property values(property_t('p05', (SELECT REF(r) FROM region r WHERE r.rid = 'r05'), listing_t('l05', DATE '2024-10-05', 1425000.00, 4, 2, 6, 4, 2, 3, 0, DATE '2025-02-12'), 'detached', 1978, '25 ascot ave', 'M6K7G8', 30.0, 107.0));
insert into property values(property_t('p06', (SELECT REF(r) FROM region r WHERE r.rid = 'r02'), listing_t('l06', DATE '2024-12-15', 950000.00, 3, 1, 4, 2, 1, 1, 0, DATE '2025-03-10'), 'condo', 2015, '12 pine st', 'M7K8G9', 20.0, 90.0));
insert into property values(property_t('p07', (SELECT REF(r) FROM region r WHERE r.rid = 'r03'), listing_t('l07', DATE '2025-01-20', 1750000.00, 5, 3, 8, 3, 2, 2, 1, DATE '2025-04-15'), 'detached', 2000, '34 maple ave', 'M8K9G0', 50.0, 150.0));
insert into property values(property_t('p08', (SELECT REF(r) FROM region r WHERE r.rid = 'r04'), listing_t('l08', DATE '2024-11-25', 1200000.00, 2, 1, 3, 1, 1, 1, 0, DATE '2025-02-20'), 'semidetached', 1995, '56 oak st', 'M9K0G1', 25.0, 80.0));
insert into property values(property_t('p09', (SELECT REF(r) FROM region r WHERE r.rid = 'r05'), listing_t('l09', DATE '2024-12-05', 1350000.00, 4, 2, 6, 2, 2, 2, 0, DATE '2025-03-01'), 'detached', 1985, '78 birch rd', 'M0K1G2', 35.0, 110.0));
insert into property values(property_t('p10', (SELECT REF(r) FROM region r WHERE r.rid = 'r01'), listing_t('l10', DATE '2025-01-10', 850000.00, 3, 1, 4, 1, 1, 1, 0, DATE '2025-04-05'), 'condo', 2018, '90 cedar ave', 'M1K2G3', 22.0, 95.0));
insert into property values(property_t('p11', (SELECT REF(r) FROM region r WHERE r.rid = 'r02'), listing_t('l11', DATE '2024-12-20', 1600000.00, 5, 3, 7, 3, 2, 2, 1, DATE '2025-03-15'), 'detached', 2005, '23 elm st', 'M2K3G4', 45.0, 140.0));
insert into property values(property_t('p12', (SELECT REF(r) FROM region r WHERE r.rid = 'r03'), listing_t('l12', DATE '2025-01-15', 1100000.00, 2, 1, 3, 1, 1, 1, 0, DATE '2025-04-10'), 'semidetached', 1990, '67 spruce rd', 'M3K4G5', 28.0, 85.0));

--------------------------------------------------------------------------------------

insert into agent values(agent_t('a01', 'Eve Adams', '9876543210', 'eve@email.com', 2015, 'RealtyX', 'B1234567'));
insert into agent values(agent_t('a02', 'Frank Miller', '8765432109', 'frank@email.com', 2010, 'HomeFinder', 'B7654321'));
insert into agent values(agent_t('a03', 'Grace Hall', '7654321098', 'grace@email.com', 2018, 'SafeHomes', 'B2345678'));
insert into agent values(agent_t('a04', 'Harry King', '6543210987', 'harry@email.com', 2012, 'TopRealty', 'B8765432'));

--------------------------------------------------------------------------------------

insert into seller values(seller_t('c01', 'Alice Smith', '1234567890', 'alice@email.com', DATE '2020-06-15', 1, DATE '2001-04-15'));
insert into seller values(seller_t('c02', 'Bob Johnson', '2345678901', 'bob@email.com', DATE '2021-08-21', 1, DATE '2014-02-12'));
insert into seller values(seller_t('c03', 'John Doe', '3456789012', 'john@email.com', DATE '2019-03-22', 1, DATE '2018-07-19'));
insert into seller values(seller_t('c04', 'David Brown', '4567890123', 'david@email.com', DATE '2022-01-10', 0, DATE '2018-05-14'));
insert into seller values(seller_t('c20', 'Karen Taylor', '5678901234', 'karen@email.com', DATE '2023-07-12', 1, DATE '2016-09-23'));
insert into seller values(seller_t('c21', 'Paul Walker', '6789012345', 'paul@email.com', DATE '2022-11-05', 0, DATE '2019-03-30'));

--------------------------------------------------------------------------------------

insert into buyer values(buyer_t('c05', 'Charlie Brown', '3456789012', 'charlie@email.com', DATE '2019-05-30', 250000.00, 0.11));
insert into buyer values(buyer_t('c06', 'Diana White', '4567890123', 'diana@email.com', DATE '2018-11-10', 340000.00, 0.09));
insert into buyer values(buyer_t('c07', 'Lucas White', '1234509876', 'lucas@email.com', DATE '2022-03-15', 700000.00, 0.08));
insert into buyer values(buyer_t('c08', 'Amelia Clark', '2345610987', 'amelia@email.com', DATE '2021-09-05', 225000.00, 0.11));
insert into buyer values(buyer_t('c22', 'Sophia Martin', '9012345678', 'sophia@email.com', DATE '2015-06-18', 500000.00, 0.12));
insert into buyer values(buyer_t('c23', 'James Anderson', '0123456789', 'james@email.com', DATE '2014-11-30', 600000.00, 0.10));

--------------------------------------------------------------------------------------

insert into landlord values(landlord_t('c09', 'Sophia Martin', '9012345678', 'sophia@email.com', DATE '2015-06-18', 1, DATE '2005-01-22'));
insert into landlord values(landlord_t('c10', 'James Anderson', '0123456789', 'james@email.com', DATE '2014-11-30', 0, DATE '2010-10-28'));
insert into landlord values(landlord_t('c11', 'Emily Davis', '3456723456', 'emily@email.com', DATE '2013-05-25', 1, DATE '2002-11-02'));
insert into landlord values(landlord_t('c12', 'Michael Scott', '5678923456', 'michael@email.com', DATE '2016-02-14', 0, DATE '2014-06-20'));
insert into landlord values(landlord_t('c24', 'Lucas White', '1234509876', 'lucas@email.com', DATE '2022-03-15', 1, DATE '2018-03-15'));
insert into landlord values(landlord_t('c25', 'Amelia Clark', '2345610987', 'amelia@email.com', DATE '2021-09-05', 0, DATE '2016-09-05'));
--------------------------------------------------------------------------------------

insert into tenant values(tenant_t('c13', 'Lucas White', '1234509876', 'lucas@email.com', DATE '2022-03-15', 2200.00, 0.15));
insert into tenant values(tenant_t('c14', 'Amelia Clark', '2345610987', 'amelia@email.com', DATE '2021-09-05', 3100.00, 0.10));
insert into tenant values(tenant_t('c15', 'Benjamin Harris', '3456789012', 'benjamin@email.com', DATE '2020-01-10', 4100.00, 0.07));
insert into tenant values(tenant_t('c19', 'Emma Lewis', '4567890123', 'emma@email.com', DATE '2019-04-20', 1500.00, 0.15));
insert into tenant values(tenant_t('c26', 'Oliver Brown', '5678901234', 'oliver@email.com', DATE '2023-08-15', 2800.00, 0.12));
insert into tenant values(tenant_t('c27', 'Mia Johnson', '6789012345', 'mia@email.com', DATE '2022-12-01', 3200.00, 0.08));

--------------------------------------------------------------------------------------

insert into rentContract values(rentContract_t('rc01', (SELECT REF(l) FROM landlord l WHERE l.cid = 'c09'), (SELECT REF(a) FROM agent a WHERE a.aid = 'a01'), (SELECT REF(t) FROM tenant t WHERE t.cid = 'c13'), 3000, DATE '2022-03-15', 12));
insert into rentContract values(rentContract_t('rc02', (SELECT REF(l) FROM landlord l WHERE l.cid = 'c10'), (SELECT REF(a) FROM agent a WHERE a.aid = 'a02'), (SELECT REF(t) FROM tenant t WHERE t.cid = 'c14'), 1985, DATE '2021-09-05', 6));
insert into rentContract values(rentContract_t('rc03', (SELECT REF(l) FROM landlord l WHERE l.cid = 'c11'), (SELECT REF(a) FROM agent a WHERE a.aid = 'a03'), (SELECT REF(t) FROM tenant t WHERE t.cid = 'c15'), 850, DATE '2020-01-10', 24));

--------------------------------------------------------------------------------------

insert into saleContract values(saleContract_t('sc01', (SELECT REF(s) FROM seller s WHERE s.cid = 'c01'), (SELECT REF(a) FROM agent a WHERE a.aid = 'a02'), (SELECT REF(p) FROM property p WHERE p.pid = 'd01'), (SELECT REF(b) FROM buyer b WHERE b.cid = 'c05'), 850000,DATE '2024-10-10'));
insert into saleContract values (saleContract_t('sc02', (SELECT REF(s) FROM seller s WHERE s.cid = 'c02'), (SELECT REF(a) FROM agent a WHERE a.aid = 'a03'), (SELECT REF(p) FROM property p WHERE p.pid = 's02'), (SELECT REF(b) FROM buyer b WHERE b.cid = 'c06'), 450000, DATE '2025-01-05'));
insert into saleContract values(saleContract_t('sc03', (SELECT REF(s) FROM seller s WHERE s.cid = 'c03'), (SELECT REF(a) FROM agent a WHERE a.aid = 'a04'), (SELECT REF(p) FROM property p WHERE p.pid = 'c03'), (SELECT REF(b) FROM buyer b WHERE b.cid = 'c07'), 300000, DATE '2024-11-19'));

--------------------------------------------------------------------------------------

insert into agentContract values(agentContract_t('ac01', (SELECT REF(a) FROM agent a WHERE a.aid = 'a01'), (SELECT REF(c) FROM customer c WHERE c.cid = 'c09'), DATE '2025-02-24', 0.09));
insert into agentContract values(agentContract_t('ac02', (SELECT REF(a) FROM agent a WHERE a.aid = 'a02'), (SELECT REF(c) FROM customer c WHERE c.cid = 'c06'), DATE '2023-05-04', 0.03));
insert into agentContract values(agentContract_t('ac03', (SELECT REF(a) FROM agent a WHERE a.aid = 'a04'), (SELECT REF(c) FROM customer c WHERE c.cid = 'c14'), DATE '2025-02-20', 0.09));
