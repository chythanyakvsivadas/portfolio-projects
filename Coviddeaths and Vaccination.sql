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
    date,
    SUM(new_cases) AS total_new_cases,
    SUM(new_deaths) AS total_new_deaths,
    CASE
        WHEN SUM(new_cases) > 0 THEN (SUM(new_deaths) * 100.0 / SUM(new_cases))
        ELSE 0
    END AS death_percentage
FROM
   [  portfolio]..covid_deaths
WHERE 
    continent IS NOT NULL
GROUP BY 
    date
ORDER BY 
    date;

--to get the total death percent

SELECT
    
    SUM(new_cases) AS total_new_cases,
    SUM(new_deaths) AS total_new_deaths,
    CASE
        WHEN SUM(new_cases) > 0 THEN (SUM(new_deaths) * 100.0 / SUM(new_cases))
        ELSE 0
    END AS death_percentage
FROM
   [  portfolio]..covid_deaths
WHERE 
    continent IS NOT NULL
--GROUP BY date
ORDER BY 1,2;


--covid vaccinations

select *
From [  portfolio]..covid_vaccination
order by 3,4

--Joining Covid deaths and covid vaccinations

select *
from  [  portfolio]..covid_deaths dea
join  [  portfolio]..covid_vaccination vac
	on dea.location = vac.location
	and dea.date = vac.date

--Looking at the Total population vs vaccination

select dea.location,dea.continent,dea.date,dea.population_density,vac.new_vaccinations
from  [  portfolio]..covid_deaths dea

join  [  portfolio]..covid_vaccination vac
	on dea.location = vac.location
	and dea.date = vac.date
WHERE 
    dea.continent IS NOT NULL
order by 2,3

--to get the total vaccination

SELECT
    dea.continent,
	dea.location,
    dea.date,
    dea.population_density,
    vac.new_vaccinations,
    SUM(CAST(vac.new_vaccinations AS bigint)) OVER (PARTITION BY dea.location) AS total_vaccinations
FROM
    [  portfolio]..covid_deaths dea
JOIN
    [  portfolio]..covid_vaccination vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE 
    dea.continent IS NOT NULL
    AND vac.new_vaccinations IS NOT NULL
ORDER BY 
    2, 3;

--temp table  Rollingpeoplevaccinated
Drop table if exists #percentpeoplevaccinated
create table #percentpeoplevaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccination numeric,
Rollingpeoplevaccinated numeric
)

insert into #percentpeoplevaccinated
SELECT
    dea.continent,
	dea.location,
    dea.date,
    dea.population_density,
    vac.new_vaccinations,
    SUM(Convert(bigint,vac.new_vaccinations)) OVER (PARTITION BY dea.location order by dea.location,dea.date) AS Rollingpeoplevaccinated
FROM
    [  portfolio]..covid_deaths dea
JOIN
    [  portfolio]..covid_vaccination vac
    ON dea.location = vac.location
    AND dea.date = vac.date
--WHERE 
    --dea.continent IS NOT NULL
    --AND vac.new_vaccinations IS NOT NULL
--ORDER BY 2, 3;
SELECT *,
       (Rollingpeoplevaccinated * 100) / NULLIF(population, 0) AS PercentVaccinated
FROM #percentpeoplevaccinated;


--create a view to store for further visualizations

create view percentpeoplevaccinated as 
SELECT
    dea.continent,
	dea.location,
    dea.date,
    dea.population_density,
    vac.new_vaccinations,
    SUM(Convert(bigint,vac.new_vaccinations)) OVER (PARTITION BY dea.location order by dea.location,dea.date) AS Rollingpeoplevaccinated
FROM
    [  portfolio]..covid_deaths dea
JOIN
    [  portfolio]..covid_vaccination vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE 
    dea.continent IS NOT NULL
    AND vac.new_vaccinations IS NOT NULL
--ORDER BY 2, 3;
SELECT *,
       (Rollingpeoplevaccinated * 100) / NULLIF(population, 0) AS PercentVaccinated
FROM #percentpeoplevaccinated;



