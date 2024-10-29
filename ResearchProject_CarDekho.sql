/* Business Questions
1. What cars can Customers get who look for superior cars i.e luxury brand cars for their status.
  ( Find cars that has has the highest value and cars which are in the top 10 in terms of their selling price )

2.  How many options do customers have in a particular fuel category. For Eg : Petrol , Diesel, Electric, CNG, LPG

3. How to filter out cars for customers according to their budget.
   ( Create categories for different price segment such as cars below 2lacs are cheap, 2L-4L is Average, 4L-8L is Medium High, 
   8L-15L is High, 15L-25L is Expensive 25L-50L is VeryExpensive and above 50L is Luxurious Expensive and update the table with
   a column ccalled 'Price_Segment' )

4. How is the selling price affected depending on the seller type i.e Individual seller or Dealer

5. What type of transmission is more available in the market. For eg : Manual or Automatic
   And which one should the customer go to according to their budget
   ( Avg Price difference between manual and automatic, Customer's price category for their desired car with desired transmission )

6. What can customers expect the average driven kms of the cars they are looking for?
   ( What are the average kilometers driven by cars before they are resold? )

7. What price range can the customers expect if the car is below 5 years or older than 5 years?
   ( Find the avg price of the cars below 5 yrs and above 5 yrs )

8. Which models can customers look forward to if they are looking for mileage oriented cars?
   ( List the top 10 Cars with the best Mileage? )

9. How does vehicle age impact selling price? Is the age and price directly related or inversly related to Eachother?

10. What are the options available for customers if they are looking for cars which have more than 5 seating capacity
   ( List cars with more than 5 seating capacity )
   
11. Car-Enthusiasts who look for sportiness and Maximum power out of their car with certain budget. What are the options available from them.
   ( List of cars with more than 190max_power, price range between 10 lacs to 25 lacs and the kms driven is below 50K )
*/


create database cardekho;
use cardekho;

-- 1 

select brand, count(brand) as No_Of_Cars_Available, avg(selling_price) as Avg_Resale_Value
from cardekho
group by brand
order by Avg_Resale_Value desc
limit 10;

select count(brand) as TotalCars, brand
from cardekho
group by brand
limit 10 ;

-- 2
SELECT Fuel_type, COUNT(*) AS fuel_count
FROM cardekho
GROUP BY Fuel_type
ORDER BY fuel_count DESC;

-- 3
select brand, avg(selling_price) AS avg_selling_price, count(model) as Noofcars
from cardekho
group by brand
order by avg_selling_price desc;

-- Let's create categories for different price segment such as cars below 2lacs are cheap, 2L-4L is Average, 4L-8L is Medium High, 
-- 8L-15L is High, 15L-25L is Expensive, 25L-50L is VeryExpensive and above 50L is Luxurious Expensive

select car_name, brand, selling_price, case
                                            when selling_price < 200000 then "Cheap"
                                            when selling_price between 200001 and 400000 then "Average"
                                            when selling_price between 400001 and 800000 then "Medium High"
                                            when selling_price between 800001 and 1500000 then "High"
                                            when selling_price between 1500001 and 2500000 then "Very Expensive"
                                            Else "Luxurious Expensive"
                                            end as category
from cardekho
order by category;

ALTER TABLE cardekho
ADD COLUMN price_segment VARCHAR(20);

UPDATE cardekho
SET price_segment = CASE
                         when selling_price < 200000 then "Cheap"
                                            when selling_price between 200001 and 400000 then "Average"
                                            when selling_price between 400001 and 800000 then "Medium High"
                                            when selling_price between 800001 and 1500000 then "High"
                                            when selling_price between 1500001 and 2500000 then "Very Expensive"
                                            Else "Luxurious Expensive"
                                            end ;
               

-- 4 

SELECT car_name,
       SUM(CASE WHEN seller_type = 'Individual' THEN 1 ELSE 0 END) AS No_individual_sellers,
       SUM(CASE WHEN seller_type = 'Dealer' THEN 1 ELSE 0 END) AS No_Of_dealers,
       AVG(selling_price) AS avg_selling_price
FROM cardekho
GROUP BY car_name
order by avg_selling_price asc;

SELECT Car_Name, 
    AVG(CASE WHEN Seller_Type = 'Individual' THEN selling_Price END) AS Avg_Individual_Selling_Price,
    AVG(CASE WHEN Seller_Type = 'Dealer' THEN selling_Price END) AS Avg_Dealer_Selling_Price
FROM cardekho
GROUP BY Car_Name;


select seller_type, avg(selling_price) as avgsp
from cardekho
group by seller_type;
-- Avg Selling price of dealers is 40% more than the Avg Selling Price of Individual Sellers

-- 5 
select  transmission_type ,count(transmission_type) as NoOfCars
from cardekho
group by transmission_type;

-- 6 
select brand, avg(km_driven) as AvgKMDriven
from cardekho
group by brand
order by avgkmdriven ASc;

-- 7 
SELECT 
    CASE 
        WHEN vehicle_age < 5 THEN 'Newer (Under 5 Years)'
        ELSE 'Older (5 Years and Above)'
    END AS age_group,
    COUNT(*) AS total_cars,
    AVG(selling_price) AS avg_selling_price
FROM cardekho
GROUP BY age_group
ORDER BY age_group;

-- 8 
SELECT car_name, MAX(mileage) AS highest_mileage, fuel_type
FROM cardekho
GROUP BY car_name, fuel_type
ORDER BY highest_mileage DESC
LIMIT 20;

-- 9
select vehicle_age, avg(selling_price) as AvgSellingPrice
from cardekho
group by vehicle_age
order by vehicle_age asc;
-- Therefore More the vehicle age, Lesser the selling price. Vehicle age and selling price is inversely related to eachother.

-- 10 
select distinct(car_name), seats, avg(selling_price) as Avgsellingprice
from cardekho 
where seats > 5 
group by car_name, model, seats
order by Avgsellingprice asc; 

-- 11
SELECT DISTINCT(car_name), max_power, km_driven, selling_price
FROM cardekho
WHERE selling_price BETWEEN 1000000 AND 2500000
      and max_power > 190
      and km_driven < 50000
ORDER BY selling_price ASC;