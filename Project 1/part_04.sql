select * from
(select * from
(select category_title, count(distinct trending_date), count(view_count) 
 from table_youtube_final 
 group by category_title 
 order by count(distinct trending_date) desc, 
 count(view_count) desc) 
 where category_title <> 'Entertainment' and category_title <> 'Music') limit 1;
 



select country, category_title 
from
(select *, row_number() over(partition by country order by country,distinct_trend_date desc,count desc) as x from
  (select * from
    (
      select country, category_title, count(distinct trending_date) as distinct_trend_date, count(view_count) as count from table_youtube_final group by country, category_title order by country, count(distinct trending_date) desc, count(view_count) desc) 
    where category_title <> 'Entertainment' and category_title <> 'Music') 
  order by country, distinct_trend_date desc, count desc) 
where x=1;



