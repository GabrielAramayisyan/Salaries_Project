-- CREATING TABLE "salaries"

CREATE TABLE salaries (
	h INT,
	experience_level VARCHAR(255),
	employment_type VARCHAR(255),
	job_title VARCHAR(255),
	salary INT,
	salary_currency VARCHAR(255),
	salary_in_usd INT,
	employee_residence VARCHAR(255),
	remote_ratio INT,
	company_location VARCHAR(255),
	company_size VARCHAR(255)
);


-- IMPORTED THE CSV FILE WITH GUI TOOL


-- CHECKING FOR NULL VALUES

SELECT work_year FROM salaries
WHERE work_year IS NULL;

SELECT experience_level FROM salaries
WHERE experience_level IS NULL;

SELECT employment_type FROM salaries
WHERE employment_type IS NULL;

SELECT job_title FROM salaries
WHERE job_title IS NULL;

SELECT salary_in_usd FROM salaries
WHERE salary_in_usd IS NULL;

SELECT employee_residence FROM salaries
WHERE employee_residence IS NULL;

SELECT remote_ratio FROM salaries
WHERE remote_ratio IS NULL;

SELECT company_location FROM salaries
WHERE company_location IS NULL;

SELECT company_size FROM salaries
WHERE company_size IS NULL;


-- CHANGING THE TYPE OF "salary_in_usd" COLUMN

ALTER TABLE salaries
ALTER COLUMN salary_in_usd TYPE NUMERIC;


-- ADDING COLUMN "id"

ALTER TABLE salaries
ADD COLUMN id SERIAL PRIMARY KEY


-- SPOTTING AND REMOVING DUPLICATES

BEGIN;
DELETE FROM salaries
WHERE id IN (
	SELECT id FROM (
		SELECT
			id,
			ROW_NUMBER() OVER(
				PARTITION BY
					work_year,
					experience_level,
					employment_type,
					job_title,
					salary_in_usd,
					employee_residence,
					remote_ratio,
					company_location,
					company_size
				ORDER BY id
			) row_num
		FROM salaries
	)
	WHERE row_num > 1
)
COMMIT;


-- RENAMIN THE COLUMN "h" TO "work_year"

ALTER TABLE salaries
RENAME COLUMN h TO work_year

-- DROPING EXTRA COLUMNS ("salary", "salary_currency")

ALTER TABLE salaries
DROP COLUMN salary

ALTER TABLE salaries
DROP COLUMN salary_currency


-- STANDARTIZING COLUMNS:
-- "experience_level", "employment_type", "company_size"


-- "experience_level"

SELECT DISTINCT experience_level
FROM salaries;


-- ASIGNING STANDARTIZED VALUES TO "experience_level"

BEGIN;
UPDATE salaries
SET experience_level =
	CASE
		WHEN experience_level = 'EX' THEN 'Director'
		WHEN experience_level = 'MI' THEN 'Mid-level'
		WHEN experience_level = 'EN' THEN 'Junior'
		WHEN experience_level = 'SE' THEN 'Senior-level'
		ELSE 'Unknown'
	END
commit;


-- "employment_type"

SELECT DISTINCT employment_type
FROM salaries;


-- ASIGNING STANDARTIZED VALUES TO "employment_type"

BEGIN;
UPDATE salaries
SET employment_type =
	CASE
		WHEN employment_type = 'PT' THEN 'Part-time'
		WHEN employment_type = 'FL' THEN 'Freelance'
		WHEN employment_type = 'FT' THEN 'Full-time'
		WHEN employment_type = 'CT' THEN 'Contract'
		ELSE 'Unknown'
	END
commit;


-- "company_size"

SELECT DISTINCT company_size
FROM salaries;


-- ASIGNING STANDARTIZED VALUES TO "employment_type"

BEGIN;
UPDATE salaries
SET company_size =
	CASE
		WHEN company_size = 'S' THEN 'Small (1–50 employees)'
		WHEN company_size = 'M' THEN 'Medium (51–500 employees)'
		WHEN company_size = 'L' THEN 'Large (501+ employees)'
		ELSE 'Unknown'
	END
commit;



-- EXPORTING AS CSV

COPY (SELECT * FROM salaries) TO 'C:\Program Files\PostgreSQL\17\data\salaries_cleaned.csv' WITH CSV HEADER;















