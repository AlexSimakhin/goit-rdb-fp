CREATE SCHEMA IF NOT EXISTS pandemic;
USE pandemic;

CREATE TABLE raw_infectious_cases (
  entity TEXT,
  code TEXT,
  year TEXT,
  number_yaws TEXT,
  polio_cases TEXT,
  cases_guinea_worm TEXT,
  number_rabies TEXT,
  number_malaria TEXT,
  number_hiv TEXT,
  number_tuberculosis TEXT,
  number_smallpox TEXT,
  number_cholera_cases TEXT
);

-- 'Import wizard' чомусь дуже довго додавав (ноут поганий...). Тому зробив так...
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/infectious_cases.csv'
INTO TABLE raw_infectious_cases
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM raw_infectious_cases LIMIT 50;
