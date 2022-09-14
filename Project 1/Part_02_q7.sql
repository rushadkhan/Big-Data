create or replace table table_yt_duplicate as
select row_number() over (partition by country, video_id, trending_date 
                          order by view_count desc) as rownumber, * from table_youtube_final;

create or replace table table_youtube_duplicates as 
select * from 
table_yt_duplicate 
where rownumber>1;

select * from table_youtube_duplicates;



