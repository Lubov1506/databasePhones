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


/* sorting */

SELECT * FROM users
ORDER BY height, birthday ASC
LIMIT 10
OFFSET 100;

SELECT * FROM users
ORDER BY height, birthday ASC, first_name;

SELECT * FROM phones
ORDER BY quantity
LIMIT 10;

SELECT * FROM phones
ORDER BY price DESC;

SELECT first_name, extract('year' from age(birthday)) AS "Age" from users
ORDER BY  extract('year' from age(birthday)), first_name;

SELECT count(*), "Age" FROM
(SELECT first_name, extract('year' from age(birthday)) AS "Age" from users) AS "u_w_age"
GROUP BY "Age"
ORDER BY "Age";

/* filtering
HAVING */

SELECT count(*), "Age" FROM
(SELECT first_name, extract('year' from age(birthday)) AS "Age" from users) AS "u_w_age"
GROUP BY "Age"
HAVING count(*) >=10
ORDER BY count(*) DESC;


SELECT brand, sum(quantity) from phones
GROUP BY brand
HAVING sum(quantity) > 1000
ORDER BY brand
