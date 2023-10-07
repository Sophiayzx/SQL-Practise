create table appleStore_combined as
select * from applestore1
union all
select * from applestore2
union all
select * from applestore3
union all
select * from applestore4

**Exploratory data analysis**
-- Check the number of unique apps in both tableAppleStore

Select Count(Distinct id) as uniqueApplDs
from appleStore

Select Count (Distinct id) as uniqueApplDs
from appleStore_combined

--Check for any missing values in key fields

Select Count(*) As MissingValues
from appleStore
Where track_name Is null OR user_rating is null OR prime_genre is null

Select Count(*) As MissingValues
from appleStore_combined
Where app_desc Is null

--Find out the number of apps per genre
Select prime_genre, Count(*) as NumApps
from appleStore
Group by prime_genre
Order by Numapps DESC

--Get an overview of the apps" ratings
Select min(user_rating) as MinRating,
       max(user_rating) as MaxRating,
       avg(user_rating) as AvgRating
from appleStore

--Get the distribution of app prices
Select 
    (price/2) *2 as PriceBinStart,
    ((price/2)*2 + 2 as PriceBinEnd,
    Count(*) as NumApps
From appleStore

Group by PriceBinStart
Order by PriceBinStart



**Data Analysis**
--Determine whether paid apps have higher rating than free apps

Select Case
            when price > 0 then 'Paid'
            else 'Free'
        End as App_Type,
        avg(user_rating) as Avg_Rating
From appleStore
Group by App_Type


--Check if apps with more supported languages have higher ratings
Select Case
            When lang_num < 10 then '<10 languages'
            when lang_num Between 10 and 30 then '10-30 languages'
            else '>10 languages'
        end as language_bucket,
        avg(user_rating) as Avg_Rating
From appleStore
Group by language_bucket
Order by Avg_Rating DESC

--Check genres with low ratings
Select prime_genre,
        avg(user_rating) as Avg_Rating
From appleStore
Group by prime_genre
Order by Avg_Rating ASC
limit 10


--Check if there is correlation between the lenght of the app description and the user rating
Select
        when length(b.app_desc) < 500 Then "short"
        when length(b.app_desc) between 500 and 1000 then 'Medium'
        Else 'Long'
    End as description_length_buckets,
    avg(a.user_rating) as average_rating
    
From
    applestore as A
Join
    appleStore_combined as b
On
    a.od - b,id
    
Group By description_length_buckets
Order By average_rating DESC