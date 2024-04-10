SELECT *
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 3,4;

--Select Data

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
ORDER BY location, date;

-- Total Cases vs Total Deaths
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_percentage
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
ORDER BY location, date;

-- Total Cases vs Total Deaths in the United States
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_percentage
FROM PortfolioProject.dbo.CovidDeaths
WHERE location LIKE '%states%' AND continent IS NOT NULL
ORDER BY location, date;

-- Total Cases vs Population in the United States
SELECT location, date, population, total_cases, (total_cases/population)*100 AS percent_of_population_infected
FROM PortfolioProject.dbo.CovidDeaths
WHERE location LIKE '%states%' AND continent IS NOT NULL
ORDER BY location, date;


-- Countries with the Highest Infection Rate compared to Population
SELECT location, population, MAX(total_cases) AS highest_infection_count, MAX((total_cases/population))*100 AS percent_of_population_infected
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY percent_of_population_infected DESC;

-- Countries with Highest Death Count per Population
SELECT location, MAX(CAST(total_deaths AS int)) AS total_death_count
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY total_death_count DESC;

-- Continents with the highest death count per population
SELECT continent, MAX(CAST(total_deaths AS int)) AS total_death_count
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY total_death_count DESC;


-- Global Numbers
SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS int)) AS total_deaths, (SUM(CAST(new_deaths AS int))/SUM(new_cases))*100 AS death_percentage
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2;

-- Global Numbers over time
SELECT date, SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS int)) AS total_deaths, (SUM(CAST(new_deaths AS int))/SUM(new_cases))*100 AS death_percentage
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2;

-- Perform Join between Two Tables of Data
SELECT *
FROM PortfolioProject.dbo.CovidDeaths AS dea
JOIN PortfolioProject.dbo.CovidVaccinations AS vac
	ON dea.location = vac.location
	and dea.date = vac.date;

-- Looking at Total Population vs Vaccinations
-- CTE
WITH pop_vs_vac (continent, location, date, population, new_vaccinations, rolling_people_vaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location
, dea.date) AS rolling_people_vaccinated
FROM PortfolioProject.dbo.CovidDeaths AS dea
JOIN PortfolioProject.dbo.CovidVaccinations AS vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent IS NOT NULL
)
SELECT *, (rolling_people_vaccinated/population)*100 AS rolling_vaccination_percentage
FROM pop_vs_vac

-- Temp table
DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
rolling_people_vaccinated numeric,
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location
, dea.date) AS rolling_people_vaccinated
FROM PortfolioProject.dbo.CovidDeaths AS dea
JOIN PortfolioProject.dbo.CovidVaccinations AS vac
	ON dea.location = vac.location
	and dea.date = vac.date

SELECT *, (rolling_people_vaccinated/population)*100 AS rolling_vaccination_percentage
FROM #PercentPopulationVaccinated

-- Creating View to store data for later visualizations
CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location
, dea.date) AS rolling_people_vaccinated
FROM PortfolioProject.dbo.CovidDeaths AS dea
JOIN PortfolioProject.dbo.CovidVaccinations AS vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent IS NOT NULL;