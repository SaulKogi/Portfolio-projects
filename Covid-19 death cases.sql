
use PortfolioProject;


select * 
from CovidVaccination;

select *
from coviddeaths
where continent is not null
order by 3, 4;

select location, date, total_cases, new_cases, total_deaths, population 
from coviddeaths
where location = 'Nigeria'
and continent is not null;


--to select data we are goin to use

select location, date, total_cases, new_cases, total_deaths, population
from coviddeaths
where location = 'Nigeria'
and continent is not null;

--looking at total cases vs total deaths in Nigeria
--(question: how many cases do they have in Nigeria and how many deaths do they have?.)
--this shows likelyhood of dying if positive of covid-19.


select location, date, total_cases, total_deaths, cast(total_deaths as float) / cast(total_cases as float)*100 as deathpercentage
from coviddeaths
where location = 'Nigeria'
and continent is not null
order by 1,2;


--looking at the total_cases vs the poulation in Nigeria
-- this shows what percentage of population got covid

select location, date, total_cases, population, cast(total_cases as float) / population *100 as casepercentage
from coviddeaths
where location = 'Nigeria'
and continent is not null
order by 1,2;


--looking at country with highest infection rate compared to population


select location, population, max(total_deaths) as highest_count, max (cast(total_deaths as float) / population) *100 as deathpercentage
from coviddeaths
where location = 'Nigeria'
and continent is not null
group by location, population
order by  deathpercentage desc;


--showing countries  with highest death count 


select location, population, max (cast(total_deaths as float)) as Total_deaths_count
from coviddeaths
where continent is not null
group by location, population
order by  Total_deaths_count desc;


--LET'S BREAK THINGS DOWN BY CONTINENT

select location, max (cast(total_deaths as float)) as Total_deaths_count
from coviddeaths
where continent is null
and location not like '%income%'
group by location
order by  Total_deaths_count desc;



--showing the continent with the highest death count per population


select continent, max (cast(total_deaths as float)) as Total_deaths_count
from coviddeaths
where continent is not null
group by continent
order by  Total_deaths_count desc;



--GLOBAL NUMBERS

select date, sum(new_cases) as new_cases,
sum(cast(new_deaths as int)) as total_deaths,
case
when sum(new_cases)<> 0 then
(sum(cast(new_deaths as int)) * 100.0 / sum(new_cases))
else 0
end as deathpercentage
from coviddeaths
where continent is not null
group by date
order by date, total_deaths;

select sum(new_cases) as new_cases,
sum(cast(new_deaths as int)) as total_deaths,
case
when sum(new_cases)<> 0 then
(sum(cast(new_deaths as int)) * 100.0 / sum(new_cases))
else 0
end as deathpercentage
from coviddeaths
where continent is not null
--group by date
order by total_deaths;



--looking at the vaccination table

select *
from CovidVaccination;


select *
from CovidDeaths death
join CovidVaccination vaccination
on death . location = vaccination . location
and death . date = vaccination . date;


--looking at total popuilation vs vaccination
--(total number of people in the world that have been vaccinated)

select death.continent, death.location, death.date, death.population, vaccination.new_vaccinations
from CovidDeaths death
join CovidVaccination vaccination
on death . location = vaccination . location
and death . date = vaccination . date
where death.continent is not null
--and new_vaccinations is null
order by 2,3;


select death.continent, death.location, death.date, death.population, vaccination.new_vaccinations,
sum(convert(int, new_vaccinations)) over (partition by death.location
order by death.location, death.date) as total_vaccination
from CovidDeaths death
join CovidVaccination vaccination
on death . location = vaccination . location
and death . date = vaccination . date
where death.continent is not null
--and new_vaccinations is null
order by 2,3;



--using CTE


with PopvsVac (continent, location, date, population, new_vaccinations, total_vaccination)
as (
select death.continent, death.location, death.date, death.population, vaccination.new_vaccinations,
sum(convert(int, new_vaccinations)) over (partition by death.location
order by death.location, death.date) as total_vaccination
from CovidDeaths death
join CovidVaccination vaccination
on death . location = vaccination . location
and death . date = vaccination . date
where death.continent is not null
)
select *, (total_vaccination / population) * 100
from PopvsVac;



--creating view for later visualisations


 create view Total_Vacination as
 select death.continent, death.location, death.date, death.population, vaccination.new_vaccinations,
sum(convert(int, new_vaccinations)) over (partition by death.location
order by death.location, death.date) as total_vaccination
from CovidDeaths death
join CovidVaccination vaccination
on death . location = vaccination . location
and death . date = vaccination . date
where death.continent is not null;


create view Global_Numbers as
select sum(new_cases) as new_cases,
sum(cast(new_deaths as int)) as total_deaths,
case
when sum(new_cases)<> 0 then
(sum(cast(new_deaths as int)) * 100.0 / sum(new_cases))
else 0
end as deathpercentage
from coviddeaths
where continent is not null
--group by date
--order by total_deaths;