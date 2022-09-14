select  category_title 
from table_youtube_category
group by category_title 
having count(category_title)>1;



