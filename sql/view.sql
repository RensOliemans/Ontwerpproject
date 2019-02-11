CREATE VIEW itemview AS
  SELECT i.type, i.location, i.building, i.floornumber, i.remarks
  FROM item i, floor f
  WHERE f.building = i.building AND f.floornumber = i.floornumber
  ORDER BY building, floornumber;