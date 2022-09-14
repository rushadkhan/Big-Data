select table_youtube_category.category_title
from table_youtube_category
group by category_title 
having count(country)=1;




