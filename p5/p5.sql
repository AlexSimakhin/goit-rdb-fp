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
