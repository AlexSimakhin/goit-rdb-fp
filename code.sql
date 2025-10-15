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



DROP TABLE IF EXISTS infectious_cases;
DROP TABLE IF EXISTS entities;

CREATE TABLE entities (
  entity_id INT AUTO_INCREMENT PRIMARY KEY,
  entity VARCHAR(100),
  code VARCHAR(10),
  UNIQUE(entity, code)
);

CREATE TABLE infectious_cases (
  id INT AUTO_INCREMENT PRIMARY KEY,
  entity_id INT,
  year INT,
  start_date DATE NULL,
  cur_date DATE NULL,
  subtract_year INT NULL,
  number_yaws FLOAT,
  polio_cases INT,
  cases_guinea_worm FLOAT,
  number_rabies FLOAT,
  number_malaria FLOAT,
  number_hiv FLOAT,
  number_tuberculosis FLOAT,
  number_smallpox FLOAT,
  number_cholera_cases INT,
  FOREIGN KEY (entity_id) REFERENCES entities(entity_id)
);

INSERT INTO entities (entity, code)
SELECT DISTINCT entity, NULLIF(code, '')
FROM raw_infectious_cases;

INSERT INTO infectious_cases (
  entity_id, year,
  number_yaws, polio_cases, cases_guinea_worm,
  number_rabies, number_malaria, number_hiv,
  number_tuberculosis, number_smallpox, number_cholera_cases
)
SELECT
  e.entity_id,
  NULLIF(TRIM(r.year), ''),
  NULLIF(TRIM(r.number_yaws), ''),
  NULLIF(TRIM(r.polio_cases), ''),
  NULLIF(TRIM(r.cases_guinea_worm), ''),
  NULLIF(TRIM(r.number_rabies), ''),
  NULLIF(TRIM(r.number_malaria), ''),
  NULLIF(TRIM(r.number_hiv), ''),
  NULLIF(TRIM(r.number_tuberculosis), ''),
  NULLIF(TRIM(r.number_smallpox), ''),
  NULLIF(TRIM(r.number_cholera_cases), '')
FROM raw_infectious_cases r
JOIN entities e ON r.entity = e.entity AND COALESCE(r.code, '') = COALESCE(e.code, '');

DROP TABLE IF EXISTS raw_infectious_cases;

SELECT 'entities' AS table_name, COUNT(*) AS count FROM entities
UNION ALL
SELECT 'infectious_cases' AS table_name, COUNT(*) FROM infectious_cases;

SELECT * FROM infectious_cases;



SELECT 
  e.entity,
  e.code,
  ROUND(AVG(i.number_rabies), 2) AS avg_rabies,
  MAX(i.number_rabies) AS max_rabies,
  MIN(i.number_rabies) AS min_rabies,
  SUM(i.number_rabies) AS sum_rabies
FROM infectious_cases i
JOIN entities e ON i.entity_id = e.entity_id
WHERE i.number_rabies IS NOT NULL
GROUP BY e.entity, e.code
ORDER BY avg_rabies DESC
LIMIT 10;



UPDATE infectious_cases
SET 
  start_date = MAKEDATE(year, 1),
  cur_date = CURDATE(),
  subtract_year = YEAR(CURDATE()) - year
WHERE id > 0;

SELECT 
  i.id,
  e.entity AS country,
  i.year,
  i.start_date,
  i.cur_date,
  i.subtract_year
FROM infectious_cases i
JOIN entities e ON i.entity_id = e.entity_id
ORDER BY i.year ASC;



DROP FUNCTION IF EXISTS subtract_now_year;

DELIMITER //

CREATE FUNCTION subtract_now_year(year_input INT)
RETURNS INT
DETERMINISTIC
NO SQL
BEGIN
  DECLARE start_date DATE;
  DECLARE year_diff INT;

  SET start_date = MAKEDATE(year_input, 1);
  SET year_diff = TIMESTAMPDIFF(YEAR, start_date, CURDATE());

  RETURN year_diff;
END //

DELIMITER ;

SELECT 
  i.id,
  e.entity AS country,
  i.year,
  subtract_now_year(i.year) AS year_diff
FROM infectious_cases i
JOIN entities e ON i.entity_id = e.entity_id
ORDER BY i.year ASC
LIMIT 50;



DROP FUNCTION IF EXISTS subtract_now_year;

DELIMITER //

CREATE FUNCTION subtract_now_year(year_input INT)
RETURNS INT
DETERMINISTIC
NO SQL
BEGIN
  DECLARE start_date DATE;
  DECLARE year_diff INT;

  SET start_date = MAKEDATE(year_input, 1);
  SET year_diff = TIMESTAMPDIFF(YEAR, start_date, CURDATE());

  RETURN year_diff;
END //

DELIMITER ;

SELECT 
  i.id,
  e.entity AS country,
  i.year,
  subtract_now_year(i.year) AS year_diff
FROM infectious_cases i
JOIN entities e ON i.entity_id = e.entity_id
ORDER BY i.year ASC
LIMIT 50;
