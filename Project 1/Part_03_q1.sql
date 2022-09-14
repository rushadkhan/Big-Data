select * from 
(select *,Rank() over(partition by country 
                      ORDER BY country asc) 
 as rank from table_youtube_final
 where trending_date = '2021-10-17' and category_title='Sports')
 where rank<4;
 
 
 
 