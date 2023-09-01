-- Select the data we are working on
SELECT *
FROM protofolioProject.dbo.coviedDeaths
WHERE continent IS NOT NULL;

-- Know the data type of the columns in your table
SELECT
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH AS MAX_LENGTH,
    CHARACTER_OCTET_LENGTH AS OCTET_LENGTH,
    COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'coviedDeaths';

-- Change the data type of the total_deaths column from nvarchar to float
ALTER TABLE protofolioProject.dbo.coviedDeaths
ALTER COLUMN total_deaths FLOAT;

-- Change the data type of the total_cases column from nvarchar to float
ALTER TABLE protofolioProject.dbo.coviedDeaths
ALTER COLUMN total_cases FLOAT;

-- Select date, total_deaths, total_cases, and deathsPercentage
-- Shows likelihood of dying in your country if you catch Covid
SELECT
    location,
    date,
    total_cases,
    total_deaths,
    (total_deaths / total_cases) * 100 AS deathsPercentage
FROM protofolioProject.dbo.coviedDeaths
WHERE continent IS NOT NULL
ORDER BY 1, 2;

-- Calculate the percentage of total_cases vs population
SELECT
    location,
    date,
    population,
    total_cases,
    (total_cases / population) * 100 AS percent_Population_Infected
FROM protofolioProject.dbo.coviedDeaths
WHERE continent IS NOT NULL
ORDER BY 1, 2;

-- Find the country with the highest infection rate compared to population
SELECT
    location,
    population,
    MAX(total_cases) AS HeighestInfectionCount,
    MAX((total_cases / population) * 100) AS percent_Population_Infected
FROM protofolioProject.dbo.coviedDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY percent_Population_Infected DESC;

-- Show the countries with the highest death count per population
SELECT
    location,
    MAX(CAST(total_deaths AS INT)) AS Heighest_total_deaths_count
FROM protofolioProject.dbo.coviedDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY Heighest_total_deaths_count DESC;

-- Show the continent with the highest death count per population
SELECT
    continent,
    MAX(CAST(total_deaths AS INT)) AS Heighest_total_deaths_count
FROM protofolioProject.dbo.coviedDeaths
WHERE continent IS NOT NULL -- Use NULL for worldwide
GROUP BY continent
ORDER BY Heighest_total_deaths_count DESC;

-- Global Numbers
SELECT
    SUM(new_cases) AS total_cases,
    SUM(CAST(new_deaths AS INT)) AS total_deaths,
    SUM(CAST(new_deaths AS INT)) / SUM(new_cases) * 100 AS DeathPercentage
FROM protofolioProject.dbo.coviedDeaths
WHERE continent IS NOT NULL
ORDER BY 1, 2;

-- Total Population vs Vaccinations
-- Shows the percentage of the population that has received at least one Covid vaccine
SELECT
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(CONVERT(FLOAT, vac.new_vaccinations)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) AS RollingPeopleVaccinated
FROM protofolioProject..coviedDeaths dea
JOIN protofolioProject..coviedvaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2, 3;