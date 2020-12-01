# == Schema Information
#
# Table name: countries
#
#  name        :string       not null, primary key
#  continent   :string
#  area        :integer
#  population  :integer
#  gdp         :integer

require_relative './sqlzoo.rb'

def highest_gdp
  # Which countries have a GDP greater than every country in Europe? (Give the
  # name only. Some countries may have NULL gdp values)
  execute(<<-SQL)
  SELECT name
  FROM countries
  WHERE gdp >
    (SELECT MAX(gdp)
    FROM countries
    WHERE continent = 'Europe'
    )
  SQL
  # execute(<<-SQL)
  # SELECT SUM(gdp)
  #   FROM countries
  #   WHERE continent = 'Europe'
  #   GROUP BY continent
  # SQL
end

def largest_in_continent
  # Find the largest country (by area) in each continent. Show the continent,
  # name, and area.
  execute(<<-SQL)
    SELECT c.continent, c.name, c.area
    FROM countries AS c
    WHERE (c.continent, c.area) IN
      (SELECT continent, MAX(area) AS area
      FROM countries
      GROUP BY continent)
    SQL
end

def large_neighbors
  # Some countries have populations more than three times that of any of their
  # neighbors (in the same continent). Give the countries and continents.
  
  execute(<<-SQL)

  SELECT c.name, c.continent
  FROM countries as c
  WHERE c.population > 3 * (
    SELECT MAX(c2.population) 
    FROM countries as c2
    WHERE c2.continent = c.continent AND c2.name != c.name
  )
  SQL
end