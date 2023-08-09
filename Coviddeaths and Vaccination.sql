select *
from [  portfolio]..covid_deaths
WHERE continent IS NOT NULL
order by 3,4

--select *
--from [  portfolio]..covid_vaccination
--order by 3,4

select location,date,total_cases,total_deaths,population_density
from [  portfolio]..covid_deaths 
order by 1,2

--Total cases vs total deaths

SELECT
    location,
    date,
    total_cases,
    total_deaths,
    (CAST(total_deaths AS float) / CAST(total_cases AS float)) * 100 AS Deathpercent
FROM
    [  portfolio]..covid_deaths
ORDER BY
    location, date;

	--to know the percent in United states

SELECT
    location,
    date,
    total_cases,
    total_deaths,
    (CAST(total_deaths AS float) / CAST(total_cases AS float)) * 100 AS Deathpercent
FROM
    [  portfolio]..covid_deaths

WHERE 
location LIKE '%states%'
ORDER BY
     date;

--looking at the Deathpercent in INDIA
SELECT
    location,
    date,
    total_cases,
    total_deaths,
    (CAST(total_deaths AS float) / CAST(total_cases AS float)) * 100 AS Deathpercent
FROM
    [  portfolio]..covid_deaths

WHERE 
location LIKE '%India%'
ORDER BY
     date;

----looking at the total cases vs population
--shows what percent of population got affected with covid

SELECT
    location,
    date,
    total_cases,
    total_deaths,
	population_density,
    (CAST(total_cases AS float) / CAST(population_density AS float)) * 100 AS Deathpercent
FROM
    [  portfolio]..covid_deaths

--WHERE 
--location LIKE '%India%'
ORDER BY
     date;

	 --country with highest infection rate compared to population
SELECT
    location,
    date,
    MAX(total_cases) AS highestinfectioncount,
    total_deaths,
    population_density,
    MAX(CAST(total_cases AS float) / CAST(population_density AS float)) * 100 AS percentofpopulationinfected
FROM
    [  portfolio]..covid_deaths
GROUP BY
    location, date, total_deaths, population_density
ORDER BY
    percentofpopulationinfected  desc;

--showing countries with highest death count per vs population

SELECT
    location,
    MAX(total_deaths) AS totaldeathcount
    
FROM [  portfolio]..covid_deaths
WHERE continent IS NOT NULL
GROUP BY
    location
order by 
    totaldeathcount  desc;

--LET'S BREAK THINGS DOWN BY CONTINENTS


--CONTINENT WITH HIGHEST DEATHCOUNTS

SELECT
    continent,
    MAX(total_deaths) AS totaldeathcount
    
FROM [  portfolio]..covid_deaths
WHERE continent IS NOT NULL
GROUP BY
    continent
order by 
    totaldeathcount  desc;


--GLOBAL NUMBERS
SELECT
    location,
    date,
    total_cases,
    total_deaths,
	population_density,
    (CAST(total_cases AS float) / CAST(population_density AS float)) * 100 AS Deathpercent
FROM
    [  portfolio]..covid_deaths

--WHERE 
--location LIKE '%India%'
WHERE continentis not null
ORDER BY
     date;
