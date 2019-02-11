CREATE VIEW per_floor AS
  SELECT i.type, i.location, i.building, i.floornumber, i.remarks
  FROM item i, floor f
  WHERE f.building = i.building AND f.floornumber = i.floornumber;