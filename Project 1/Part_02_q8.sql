DELETE FROM table_youtube_final
WHERE EXISTS( SELECT 1 
             FROM TABLE_YOUTUBE_DUPLICATES 
             Where table_youtube_final.id = Table_youtube_duplicates.id);
             
             
             