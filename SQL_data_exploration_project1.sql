

select*
from vikramsqlproject..CovidDeaths$
order by 3,4

--select*
--from vikramsqlproject..CovidVaccinations$
--order by 3,4

select location, date , total_cases, total_deaths, new_cases, population
from vikramsqlproject..CovidDeaths$
order by 1,2

--total cases to total death percentage 
--


select location, date , total_cases, total_deaths, (total_deaths/total_cases)*100 as deathpercentage
from vikramsqlproject..CovidDeaths$
where location like '%india%'
order by 1,2


--total cases to total population percentage

select location, date , total_cases, population, (total_cases/population)*100 as infectedpercentage
from vikramsqlproject..CovidDeaths$
where location like '%india%'
order by 1,2

--highly infected country comppared to its population
select location, max(total_cases) as highestcases, population, max((total_cases/population))*100 as highestinfectedpercentage
from vikramsqlproject..CovidDeaths$
--where location like '%india%'
group by location, population 
order by highestinfectedpercentage desc

-- countries with highest death count 

 select location, max(cast(total_deaths as int)) as totaldeathcount
 from vikramsqlproject..CovidDeaths$
 where continent is not null
 group by location
 order by totaldeathcount desc

 --
-- continents with highest death count

select location, max(cast(total_deaths as int)) as totaldeathcount
 from vikramsqlproject..CovidDeaths$
 where continent is null
 group by location
 order by totaldeathcount desc

 -- global numbers 
 select date, sum(new_cases) as totalcases, sum(cast(new_deaths as int)) as totaldeaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as totaldeathpercentage
 from vikramsqlproject..CovidDeaths$
 where continent is not null
 group by date 
 order by 1,2


 -- total population by total vaccinations

 select cd.continent, cd.location, cd.date, cd.population, cv. new_vaccinations, 
 sum(cast(cv. new_vaccinations as int)) over (partition by cd.location  order by cd.location ,cd.date) as rollingpeoplevaccinated
 from vikramsqlproject..CovidDeaths$ cd
 join vikramsqlproject..CovidVaccinations$ cv
  on cd.location = cv.location
  and cd.date = cv.date
  where cd.continent is not null
  order by 2,3
 


-- (rollingpeoplevaccinated/population) percentage

with popvsvac(continent, location, date, population, new_vaccinations, rollingpeoplevaccinated)
as
(
 select cd.continent, cd.location, cd.date, cd.population, cv. new_vaccinations, 
 sum(cast(cv. new_vaccinations as int)) over (partition by cd.location  order by cd.location,cd.date) as rollingpeoplevaccinated
 from vikramsqlproject..CovidDeaths$ cd
 join vikramsqlproject..CovidVaccinations$ cv
  on cd.location = cv.location
  and cd.date = cv.date
  where cd.continent is not null
  --order by 2,3
)
select* , (rollingpeoplevaccinated/population)*100 as rpv
from popvsvac


create view rollingpeoplevaccinated as
select cd.continent, cd.location, cd.date, cd.population, cv. new_vaccinations, 
 sum(cast(cv. new_vaccinations as int)) over (partition by cd.location  order by cd.location ,cd.date) as rollingpeoplevaccinated
 from vikramsqlproject..CovidDeaths$ cd
 join vikramsqlproject..CovidVaccinations$ cv
  on cd.location = cv.location
  and cd.date = cv.date
  where cd.continent is not null
  --order by 2,3
  

  select*
  from rollingpeoplevaccinated