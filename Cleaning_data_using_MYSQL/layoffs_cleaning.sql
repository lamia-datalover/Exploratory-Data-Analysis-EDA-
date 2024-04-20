-- Data cleaning in MYSQL
SELECT *
FROM layoffs;

-- Steps of cleaning the database :
-- 1. Remove duplicates
-- 2. Standardize the data
-- 3. Populate Null values or blank values
-- 4. Remove any columns that will nothing to the project (as columns with lots of blank values )

CREATE TABLE layoffs_staging
LIKE layoffs;

-- Creating an other Table to work on in order to keep the raw data clean in case we make a mistake while dealing with it 
SELECT *
FROM layoffs_staging;

INSERT layoffs_staging
SELECT * 
FROM layoffs;

-- Removing duplicates by providing a row number within each partition of the specified columns , 

WITH duplicate_cte AS 
(
SELECT *,
ROW_number() OVER(
PARTITION BY company,location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT * 
FROM duplicate_cte
WHERE row_num > 1 ;

select *
FROM layoffs_staging
where company='Casper';

CREATE TABLE `layoffs_staging2` (
	`company` text,
	`location` text ,
	`industry`text ,
	`total_laid_off` int DEFAULT NULL, 
	`percentage_laid_off` text ,
	`date` text ,
	`stage` text ,
	`country` text ,
	`funds_raised_millions` int DEFAULT NULL ,
    `row_num` INT 
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci; 

SELECT *
FROM layoffs_staging2;

-- We will fill the empty table with the rows that have the column row_num that gives numbers to rows following the selected columns

INSERT INTO layoffs_staging2
SELECT *,
ROW_number() OVER(
PARTITION BY company,location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

SELECT *
FROM layoffs_staging2
WHERE row_num>1 ;

DELETE 
FROM layoffs_staging2
WHERE row_num >1 ;
-- We run the following code to be sure that the duplicates no more exist
SELECT *
FROM layoffs_staging2
WHERE row_num>1 ;

-- Standardizing data => finding issues in the data and fixing it

SELECT *
FROM layoffs_staging2;

-- WE strat by deleting the space in the beginning of the company column 
SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company=TRIM(company);
-- The industry column contains different names that refer to the same name that is Crypto , the goal is to change those name to Crypto only
SELECT *
FROM layoffs_staging2
where industry LIKE 'Crypto%'; 

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';
-- To check if this worked let's run the following code !
SELECT DISTINCT industry 
from layoffs_staging2;
-- Same for united states in the column named country !
SELECT DISTINCT country 
FROM layoffs_staging2
WHERE country LIKE 'United States%'
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM( TRAILING '.' FROM country )
WHERE industry LIKE 'United States%';

-- Changing the date column by converting a str to a date format

SELECT `date` ,
STR_TO_DATE(`date`,'%m/%d/%Y') 
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date`=STR_TO_DATE(`date`,'%m/%d/%Y') ;

SELECT `date` 
FROM layoffs_staging2;

-- Even if we modified the date format the type of this column is still text to turn it into a date type we should do the following
ALTER TABLE  layoffs_staging2
MODIFY COLUMN `date` DATE ;
 
 -- Working with NULL and blank values 
 SELECT *
 FROM layoffs_staging2
 where total_laid_off is NULL AND percentage_laid_off is NULL ;
 
 SELECT * 
 FROM layoffs_staging2 
 WHERE industry is NULL 
 OR industry= '' ;
 
 SELECT *
 FROM layoffs_staging2
 WHERE  company='Airbnb';
 -- We note that there are some empty spaces in industry that can be filled with the right words 
 SELECT t1.industry,t2.industry
 FROM layoffs_staging2 t1
 JOIN layoffs_staging2 t2
	  ON t1.company=t2.company -- matching column 
      AND t1.location=t2.location -- matching column 
WHERE (t1.industry iS NULL OR t1.industry= '' )
AND t2.industry IS NOT NULL ;

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '' ;

UPDATE layoffs_staging2 t1 -- the table with blank spaces 
JOIN layoffs_staging2 t2 
	ON t1.company=t2.company -- matching column 
SET t1.industry = t2.industry
WHERE t1.industry iS NULL 
AND t2.industry IS NOT NULL ;

-- Let's check if this worked properly 
SELECT *
 FROM layoffs_staging2
 WHERE  company='Airbnb';
 -- It does !
 
-- The goal of this dataset is to study the layoffs of the different companies so the data that do not have information in columns as totla_laid_off
-- and percentage laid_off is useless !

 SELECT *
 FROM layoffs_staging2
 where total_laid_off is NULL AND percentage_laid_off is NULL ;
 
 DELETE 
 FROM layoffs_staging2
 where total_laid_off is NULL AND percentage_laid_off is NULL ;
  
  -- Time to drop the useless column : row_num
   ALTER TABLE layoffs_staging2
   DROP COLUMN row_num;
   
   -- AND TADAAAA OUR DATASET IS FINALLY CLEAN !!