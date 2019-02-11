-- We need a seperate audit table, function and trigger if a new item has an
-- additional column, such as with WAP (mac column).
------------------------------- Generic item ----------------------------
CREATE TABLE item_audit (
  operation   char(1)   NOT NULL,
  stamp       timestamp NOT NULL,
  userid      text      NOT NULL,
  type        text,
  location    point,
  startdate   date,
  enddate     date,
  remarks     text,
  filename    text,  -- Filename of the icon
  -- We need the building and the floornumber to link it to the unique floor
  building    varchar(2),  -- Abbreviation
  floornumber int
);

CREATE OR REPLACE FUNCTION process_item_audit() RETURNS TRIGGER AS $item_audit$
  BEGIN
    --
    -- Create a row in item_audit to reflect the operation performed on item,
    -- make use of the special variable TG_OP to work out the operation.
    --
    IF (TG_OP = 'DELETE') THEN
        INSERT INTO item_audit SELECT 'D', now(), user, OLD.*;
        RETURN OLD;
    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO item_audit SELECT 'U', now(), user, NEW.*;
        RETURN NEW;
    ELSIF (TG_OP = 'INSERT') THEN
        INSERT INTO item_audit SELECT 'I', now(), user, NEW.*;
        RETURN NEW;
    END IF;
    RETURN NULL; -- result is ignored since this is an AFTER trigger
  END;
$item_audit$ LANGUAGE plpgsql;

CREATE TRIGGER item_audit
AFTER INSERT OR UPDATE OR DELETE on item
  FOR EACH ROW EXECUTE PROCEDURE process_item_audit();

-------------------------------------- WAP ---------------------------------
CREATE TABLE wap_audit (
  mac      	  varchar(17),
  -- We need the building and the floornumber to link it to the unique floor
  building    varchar(2),  -- Abbreviation
  floornumber int
) INHERITS (item_audit) ;

CREATE OR REPLACE FUNCTION process_wap_audit() RETURNS TRIGGER AS $wap_audit$
  BEGIN
    --
    -- Create a row in wap_audit to reflect the operation performed on wap,
    -- make use of the special variable TG_OP to work out the operation.
    --
    IF (TG_OP = 'DELETE') THEN
        INSERT INTO wap_audit SELECT 'D', now(), user, OLD.*;
        RETURN OLD;
    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO wap_audit SELECT 'U', now(), user, NEW.*;
        RETURN NEW;
    ELSIF (TG_OP = 'INSERT') THEN
        INSERT INTO wap_audit SELECT 'I', now(), user, NEW.*;
        RETURN NEW;
    END IF;
    RETURN NULL; -- result is ignored since this is an AFTER trigger
  END;
$wap_audit$ LANGUAGE plpgsql;

CREATE TRIGGER wap_audit
AFTER INSERT OR UPDATE OR DELETE on wap
  FOR EACH ROW EXECUTE PROCEDURE process_wap_audit();
  
-------------------------------- Dispenser ----------------------------
-- We can keep the item_audit function (and table) for dispenser, since
-- no additional columns are added in the Dispenser child.
CREATE TRIGGER dispenser_audit
AFTER INSERT OR UPDATE OR DELETE on dispenser
  FOR EACH ROW EXECUTE PROCEDURE process_item_audit();