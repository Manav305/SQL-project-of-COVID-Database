

select location, date, total_cases, new_cases, total_deaths, population from portfolio_project..CovidDeaths order by 1,2;

select  location, date, total_cases, new_cases, total_deaths, population from CovidDeaths where location = 'India'; 

select sum(total_deaths) from CovidDeaths where location = 'Afghanistan';


select  location, date, total_cases, new_cases, total_deaths, total_deaths/total_cases*100 as death_percentage from CovidDeaths order by 1,2 

select  location, date, total_cases, new_cases, total_deaths, total_deaths/total_cases*100 as death_percentage from CovidDeaths where location= 'India' order by 1,2 

select total_cases, location, new_cases, new_cases/total_cases*100 as newcases_percentage from portfolio_project..CovidDeaths order by 1,2


select  location, date, total_cases, new_cases, total_deaths, total_deaths/total_cases*100 as death_percentage from portfolio_project..CovidDeaths;

select * from portfolio_project..CovidDeaths

select  location, total_cases, total_deaths, total_deaths/total_cases*100 as death_percentage from CovidDeaths order by 1,2

select location, date, total_cases, new_cases, population, total_cases/population*100 as positivity_rate
from portfolio_project..CovidDeaths where location='India'order by 1,2

select location, date, total_cases, new_cases, population, total_cases/population*100 as positivity_rate from 
portfolio_project..CovidDeaths where location like '%states%'order by 1,2

select  max(total_cases) as higeshtinfectioncount,max(total_cases/population*100) as highestinfectiouspercentage, location, population 
from CovidDeaths group by location, population order by highestinfectiouspercentage desc

select  max(total_cases) as higeshtinfectioncount,max(total_cases/population*100) as highestinfectiouspercentage, location, population from CovidDeaths
group by location, population order by higeshtinfectioncount desc

select  max(cast(total_deaths as int)) as highestdeathcount,max(total_deaths/population*100) as highestdeathpercentage, location, population from CovidDeaths
where continent is not null group by location, population order by highestdeathcount desc

select  max(cast(total_deaths as int)) as totaldeathcount, location from CovidDeaths
where continent is null group by location order by totaldeathcount desc

select * from CovidDeaths

select continent, sum(cast(new_deaths as int))from coviddeaths group by continent order by 2 desc

-- find death ratio in world

select  sum(new_cases) as totalcases, sum (cast(new_deaths as int)) as totaldeaths,sum (cast(new_deaths as int))/sum(new_cases)*100 as death_ratio 
from CovidDeaths where continent is not null  order by 1,2 desc

--find infection ratio in world

select location,sum(population), sum(new_cases), sum(new_cases)/sum(population) as infection_ratio from CovidDeaths
where continent is not null group by location order by 1



select * from CovidVaccinations


--new table covid vaccination
select * from CovidDeaths dea
join CovidVaccinations vac
on Dea.location = Vac.location
and Dea.date= Vac.date

select dea.location, dea.population, dea.date,dea.continent, vac.new_vaccinations from CovidDeaths dea
join CovidVaccinations vac
on Dea.location = Vac.location
and Dea.date= Vac.date
where dea.continent is not null
order by 1,2

--total vaccinations doses
select dea.continent,dea.location, dea.date,dea.population, vac.new_vaccinations, 
sum(cast(new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date) as rollingpeoplevaccinated
from CovidDeaths dea
join CovidVaccinations vac
on Dea.location = Vac.location
and Dea.date= Vac.date
where dea.continent is not null

order by 2, 3

--total doses administered by locations


select max(cast(vac.total_vaccinations as int)), dea.location, dea.population from CovidDeaths 
join CovidVaccinations 
on Dea.location = Vac.location
and Dea.date= Vac.date
where dea.continent is not null 
group by dea.location dea.population
order by 2




select dea.continent,dea.location, dea.date,dea.population, vac.new_vaccinations, 
sum(cast(new_vaccinations as int)) over(partition by dea.location order by dea.date,dea.location) as rollingpeoplevaccinated
from CovidDeaths dea
join CovidVaccinations vac
on Dea.location = Vac.location
and Dea.date= Vac.date
where dea.continent is not null

order by 2, 3 


--cte

with populationvaccinated (continent, location, date, population, New_vaccinations, rollingpeoplevaccinated)
as
(
select dea.continent,dea.location, dea.date,dea.population, vac.new_vaccinations, 
sum(cast(new_vaccinations as int)) over(partition by dea.location order by dea.date,dea.location) as rollingpeoplevaccinated
--rollingpeoplevaccinated/population*100 as percentagepeoplevaccinated
from CovidDeaths dea
join CovidVaccinations vac
on Dea.location = Vac.location
and Dea.date= Vac.date
where dea.continent is not null 
)
select * , rollingpeoplevaccinated/population*100 as percentagepeoplevaccinated from populationvaccinated order by location