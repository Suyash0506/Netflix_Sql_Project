-- Netflix Project

Create Table Netflix 
(
show_id	Varchar(6),
type	Varchar(10),
title	Varchar(150),
director	Varchar(210),
casts	Varchar(1000),
country	Varchar(150),
date_added	Varchar(50),
release_year	int,
rating	Varchar(10),
duration	Varchar(15),
listed_in	Varchar(100),
description	Varchar(250)
);

select * from netflix;

select 
count(*) as Total_Content
from netflix;

select
	distinct type
from netflix;

-- 15 Business Problems & Solutions

Select * From Netflix;

--Q1). Count the number of Movies vs TV Shows

Select 
	type,
	count(*) as Total_content
from netflix
group by type;


--Q2). Find the most common rating for movies and TV shows

Select type,rating
from (select 
			type,
			rating,
			count(*),
			rank() over(partition by type order by count(*) desc) as ranking
		from netflix
		group by 1,2) as t1
where ranking = 1;


--Q3). List all movies released in a specific year (e.g., 2020)

select * 
from netflix
where type = 'Movie' and release_year = 2020;


--Q4). Find the top 5 countries with the most content on Netflix

select 
	unnest(string_to_array(country,',')) as new_country,
	count (show_id) as total_content
from netflix
group by 1
order by total_content desc
limit 5;


--Q5). Identify the longest movie

select 
	type,
	max(duration) 
from netflix
group by 1
having type = 'Movie'


--Q6). Find content added in the last 5 years

select 
	* 
from netflix
where 
	to_date(date_added,'Month DD,YYYY') >= Current_Date - Interval '5 Years' 


--Q7). Find all the movies/TV shows by director 'Rajiv Chilaka'!

select * 
from netflix
where director like '%Rajiv Chilaka%';


--Q8). List all TV shows with more than 5 seasons

select * 
from netflix
where duration >= '5 Seasons' and type = 'TV Show';


--Q9). Count the number of content items in each genre

select 
	unnest(string_to_array(listed_in,',')),
	count(show_id) as total_content
from netflix
group by 1
order by 2 ;


--Q10).Find each year and the average numbers of content release in India on netflix
 		--return top 5 year with highest avg content release!

select 
	extract(year from To_Date(date_added, 'Month DD,YYYY')) as year,
	count(*) as yearly_count,
	round(
	count(*):: numeric / (select count(*) from netflix where country = 'India') :: numeric *100,2)
	as avg_content_per_year
from netflix
where country = 'India'
group by 1
order by avg_content_per_year desc
limit 5;


--Q11). List all movies that are documentaries

select * 
from netflix
where listed_in like '%Documentaries%';


--Q12). Find all content without a director

select * from netflix
where director is null;


--Q13). Find how many movies actor 'Salman Khan' appeared in last 10 years!

select * from netflix 
where 
	casts like '%Salman Khan%' and
	release_year > extract(year from current_date) - 10 ;


--Q14). Find the top 10 actors who have appeared in the highest number of movies produced in India.

select 
	unnest(string_to_array(casts,',')) as actors,
	count (*) as total_content
from netflix
where country ilike  '%india%'
group by 1
order by 2 desc
limit 10;


--Q15).
Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.

with new_table
as (
select 
*,
		case
		when
			description ilike '%kill%' or 
			description ilike '%violence%'
			then 'Bad_Content'
			else 'Good_Content'
		end category
from netflix
)
 select 
 	category,
	 count(*) as Total_content
	from new_table
	group by 1;































































