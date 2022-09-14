select Tab1.Day as year_month, Tab1.country, Tab2.channeltitle, Tab1.title, Tab1.views as view_count, Tab2.category_title, 
Tab1.likes_ratio from
(select *, round((likes*100/views), 2) as likes_ratio from
  (select *, row_number() over(partition by country, day 
                               order by views desc) as rank
    from(
      select  date(concat('1/',month, '/' , year)) as day, views, country, title, likes
      from
      (select year(trending_date) as year, month(trending_date) as month, sum(view_count) as views, 
       title, country, sum(likes) as likes
        from table_youtube_final 
       group by country, title, year(trending_date), month(trending_date)) 
        order by country, year, month) 
    order by country, day, views desc) where rank=1) as Tab1 left join table_youtube_final as Tab2 on Tab1.title=Tab2.title 
    group by Tab1.country, Tab1.title, year_month, Tab2.category_title, Tab2.channeltitle, Tab1.views, Tab1.likes_ratio 
    order by year_month, Tab1.country;
    
    
    