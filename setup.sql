-- Creates the target and staging table. 
-- Perform Day 1 load into stage
-- Merge into target on non matching hash and subsequent match on PK
-- Perform Day 2 load into stage
-- Merge into target as above.
  
CREATE OR REPLACE SCHEMA LANDING;

USE SCHEMA LANDING;

CREATE TABLE customer (
  ID int,
  EMAIL string,
  row_hash number 
);


CREATE TABLE stage_customer (
  ID int,
  EMAIL string,
  row_hash number 
);

--Day 1 Records
insert into stage_customer values (1, 'a@gmail.com', 41), (2, 'b@gmail.com', 42), (3, 'c@gmail.com', 43) ;

MERGE into customer t 
USING (Select * from stage_customer s where not exists (select * from customer t where t.row_hash=s.row_hash)) s
ON t.id = s.id 
WHEN MATCHED THEN UPDATE SET t.id=s.id, t.email=s.email, t.row_hash=s.row_hash
WHEN NOT MATCHED THEN INSERT (id, email, row_hash) VALUES (s.id. s.email, s.row_hash);

--This should result in the 3 records inserted into target.

--Day 2 Records
Truncate table stage_customer;
insert into stage_customer values (2, 'bob@aol.com', 52), (3, 'c@gmail.com', 43), (4, 'dan@danfoss.com', 54) ;

-- Same merge code as above, repeated for clarity.
MERGE into customer t 
USING (Select * from stage_customer s where not exists (select * from customer t where t.row_hash=s.row_hash)) s
ON t.id = s.id 
WHEN MATCHED THEN UPDATE SET t.id=s.id, t.email=s.email, t.row_hash=s.row_hash
WHEN NOT MATCHED THEN INSERT (id, email, row_hash) VALUES (s.id. s.email, s.row_hash);

--This should result in the 1 record (id=4) inserted into target and 1 record(id=2) updated with latest values.
