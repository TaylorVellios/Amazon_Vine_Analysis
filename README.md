# Amazon_Vine_Analysis
ETL and Analysis on Amazon Review Data using AWS, Postgres, and PySpark

# Overview
Comparing the product reviews for Musical Instruments on Amazon from users part of the Vine program and normal consumers.</br>
Is there a noticeable difference in the star-rating distribution between these two groups of reviewers?
<br></br>
<hr>

# Results
Using review data [publically available](https://s3.amazonaws.com/amazon-reviews-pds/tsv/index.txt), I used PySpark to load the raw data into a dataframe.</br>
The available columns for the full dataset are as follows:</br>

![rawdata](https://user-images.githubusercontent.com/14188580/122304577-14f1b580-cecb-11eb-9584-3f90fdce6be6.PNG)

</br>
Using a database created via AWS, the raw data was parsed into 4 tables and pushed out to my local PostgreSQL server connected to the AWS RDS service.</br>
The table that we will be looking at for the remainder of this task is the vine_table:</br>

![vine_raw](https://user-images.githubusercontent.com/14188580/122305116-f344fe00-cecb-11eb-931d-308a8bd038ba.PNG)

</br>
Since we are only concerned with reviews that are deemed "helpful" (>= 20 votes), the details for our new dataset are as follows:</br>
#### *How many reviews in each population? (Vine: Y | Vine: N)*
* Vine Reviews: 60
* Non-Vine Reviews: 14,477

#### *How many of these reviews are 5-Stars?*
* 5-Star Vine Reviews:
* 5-Star Non-Vine Reviews: 

#### *What is the percent of 5-Star Reviews to Non-5-Star Reviews?*
* Vine Reviews: 56.67%
* Non-Vine Reviews: 56.72%

Using some clever SQL, we can get the outputs below:</br>
````
SELECT COUNT(review_id) Total_Reviews, COUNT(case when star_rating = 5 then 1 end) as Five_Star_Reviews,
CAST(COUNT(case when star_rating = 5 then 0 end) AS FLOAT)/CAST(COUNT(review_id) AS FLOAT)*100 as Five_Star_Percent
	FROM vine_table 
	WHERE vine = 'Y'
	AND total_votes >= 20;
````

Vine = 'Y'</br>
|total_reviews|five_star_reviews|    five_star_percent|
|-------------|-------------|------------------|
|           60|           34|56.666666666666664|

Vine = 'N'</br>
|total_reviews|five_star_reviews|   five_star_percent|
|-------------|-------------|-----------------|
|        14477|         8212|56.72445948746287

# Summary


