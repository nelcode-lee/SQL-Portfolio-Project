-- Exploratory Data Analysis

select * 
from layoffs_staging2;

-- define parameters for EDA

select max(total_laid_off), max(percentage_laid_off)
from layoffs_staging2;

select * 
from layoffs_staging2
where percentage_laid_off = 1
order by funds_raised_millions desc;


select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

select industry, sum(total_laid_off)
from layoffs_staging2
group by industry
order by 2 desc;

select country, sum(total_laid_off)
from layoffs_staging2
group by country
order by 2 desc;

select year(`date`), sum(total_laid_off)
from layoffs_staging2
group by year(`date`)
order by 1 desc;

select substring(`date`,1,7) as `MONTH`, sum(total_laid_off)
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `MONTH`
order by 1 asc;

with rolling_total as 
(
select substring(`date`,1,7) as `MONTH`, sum(total_laid_off) as total_off
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `MONTH`
order by 1 asc
)
select `MONTH`, total_off, 
sum(total_off) over(order by `MONTH`) as rolling_total
from rolling_total;

select company, year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, `date`
order by 3 desc;


with company_Year (company, years, total_laid_off) as
(
select company, year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, Year(`date`)
), Company_Year_Rank as
(select *, dense_rank() over(partition by years order by total_laid_off desc) as Ranking
from Company_Year
where years is not null
)
select *
from Company_Year_Rank
where Ranking <= 5;