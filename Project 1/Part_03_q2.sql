select country,count(*) from table_youtube_final 
where title like '%BTS%' 
group by country  
order by count(*) desc;


