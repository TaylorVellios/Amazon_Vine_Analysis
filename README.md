# Amazon_Vine_Analysis
ETL and Analysis on Amazon Review Data using AWS, Postgres, and PySpark

# Overview
Comparing the product reviews for Musical Instruments on Amazon from users part of the Vine program and normal consumers.</br>
Is there a noticeable review bias in the star-rating distribution between these two groups of reviewers?
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

Using some clever SQL, we can get the outputs below from our filtered tables:</br>
````<SQL>
SELECT COUNT(review_id) Total_Reviews, COUNT(case when star_rating = 5 then 1 end) as Five_Star_Reviews,
CAST(COUNT(case when star_rating = 5 then 0 end) AS FLOAT)/CAST(COUNT(review_id) AS FLOAT)*100 as Five_Star_Percent
	FROM vine_table_Y;
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
According to my study, there is NO positivity bias between reviews who are part of the Vine program and those that are not.</br>
Based on the percentages seen above, there is not enough evidence to suggest a meaningful difference between these groups.</br>

While we have confirmed that 5-Star reviews are not significantly different, but what about negative reviews?</br>
Using 2 and 1 Star reviews as our basis for what can be considered "Negative", we will do the same thing above with a few minor adjustments.</br>

````
SELECT COUNT(review_id) as total_reviews, 
COUNT(case when star_rating <=2 then 1 end) as negative_reviews,
CAST(COUNT(CASE WHEN star_rating <=2 then 1 end) AS FLOAT)/CAST(COUNT(review_id) AS FLOAT)*100 as Percent
FROM vine_table
WHERE vine = 'Y'
AND total_votes >= 20
AND CAST(helpful_votes AS FLOAT)/CAST(total_votes AS FLOAT)*100 >= 50;
-- -------------------------------------------------------------------------------------
SELECT COUNT(review_id) as total_reviews, 
COUNT(case when star_rating <=2 then 1 end) as negative_reviews,
CAST(COUNT(CASE WHEN star_rating <=2 then 1 end) AS FLOAT)/CAST(COUNT(review_id) AS FLOAT)*100 as Percent
FROM vine_table
WHERE vine = 'N'
AND total_votes >= 20
AND CAST(helpful_votes AS FLOAT)/CAST(total_votes AS FLOAT)*100 >= 50;
````
</br>
Returns the Following Outputs:</br>

|total_reviews|negative_reviews|percent|
|-------------|----------------|-------|
|60|1|1.6666666666666667|

and:

|total_reviews|negative_reviews|percent|
|-------------|----------------|-------|
|14477|2286|15.790564343441321|

Respectively....</br>

Immediately we can see the glaring difference between the 1.6% Negative Review % for Vine Reviewers against the 15.79% Negative rate by the average consumer.</br>

Using R. we can see a significant difference in distribution in the 1-Star to 4-Star range between these two reviewer groups:</br>
Vine: Y</br>
![vinesY](https://user-images.githubusercontent.com/14188580/122311154-2e006380-ced7-11eb-8b69-5d002f55512d.png)

</br>
Vine: N</br>
![vinesN](https://user-images.githubusercontent.com/14188580/122311161-322c8100-ced7-11eb-945a-aed83d0625e8.png)

</br>
The key takeaways:
* While 5-Star reviews are evenly spread, it is significantly more likely that a Non-Vine reviewer would leave a 1-Star Review
* Vine Reviews trend logarithmically upwards to 5-Stars, whereas Non-Vine reviewers are relatively flat before a large spike at 5-Stars



