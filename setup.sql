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

