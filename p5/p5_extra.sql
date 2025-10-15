DROP FUNCTION IF EXISTS illnesses_per_period;

DELIMITER //

CREATE FUNCTION illnesses_per_period(illnesses_per_year DOUBLE, period INT)
RETURNS DOUBLE
DETERMINISTIC
NO SQL
BEGIN
  RETURN illnesses_per_year / period;
END //

DELIMITER ;

SELECT 
  e.entity AS country,
  i.year,
  i.number_cholera_cases,
  illnesses_per_period(i.number_cholera_cases, 12) AS cholera_per_month,
  illnesses_per_period(i.number_cholera_cases, 4) AS cholera_per_quarter,
  illnesses_per_period(i.number_cholera_cases, 2) AS cholera_per_halfyear
FROM infectious_cases i
JOIN entities e ON i.entity_id = e.entity_id
WHERE i.number_cholera_cases IS NOT NULL
ORDER BY i.year ASC
LIMIT 50;
