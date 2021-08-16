--Finding the Total Cases vs Total Deaths

SELECT Location, date, total_cases, total_deaths, (total_deaths / total_cases) * 100 AS DeathPercentage
FROM PortfolioProject..Coviddeaths
WHERE Location = 'united states' OR Location = 'algeria'
AND continent IS NOT NULL
ORDER BY Location DESC, date 

--Finding the Total Cases vs Population

SELECT Location, date, Population,total_cases,(total_cases / population) * 100 AS Covid_Infection_Percentage
FROM PortfolioProject..Coviddeaths
WHERE Location = 'united states' OR Location = 'algeria'
AND continent IS NOT NULL
ORDER BY Location DESC, date 

-- Finding the countries with Highest Infection Rate compared to Population 

SELECT Location, Population, MAX(total_cases) AS Highest_Infection_Number, MAX((total_cases / population)) * 100 AS Covid_Infection_Percentage
FROM PortfolioProject..Coviddeaths
WHERE continent IS NOT NULL
GROUP BY Location, Population
ORDER BY Covid_Infection_Percentage DESC

--Showing Countries with Highest Death Count per Population

SELECT Location, MAX(CAST(total_deaths AS INT)) AS Total_Deaths_Number
FROM PortfolioProject..Coviddeaths
WHERE continent IS NOT NULL
GROUP BY Location
ORDER BY Total_Deaths_Number DESC

-- Finding the Number of Cases and Deaths Globally 

SELECT SUM(new_cases) AS Global_cases, SUM(CAST(new_deaths AS INT)) AS Global_deaths, 
       SUM(CAST(new_deaths AS INT)) / SUM(new_cases) * 100 AS Global_death_Percentage
FROM PortfolioProject..Coviddeaths
WHERE continent IS NOT NULL
ORDER BY 1,2

--Looking at Total Population vs Vaccination

SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations,
       SUM(CONVERT(INT, v.new_vaccinations)) OVER (PARTITION BY d.location ORDER BY d.location, d.date)
	   AS Vaccination_progress
FROM PortfolioProject..Coviddeaths d
JOIN PortfolioProject..CovidVaccinations v
     ON d.location = v.location AND d.date = v.date
WHERE d.Location = 'united states' OR d.Location = 'algeria'
AND d.continent IS NOT NULL      
ORDER BY 1 DESC,2,3 