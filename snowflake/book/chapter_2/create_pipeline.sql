-- Create DB
CREATE DATABASE IF NOT EXISTS BAKERY_DB;
USE DATABASE BAKERY_DB; 

-- Create Schema
CREATE SCHEMA IF NOT EXISTS ORDERS;
USE SCHEMA ORDERS; 

-- Create named internal stage
CREATE OR REPLACE STAGE ORDERS_STAGE;

LIST @ORDERS_STAGE;

-- Upload file to stage from the local file system
PUT file://Orders_2023-07-07.csv @ORDERS_STAGE AUTOCOMPRESS=TRUE;

LIST @ORDERS_STAGE;

SELECT $1, $2, $3, $4, $5 FROM @ORDERS_STAGE
LIMIT 5;

-- Create stage table to load the data from the staged file
CREATE OR REPLACE TABLE ORDERS_STG(
    customer VARCHAR,
    order_date DATE,
    delivery_date DATE,
    baked_good_type VARCHAR,
    quantity NUMBER,
    source_file_name VARCHAR,
    load_ts TIMESTAMP
);

DESCRIBE TABLE ORDERS_STG;

-- Load the data from the file in the named internal stage to the stage table
COPY INTO ORDERS_STG
FROM (
    SELECT $1, $2, $3, $4, $5, METADATA$FILENAME, CURRENT_TIMESTAMP()
    FROM @ORDERS_STAGE
)
FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1)
ON_ERROR = ABORT_STATEMENT;

-- Using REMOVE command instead of 
-- PURGE option in the COPY INTO
REMOVE @ORDERS_STAGE;

SELECT * FROM ORDERS_STG
LIMIT 5;

-- Create target table to merge the information from the staging table
-- Note that we won't replace it if it already exists 
CREATE TABLE IF NOT EXISTS CUSTOMER_ORDERS(
    customer VARCHAR,
    order_date DATE,
    delivery_date DATE,
    baked_good_type VARCHAR,
    quantity NUMBER,
    source_file_name VARCHAR,
    load_ts TIMESTAMP
);

-- Merge the information to ensure only one record for a customer, 
-- baked type, and delivery date
MERGE INTO CUSTOMER_ORDERS tgt
USING ORDERS_STG AS src
ON tgt.customer = src.customer 
    AND tgt.delivery_date = src.delivery_date 
    AND tgt.baked_good_type = src.baked_good_type
WHEN MATCHED THEN 
    UPDATE SET tgt.quantity = src.quantity,
        tgt.source_file_name = src.source_file_name,
        tgt.load_ts = CURRENT_TIMESTAMP()
WHEN NOT MATCHED THEN
    INSERT(customer,
    order_date,
    delivery_date,
    baked_good_type,
    quantity,
    source_file_name,
    load_ts) 

    VALUES(src.customer,
    src.order_date,
    src.delivery_date,
    src.baked_good_type,
    src.quantity,
    src.source_file_name,
    CURRENT_TIMESTAMP());
