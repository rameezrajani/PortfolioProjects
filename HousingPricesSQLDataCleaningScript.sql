--Data Cleaning Process
SELECT *
FROM PortfolioProject.dbo.Housing;

-- Remove Trailing and Leading Quotes from Data

SELECT
SUBSTRING(id, 2, LEN(id)) AS id
FROM PortfolioProject.dbo.Housing
WHERE LEFT(id, 1) = '"';

SELECT
SUBSTRING(id, 1, LEN(id)-1) AS id
FROM PortfolioProject.dbo.Housing
WHERE RIGHT(id, 1) = '"';

UPDATE Housing
SET id = SUBSTRING(id, 2, LEN(id))
WHERE LEFT(id, 1) = '"';

UPDATE Housing
SET id = SUBSTRING(id, 1, LEN(id)-1)
WHERE RIGHT(id, 1) = '"';



UPDATE Housing
SET date = SUBSTRING(date, 2, LEN(date))
WHERE LEFT(date, 1) = '"';

UPDATE Housing
SET date = SUBSTRING(date, 1, LEN(date)-1)
WHERE RIGHT(date, 1) = '"';



UPDATE Housing
SET floors = SUBSTRING(floors, 2, LEN(floors))
WHERE LEFT(floors, 1) = '"';

UPDATE Housing
SET floors = SUBSTRING(floors, 1, LEN(floors)-1)
WHERE RIGHT(floors, 1) = '"';



UPDATE Housing
SET zipcode = SUBSTRING(zipcode, 2, LEN(zipcode))
WHERE LEFT(zipcode, 1) = '"';

UPDATE Housing
SET zipcode = SUBSTRING(zipcode, 1, LEN(zipcode)-1)
WHERE RIGHT(zipcode, 1) = '"';

-- Change Date Type
SELECT
PARSENAME(REPLACE(date,'T', '.'), 2)
FROM PortfolioProject.dbo.Housing

UPDATE Housing
SET date = PARSENAME(REPLACE(date,'T', '.'), 2);

SELECT date, CONVERT(date,date)
FROM PortfolioProject.dbo.Housing;

UPDATE Housing
SET date = CONVERT(date,date);

-- Convert exponential expressions into readable format
SELECT CONVERT(numeric(7,0), CAST(price AS float))
FROM PortfolioProject.dbo.Housing;

UPDATE Housing
SET price = CONVERT(numeric(7,0), CAST(price AS float));