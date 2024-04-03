-- A. Pizza Metrics
-- How many pizzas were ordered?

SELECT COUNT(order_id) AS order_count
FROM customer_orders;

-- How many unique customer orders were made?
select count(distinct order_id) AS unique_order_count
FROM customer_orders;

-- How many successful orders were delivered by each runner?
select runner_id,
count(order_id) as successful_orders
FROM runner_orders
where pickup_time<>'null'
GROUP BY runner_id;

-- How many of each type of pizza was delivered?
SELECT co.pizza_id,
       COUNT(co.order_id) AS number_delivered
FROM customer_orders co
INNER JOIN runner_orders ro ON co.order_id = ro.order_id
WHERE ro.pickup_time<>'null'
GROUP BY co.pizza_id;

-- How many Vegetarian and Meatlovers were ordered by each customer?
SELECT co.customer_id,
       SUM(CASE WHEN pn.pizza_name = 'Meatlovers' THEN 1 ELSE 0 END) AS Meatlovers_count,
       SUM(CASE WHEN pn.pizza_name = 'Vegetarian' THEN 1 ELSE 0 END) AS Vegetarian_count
FROM customer_orders co
JOIN pizza_names pn ON co.pizza_id = pn.pizza_id
WHERE pn.pizza_name IN ('Meatlovers', 'Vegetarian')
GROUP BY co.customer_id
ORDER BY co.customer_id;

-- What was the maximum number of pizzas delivered in a single order?
SELECT ro.order_id,
count(pizza_id) pizzas
FROM runner_orders as RO
INNER JOIN customer_orders as CO on RO.order_id = CO.order_id
WHERE pickup_time<>'null'
GROUP BY ro.order_id
ORDER BY count(pizza_id) DESC
LIMIT 1;

-- For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
SELECT co.customer_id,
       SUM(CASE WHEN co.exclusions <> 'null' OR co.extras <> 'null' THEN 1 ELSE 0 END) AS pizzas_with_changes,
       SUM(CASE WHEN co.exclusions = 'null' AND co.extras = 'null' THEN 1 ELSE 0 END) AS pizzas_no_changes
FROM customer_orders co
JOIN runner_orders ro ON co.order_id = ro.order_id
WHERE ro.pickup_time<>'null'
GROUP BY co.customer_id;

-- How many pizzas were delivered that had both exclusions and extras?

SELECT COUNT(*) AS pizzas_with_exclusions_and_extras
FROM (
    SELECT co.order_id
    FROM customer_orders co
    JOIN runner_orders ro ON co.order_id = ro.order_id
    WHERE ro.pickup_time <> 'null'
      AND (co.exclusions <> 'null'
      AND co.exclusions <> ''
      AND co.exclusions is not null)
      AND (co.extras <> 'null'
    AND co.extras <> ''
    AND co.extras is not null)
    GROUP BY co.order_id
    HAVING COUNT(*) > 0
) AS pizzas_with_both;

-- What was the total volume of pizzas ordered for each hour of the day?
SELECT HOUR(order_time) AS order_hour,
       COUNT(*) AS total_pizzas_ordered
FROM customer_orders
GROUP BY order_hour
ORDER BY order_hour;

-- What was the volume of orders for each day of the week?
SELECT DAYOFWEEK(order_time) AS order_day_of_week,
       COUNT(*) AS order_volume
FROM customer_orders
GROUP BY order_day_of_week
ORDER BY order_day_of_week;