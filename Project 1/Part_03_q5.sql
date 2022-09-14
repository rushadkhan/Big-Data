select channeltitle, 
count(distinct video_id) as count 
from table_youtube_final 
group by channeltitle 
order by count(distinct video_id) desc limit 1;



