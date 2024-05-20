Select * from portfolio..CovidDeaths
order by 3,4

Select * from portfolio..CovidVaccinations
order by 3,4

Select location , date , total_cases , new_cases , total_deaths , population 
From portfolio..CovidDeaths
Order by 1,2

Select location ,date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From portfolio..CovidDeaths
Where location like '%Morocco%'
Order by 1,2

Select location ,date, total_cases, population, (total_cases/population)*100 as CasePercentage
From portfolio..CovidDeaths
Where location like '%Morocc%'
Order by 1,2

Select Location, population,  MAX(total_cases) as sum_cases, MAX((total_cases)/population*100) as CasePercentage
From portfolio..CovidDeaths
Group by Location, population
Order by CasePercentage Desc

Select location, population , MAX(total_deaths) as max_death, MAX((total_deaths/population)*100) as Deathpercentage
From portfolio..CovidDeaths
Group by location, population
Order by Deathpercentage Desc



Select location,Max(Cast(total_deaths as int )) as TotalDeaths
From portfolio..CovidDeaths
where continent is not Null
Group by location
Order by TotalDeaths Desc


Select continent,Max(Cast(total_deaths as int )) as TotalDeaths
From portfolio..CovidDeaths
where continent is not Null
Group by continent
Order by TotalDeaths Desc

Select Sum(new_cases) as TotalCases, Sum(Cast(new_deaths as Int)) as TotalDeaths , 
(Sum(Cast(new_deaths as Int)) / Sum(new_cases)) * 100 as DeathPercentage 
From portfolio..CovidDeaths
where continent is not Null
Order by DeathPercentage Desc




With tot (continent, location, date, population, new_vaccinations, sumvac)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Cast(new_vaccinations as Int)) Over (Partition by dea.location Order by dea.location, dea.date) as sumvac
From portfolio..CovidDeaths dea
join portfolio..CovidVaccinations vac
	On dea.location = vac.location
	And dea.date = vac.date
Where dea.continent is not Null
--Order by 2,3
)
Select *, (sumvac/population) as perccentage
from tot
Order by 2,3



Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
( 
Continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
sumvac numeric
)
Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Cast(new_vaccinations as Int)) Over (Partition by dea.location Order by dea.location, dea.date) as sumvac
From portfolio..CovidDeaths dea
join portfolio..CovidVaccinations vac
	On dea.location = vac.location
	And dea.date = vac.date
Where dea.continent is not Null
--Order by 2,3
Select *, (sumvac/population) as perccentage
from #PercentPopulationVaccinated
Order by 2,3


Create view PerPopVac as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Cast(new_vaccinations as Int)) Over (Partition by dea.location Order by dea.location, dea.date) as sumvac
From portfolio..CovidDeaths dea
join portfolio..CovidVaccinations vac
	On dea.location = vac.location
	And dea.date = vac.date
Where dea.continent is not Null
--Order by 2,3