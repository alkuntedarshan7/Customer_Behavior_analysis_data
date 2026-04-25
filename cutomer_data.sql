select * from customer_data
# --TOTAL REVENUE BY EACH GENDER
select gender , sum(purchase_amount) as revenue
from customer_data
group by gender

# --cux who used discount but still paid more than avg purchase amount

SELECT customer_id, purchase_amount
FROM customer_data
WHERE discount_applied = 'Yes'
  AND purchase_amount >= (
 SELECT AVG(purchase_amount)
      FROM customer_data
  );
  
  #-- top 5 products with avg reveivw rating
  select item_purchased ,AVG(review_rating) as"Average Product Rating"
from customer_data
group by item_purchased
order by avg(review_rating) desc
limit 5;  
  
  #--compare the avg purchase amounts between standard and express Shipping.
select shipping_type,
round(AVG(purchase_amount))
from customer_data
where shipping_type in ('Standard','Express')
group by shipping_type

# subscirbed cx spend more ?? compare avg spend and total revenue betn subscribers and non-subscibers
select subscription_status,
COUNT(customer_id) as total_customers,
ROUND(AVG(purchase_amount),4) as avg_spend,
ROUND(SUM(purchase_amount),4) as total_revenue
from customer_data
group by subscription_status
order by total_revenue, avg_spend desc;

# product with high sales with discount appllied
select item_purchased,
round(100 * sum(case when discount_applied ='Yes'then 1 else 0 end)/count(*),2) as discount_rate
from customer_data
group by item_purchased
order by discount_rate desc
limit 7

# segment cx into new ,returning,loyal and count of each segment

with customer_type as(
select customer_id,previous_purchases,
case
  when previous_purchases = 1 then 'New' 
 when previous_purchases between 2 and 10 then 'Returning' 
else 'Loyal'
end as customer_segment
from customer_data
)
select customer_segment
  ,count(*) as 'no of customers'
from customer_type
group by customer_segment;

# top 3 most purchased products

with item_counts as(
select category,
item_purchased,
count(customer_id) as total_orders,
row_number() over ( partition by category order  by count(customer_id) desc
) as item_rank
from customer_data
group by category ,item_purchased
)
select item_rank , category ,item_purchased ,total_orders
from item_counts
where item_rank <= 3;
 
 # are repeat buyers are subscribers ??
 select subscription_status,
 count(customer_id) as repeat_buyers
 from customer_data 
 where previous_purchases > 7 
 group by subscription_status
 
 # revenue by age group
 select age_group,
 sum(purchase_amount) as total_revenue
 from customer_data
 group by age_group
 order by total_revenue desc;
 







































































