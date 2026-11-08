-- Exploratory Data Analysis 

SELECT *
FROM layoffs_staging2;

SELECT MAX(total_laid_off) max_laidoff
FROM layoffs_staging2;

SELECT MAX(percentage_laid_off) percent_laidoff
FROM layoffs_staging2;

SELECT * , COUNT(company) OVER() Total_company
FROM layoffs_staging2 
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

SELECT company , SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT country , SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT MIN(`date`) , MAX(`date`)
FROM layoffs_staging2;

SELECT industry , SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

SELECT country , SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT YEAR(`date`) , SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

SELECT SUBSTRING(`date` , 1, 7) AS `MONTH` , SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date` , 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ;

WITH Rolling_Total AS 
(
SELECT SUBSTRING(`date` , 1, 7) AS `MONTH` , SUM(total_laid_off) AS total_laid
FROM layoffs_staging2
WHERE SUBSTRING(`date` , 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 
)
SELECT `MONTH` , total_laid, SUM(total_laid) OVER (ORDER BY `MONTH`) rolling_total
FROM Rolling_Total;

SELECT company , YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company , YEAR(`date`)
ORDER BY 1 ;

SELECT company , YEAR(`date`), SUM(total_laid_off) AS total_laid
FROM layoffs_staging2
GROUP BY company , YEAR(`date`)
ORDER BY 3 DESC ;

WITH laidoff_rank(Company , Years , total_laid) AS 
(
SELECT company , YEAR(`date`), SUM(total_laid_off) AS total_laid
FROM layoffs_staging2
GROUP BY company , YEAR(`date`)
),
Company_rank AS
(
SELECT * , DENSE_RANK() OVER(PARTITION BY Years ORDER BY total_laid DESC) AS ranking
FROM laidoff_rank
WHERE Years is not null
)
SELECT * 
FROM Company_rank
WHERE ranking <=5 ;

WITH laidoff_rank(Company , Years , total_laid) AS 
(
SELECT company , YEAR(`date`), SUM(total_laid_off) AS total_laid
FROM layoffs_staging2
GROUP BY company , YEAR(`date`)
),
Company_rank AS
(
SELECT * , DENSE_RANK() OVER(PARTITION BY Years ORDER BY total_laid DESC) AS ranking
FROM laidoff_rank
WHERE Years is not null
)
SELECT * 
FROM Company_rank
WHERE ranking =3 ;
