SELECT *
FROM 
netflix_titles
INNER JOIN 	show_director
ON netflix_titles.show_id = show_director.show_id
INNER JOIN directors
ON directors.Director_ID = show_director.Director_Id