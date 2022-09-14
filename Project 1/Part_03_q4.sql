SELECT
Tab1.total_category_video, Tab1.country,  Tab2.total_country_video, Tab1.category_title,
round((Tab1.total_category_video*100/Tab2.total_country_video),2) AS percentage
FROM
(
  select country, category_title, total_category_video 
  from
  (select country, category_title, total_category_video, row_number() over(partition by country order by total_category_video desc) as x
    from
    (select  country, category_title, count(DISTINCT video_id ) as total_category_video
      from table_youtube_final group by country,category_title 
     order by country, count(DISTINCT video_id) desc) ) 
    where x=1) as Tab1 inner join
(
  select country, count(distinct video_id) as total_country_video from table_youtube_final group by country) as Tab2 on Tab1.country=Tab2.country;