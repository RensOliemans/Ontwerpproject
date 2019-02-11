INSERT INTO building (name, abbreviation) VALUES ('Ravelijn', 'RA');
INSERT INTO building (name, abbreviation) VALUES ('Waaier', 'WA');

INSERT INTO floor (building, floornumber) VALUES ('RA', 1);
INSERT INTO floor (building, floornumber) VALUES ('RA', 2);
INSERT INTO floor (building, floornumber) VALUES ('RA', 3);
INSERT INTO floor (building, floornumber) VALUES ('WA', 1);
INSERT INTO floor (building, floornumber) VALUES ('WA', 2);

INSERT INTO wap (building, floornumber, location, startdate, enddate, mac, remarks)
    VALUES ('RA', 1, '(4, 7)', '2019-01-01', '2019-05-01', '01-23-45-67-89-AB', 'Ravelijn new WAP');
	
UPDATE wap SET remarks = 'Changed remark'
	WHERE mac = '01-23-45-67-89-AB';

INSERT INTO dispenser (building, floornumber, location, startdate, enddate, remarks, type)
    VALUES ('RA', 3, '(6, 13)', '2019-01-01', '2019-05-01', 'Fresh coffee!', 'Coffee machine');

INSERT INTO dispenser (building, floornumber, location, startdate, enddate, remarks, type)
    VALUES ('WA', 2, '(45, 23)', '2019-01-01', '2019-05-01', 'Chips', 'Snack dispenser');
	
UPDATE dispenser SET location = '(45, 24)'
	WHERE building = 'WA' AND floornumber = 2 AND location ~= '(45, 23)';
	
INSERT INTO dispenser (building, floornumber, location)
	VALUES ('WA', 1, '(12, 23)');
	
DELETE FROM dispenser WHERE building = 'WA' AND floornumber = 1 AND location ~= '(12, 23)';
