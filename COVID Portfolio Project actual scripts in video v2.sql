Select *
From PortfolioProject..CovidDeaths$
Where continent is not Null
Order By 3,4

--Looking at Total_cases vs Total_Deaths
--SHows likelihood of dying if you contract covid in your country

select location,date,total_cases,total_deaths,
(Convert(float,total_deaths)/Convert(float,total_cases))*100 as DeathPercentage,
(Convert(float,total_cases)/population)*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths$
Where location like '%states%' and 
continent is not Null
Order By 1,2

--Loooking at Total_cases vs Population
--Shows what Percentage of Population got Covid

select location,date,total_cases,total_deaths,Population,
(Convert(float,total_deaths)/Convert(float,total_cases))*100 as DeathPercentage,
(Convert(float,total_cases)/population)*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths$
--Where location like '%states%' and continent is not Null
Order By 1,2

--Looking at Countries with Highest Infection Rate Compared to Population

Select location,population, MAX(CONVERT(float,total_cases)) as HighestInfectionCount,
Max((Convert(float,total_cases)/population)*100 )as PercentPopulationInfected
From PortfolioProject..CovidDeaths$
--Where location like '%states%' and continent is not Null
Group By location,population
order by PercentPopulationInfected desc


-- Showing Countries with Highest Death Coint per population

Select location,MAX(Convert(float,Total_deaths)) as TotalDeathCount
From PortfolioProject..CovidDeaths$
Where continent is not Null
Group By location
Order By TotalDeathCount desc

--LST'S BREAK THINGS DOWN BY CONTINENT

Select continent , MAX(CONVERT(float, total_deaths)) as TotalDeathsCount
From PortfolioProject..CovidDeaths$
Where continent is not null
Group By continent
Order By TotalDeathsCount desc


-- Showing the Continents with the highest death count

Select Continent, MAX(Convert(Float,total_deaths)) as TotalDeathCount
From PortfolioProject..CovidDeaths$
Where continent is not null
Group By continent
Order By TotalDeathCount Desc



--GLOBAL NUMBERS

SELECT   sum((new_cases))as TotalNewCases, Sum(new_deaths) as TotalNewDeaths,(Sum(new_deaths)/sum(new_cases))*100 as DeathPercentage  --date,, total_deaths,(CONVERT(float, total_deaths)/CONVERT(float, total_cases))*100 AS DeathPeercentage
FROM PortfolioProject..CovidDeaths$
--WHERE location like '%states%'
WHERE continent is not null
--GROUP BY date
ORDER BY 1,2



--Looking at Total Population vs Vaccincation

With PopvsVac (Continent, location, date, Population, new_vaccinations,RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations
,SUM(Convert(float,vac.new_vaccinations)) OVER (Partition by dea.Location 
order by  dea.location--,dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccination$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--Order By 2,3
)

Select *, (RollingPeopleVaccinated/Population)*100 as 'Rolling%'
From PopvsVac
--USE CTE



--TEMP TABLE

Drop Table if exists #PercentPopulationVaccindated
Create Table #PercentPopulationVaccindated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccindated
Select dea.continent, dea.location ,dea.date, dea.population, vac.new_vaccinations
,SUM(Convert(float,vac.New_vaccinations)) over (Partition By dea.location Order By dea.location) as RollingPeopleVaccinated
--, dea.Date)
--,(RollingPeopleVaccinated/Population)*100 as 'Rolling%'
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccination$ vac
	on dea.location=vac.location
	and dea.date=vac.date
Where dea.continent is not null
--Order By 2,3
Select *, (RollingPeopleVaccinated/Population)*100 as'Rolling%'
From #PercentPopulationVaccindated



--Creating View to store data for later Visualizations

Create View PercentPopulationVaccindated as
Select dea.continent, dea.location ,dea.date, dea.population, vac.new_vaccinations
,SUM(Convert(float,vac.New_vaccinations)) over (Partition By dea.location Order By dea.location) as RollingPeopleVaccinated
--, dea.Date)
--,(RollingPeopleVaccinated/Population)*100 as 'Rolling%'
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccination$ vac
	on dea.location=vac.location
	and dea.date=vac.date
Where dea.continent is not null
--Order By 2,3


Select *
From PercentPopulationVaccindated
