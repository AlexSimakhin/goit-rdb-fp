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
