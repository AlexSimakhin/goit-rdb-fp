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
