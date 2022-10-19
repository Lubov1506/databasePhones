SELECT sum(quantity) from orders_to_phones;

SELECT sum(quantity) from phones;

SELECT avg(price) from phones;

SELECT brand,avg(price) from phones
GROUP BY brand;

SELECT sum(quantity*price) FROM phones
WHERE price BETWEEN 1000 AND 2000;

SELECT brand, count(*) FROM phones
GROUP BY brand;

SELECT user_id, count(*) FROM orders
GROUP BY user_id
ORDER BY user_id;

SELECT avg(price) FROM phones
WHERE brand='Nokia';
