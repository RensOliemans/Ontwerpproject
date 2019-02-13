CREATE TABLE building (
	name			text      UNIQUE NOT NULL,
	-- For example, 'RA'
	abbreviation	varchar(2) PRIMARY KEY
);

CREATE TABLE floor (
	building		varchar(2) REFERENCES building(abbreviation),
	floornumber		int        NOT NULL,
	PRIMARY KEY (building, floornumber)  -- Every building/floor combination is unique
);

CREATE TABLE item (
	type			text,
	location		point,
	startdate		date,
	enddate			date,
	remarks			text,
	filename		text,  -- Filename of the icon
	-- We need the building and the floornumber to link it to the unique floor
	building		varchar(2),  -- Abbreviation
	floornumber	int,
	FOREIGN KEY (building, floornumber) REFERENCES floor (building, floornumber),
	PRIMARY KEY (building, floornumber, location)
);

CREATE TABLE wap (
	type			text DEFAULT 'WAP',
	mac				macaddr UNIQUE,  -- mac address
	-- We need to keep the foreign key constraint since postgres doesn't propagate all constraints to children.
	-- See 5.9.1 in the documentation
	FOREIGN KEY (building, floornumber) REFERENCES floor (building, floornumber),
) INHERITS (item);

CREATE TABLE dispenser (
	type			text DEFAULT 'Dispenser',  -- What kind of dispenser is it?
	FOREIGN KEY (building, floornumber) REFERENCES floor (building, floornumber)
) INHERITS (item);

-- For all history retaining, see audit.sql