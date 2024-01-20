
SELECT *
FROM Covid_Deaths
WHERE continent IS NOT NULL
ORDER BY location, date,

-- Select data that we are going to be using


SELECT location, 
       date,
	   total_cases,
	   new_cases,
	   total_deaths,
	   population
FROM Covid_Deaths
ORDER BY location, date;


--Looking at Total Cases vs Total Deaths.
--Show Likelihood of dying if you infection covid in your country


SELECT location,
       date,
       total_cases,
       total_deaths,
       CAST(total_deaths AS float)/CAST(total_cases AS float)*100 AS Death_Percentage
FROM Covid_Deaths
WHERE location LIKE '%states%'
ORDER BY location, date;

--Looking at the total cases vs population
--Show the percentage of population got Covid


SELECT location,
       date,
       population,
       total_cases,
       (total_cases/population)*100 AS Percentage_Population_Infected
FROM Covid_Deaths
WHERE total_cases IS NOT NULL
ORDER BY location, date;


--Looking Countries with Highest infection Rate compare to Population

SELECT location,
       population,
       MAX(total_cases) AS Highest_Infection_Count,
       MAX(total_cases/population)*100 AS Percentage_Population_infected
FROM Covid_Deaths
GROUP BY location, population
ORDER BY Percentage_Population_infected DESC



--Let's break things down by continent

--Showing continents with the highest death count per population


SELECT continent,
       MAX(CAST(total_deaths AS int)) AS Total_Death_Count
FROM Covid_Deaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY Total_Death_Count DESC;


-- Global numbers

SELECT SUM(new_cases) AS Total_Cases,
       SUM(new_deaths) AS Total_Deaths,
       SUM(new_deaths)/SUM(new_cases)*100 AS Death_Percentage
FROM Covid_Deaths
WHERE continent IS NOT NULL
ORDER BY Total_Cases, Total_Deaths;


-- Looking al Total Population vs Vaccinations


SELECT DEA.continent,
       DEA.location,
       DEA.date,
       DEA.population,
       VAC.new_vaccinations,
       SUM(CONVERT(numeric,VAC.new_vaccinations)) OVER (PARTITION BY DEA.location ORDER BY DEA.location, DEA.date) AS Rolling_People_Vaccinated
FROM Covid_Deaths AS DEA
	JOIN Covid_Vaccinations AS VAC ON DEA.location = VAC.location
		AND DEA.date = VAC.date
WHERE DEA.continent IS NOT NULL
ORDER BY location, date;


-- Use CTE

WITH Pop_vs_Vac AS (
SELECT DEA.continent,
       DEA.location,
       DEA.date,
       DEA.population,
       VAC.new_vaccinations,
       SUM(CONVERT(numeric,VAC.new_vaccinations)) OVER (PARTITION BY DEA.location ORDER BY DEA.location, DEA.date) AS Rolling_People_Vaccinated
FROM Covid_Deaths AS DEA
	JOIN Covid_Vaccinations AS VAC ON DEA.location = VAC.location
		AND DEA.date = VAC.date
WHERE DEA.continent IS NOT NULL
)
SELECT *, 
       (Rolling_People_Vaccinated/population)*100
FROM Pop_vs_Vac; 


-- Temp Table


DROP TABLE IF exists #Percent_Population_Vaccinated
CREATE TABLE #Percent_Population_Vaccinated (
	Continent nvarchar(200),
	Location nvarchar (200),
	Date datetime,
	Population numeric,
	New_Vaccinations numeric,
	Rolling_People_Vaccinated numeric
)

INSERT INTO #Percent_Population_Vaccinated
SELECT DEA.continent,
       DEA.location,
       DEA.date,
       DEA.population,
       VAC.new_vaccinations,
       SUM(CONVERT(numeric,VAC.new_vaccinations)) OVER (PARTITION BY DEA.location ORDER BY DEA.location, DEA.date) AS Rolling_People_Vaccinated
FROM Covid_Deaths AS DEA
	JOIN Covid_Vaccinations AS VAC ON DEA.location = VAC.location
		AND DEA.date = VAC.date

SELECT *, 
       (Rolling_People_Vaccinated/population)*100
FROM #Percent_Population_Vaccinated


--Creating View to store for later visualizations 


CREATE VIEW Percent_Population_Vaccinated AS
SELECT DEA.continent,
       DEA.location,
       DEA.date,
       DEA.population,
       VAC.new_vaccinations,
       SUM(CONVERT(numeric,VAC.new_vaccinations)) OVER (PARTITION BY DEA.location ORDER BY DEA.location, DEA.date) AS Rolling_People_Vaccinated
FROM Covid_Deaths AS DEA
	JOIN Covid_Vaccinations AS VAC ON DEA.location = VAC.location
		AND DEA.date = VAC.date
WHERE DEA.continent IS NOT NULL


SELECT *
FROM Percent_Population_Vaccinated




       
	   
	   
	   










	



