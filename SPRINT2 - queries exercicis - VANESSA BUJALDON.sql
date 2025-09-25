USE `transactions`;

-- NIVELL 1 - EX2
SELECT DISTINCT country AS llista_pais_amb_vendes
FROM transaction t
JOIN company c ON t.company_id = c.id
WHERE declined = 0;

SELECT COUNT(DISTINCT country) AS recompte_països_amb_vendes
 FROM transaction t
 JOIN company c ON t.company_id = c.id
 WHERE declined = 0;
 
SELECT country, ROUND(AVG(amount),2) AS mitja_transaccions
FROM transaction t
JOIN company c ON t.company_id = c.id
GROUP BY country
ORDER BY mitja_transaccions DESC
LIMIT 1;

-- NIVELL 1 - EX3
SELECT *
FROM transaction t 
JOIN company c ON t.company_id = c.id
WHERE country = 'Germany'; -- en aquest cas no hi ha transaccions declinades, sino, afegiria 'AND declined = 0'

SELECT c.id AS codi_empresa, c.company_name AS nom_empresa, ROUND(AVG(t.amount),0) AS mitja_transaccions
FROM transaction t 
JOIN company c ON t.company_id = c.id
GROUP BY company_id
HAVING mitja_transaccions > (SELECT ROUND(AVG(amount),0) AS mitjana_general FROM transaction)
ORDER BY mitja_transaccions DESC;

SELECT *
FROM company c 
LEFT JOIN transaction t ON t.company_id = c.id
WHERE t.id IS NULL ;

-- NIVELL 2 - EX1
SELECT DATE(timestamp) AS data, SUM(amount) AS total_vendes
FROM transaction
WHERE declined = 0
GROUP BY DATE(timestamp)
ORDER BY total_vendes DESC
LIMIT 5;

-- NIVELL 2 - EX2
SELECT country AS país, ROUND(AVG(t.amount),2) AS mitjana_vendes
FROM transaction t 
JOIN company c ON t.company_id = c.id
GROUP BY country
ORDER BY mitjana_vendes DESC;

-- NIVELL 2 - EX3
SELECT *
FROM transaction t
JOIN company c ON t.company_id = c.id
WHERE country = (
	SELECT country
	FROM company
	WHERE company_name LIKE '%Non Institute%'
    );
    
SELECT *
FROM transaction
WHERE company_id IN 
	(
	SELECT id
    FROM company
    WHERE country = 
		(
		SELECT country
		FROM company
		WHERE company_name LIKE '%Non Institute%'
        )
	)
	;
    
-- NIVELL 3 - EX1
SELECT c.company_name AS nom_empresa, c.phone AS telefon, DATE(timestamp) AS data_transaccio, t.amount AS import_transaccio
FROM transaction t
JOIN company c ON t.company_id = c.id
WHERE amount BETWEEN 350 AND 400 AND DATE(timestamp) IN ('2015-04-29', '2018-07-20', '2024-03-13')
ORDER BY import_transaccio DESC;

-- NIVELL 3 - EX2
SELECT c.id, c.company_name AS nom_empresa, COUNT(t.amount) AS total_transaccions,
	CASE
		WHEN COUNT(t.amount) > 400 THEN 'SUPERIOR_400'
        WHEN COUNT(t.amount) < 400 THEN 'INFERIOR_400'
        ELSE 'sense_info'
	END AS classificacio_segons_transaccions
FROM transaction t
JOIN company c ON t.company_id = c.id
WHERE declined = 0
GROUP BY c.id
ORDER BY total_transaccions DESC; -- no demanava pero per si volen contactar 1er les que fan + transaccions