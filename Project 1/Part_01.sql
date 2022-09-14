CREATE DATABASE bdeat1;
USE DATABASE bdeat1;

DROP STORAGE INTEGRATION azure_bdeat1;

CREATE STORAGE INTEGRATION azure_bdeat1
TYPE = EXTERNAL_STAGE
STORAGE_PROVIDER = AZURE
ENABLED = TRUE
AZURE_TENANT_ID = 'e8911c26-cf9f-4a9c-878e-527807be8791'
STORAGE_ALLOWED_LOCATIONS = ('azure://utsrushad.blob.core.windows.net/bdeat1');

DESC STORAGE INTEGRATION azure_bdeat1;

CREATE OR REPLACE STAGE stage_bdeat1
STORAGE_INTEGRATION = azure_bdeat1
URL='azure://utsrushad.blob.core.windows.net/bdeat1';

list @stage_bdeat1;

CREATE OR REPLACE EXTERNAL TABLE external_table
WITH LOCATION = @stage_bdeat1
FILE_FORMAT = (TYPE=CSV)
PATTERN = '.*[.]csv';

Select *
  FROM bdeat1.PUBLIC.external_table
LIMIT 100;

select * from external_table;

CREATE OR REPLACE FILE FORMAT file_format_csv 
TYPE = 'CSV' 
FIELD_DELIMITER = ',' 
SKIP_HEADER = 1
NULL_IF = ('\\N', 'NULL', 'NUL', '')
FIELD_OPTIONALLY_ENCLOSED_BY = '"'
;


create or replace external table category_trend 
(
  video_id varchar as(value:c1::varchar),
  Title varchar as(value:c2::varchar),
  PublishedAt date as(value:c3::date),
  ChannelId varchar as(value:c4::varchar),
  ChannelTitle varchar as(value:c5::varchar),
  CategoryId varchar as(value:c6::varchar),
  Trending_date date as(value:c7::date),
  view_count int as(value:c8::int),
  likes int as(value:c9::int),
  dislikes int as(value:c10::int),
  comment_count int as(value:c11::int),
  comments_disabled boolean as(value:c12::boolean)   
)
with location =@stage_bdeat1
FILE_FORMAT = file_format_csv
PATTERN = '.*[.]csv';


create or replace table table_youtube_trending as
select 
value:c1::varchar as video_id,
value:c2::varchar as Title,
value:c3::date as PublishedDate,
value:c4::varchar as Channel,
value:c5::varchar as ChannelTitle,
value:c6::varchar as CategoryId,
value:c7::date as Trending_date,
value:c8::int as View_count,
value:c9::int as likes,
value:c10::int as dislikes,
value:c11::int as comment_count,
value:c12::boolean as comments_disabled,
split_part(metadata$filename, '_',1) as COUNTRY
from category_trend;



list @stage_bdeat1;

CREATE OR REPLACE EXTERNAL TABLE external_table2
WITH LOCATION = @stage_bdeat1
FILE_FORMAT = (TYPE=JSON)
PATTERN = '.*[.]json';

SELECT *
  FROM bdeat1.PUBLIC.external_table2
LIMIT 100;

CREATE OR REPLACE table table_youtube_category as
SELECT
split_part(metadata$filename, '_',1) as COUNTRY,
a.value:kind::varchar as Kind,
a.value:etag::varchar as eTag,
a.value:id::int as CATEGORYID,
s.value:title::varchar as CATEGORY_TITLE
from external_table2, lateral flatten(value) l, lateral flatten (l.value) a, lateral flatten(a.value) s;


select * from table_youtube_category; 


create or replace table table_youtube_final as
select 
uuid_string() as id,
table_youtube_trending.video_id,
table_youtube_trending.title,
table_youtube_trending.publisheddate,
table_youtube_trending.channel,
table_youtube_trending.channeltitle,
table_youtube_trending.categoryid,
table_youtube_category.category_title,
table_youtube_trending.trending_date,
table_youtube_trending.view_count,
table_youtube_trending.likes,
table_youtube_trending.dislikes,
table_youtube_trending.comment_count,
table_youtube_trending.comments_disabled,
table_youtube_trending.country
from table_youtube_trending 
left join table_youtube_category 
where table_youtube_trending.country = table_youtube_category.country 
and table_youtube_trending.categoryid = table_youtube_category.categoryid;

