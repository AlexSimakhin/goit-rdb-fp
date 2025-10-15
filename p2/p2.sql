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
