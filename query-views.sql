SELECT * FROM users
WHERE weight IS NULL;

--------

SELECT * FROM users
WHERE is_subscribe = true;

/* 
Task: change is_subscribe
false = not subscribed,
true = subscribed;
*/

/*    1.
CASE
    WHEN condition THEN result
    WHEN condition2 THEN result2
    ELSE result3
END

*/

SELECT users.id, users.email, (
    CASE 
    WHEN is_subscribe = true THEN 'subscribed'
    ELSE 'not subscribed'
    END
) AS "is_subscribe"
FROM users;

/*

Task: add a season column

*/

/* 2

CASE expression
    WHEN case1 THEN result1
    WHEN case1 THEN result2
END

*/
SELECT *, ( 
    CASE extract('month' from birthday)
    WHEN 1 THEN 'winter'
    WHEN 2 THEN 'winter'
    WHEN 3 THEN 'spring'
    WHEN 4 THEN 'spring'
    WHEN 5 THEN 'spring'
    WHEN 6 THEN 'summer'
    WHEN 7 THEN 'summer'
    WHEN 8 THEN 'summer'
    WHEN 9 THEN 'fall'
    WHEN 10 THEN 'fall'
    WHEN 11 THEN 'fall'
    WHEN 12 THEN 'winter'
    END
) AS "season"
FROM users;

-------

SELECT *, (
    CASE
    WHEN extract('year' from age("birthday")) <= 30
    THEN 'not adult'
    ELSE 'adult'
    END 
) AS "age status"
FROM users;



/* 
Task: Если бренд телефона - iPhone, то в столбце manufacturer указать APPLE,
иначе - 'other'

*/

SELECT *, (
    CASE
    WHEN brand ILIKE 'iphone' THEN 'Apple'
    ELSE 'other'
END 
) AS "manufacturer" 
FROM phones;


SELECT * FROM phones
ORDER BY price DESC;

/* 

price < 5k - 'cheap'
price > 8k - 'flagman'
price >5k, <8k - 'middle'

*/


SELECT *, (
    CASE
    WHEN price < 5000 THEN 'cheap'
    WHEN price > 8000 THEN 'flagman'
    ELSE 'middle'
END
) AS "price class"
FROM phones;


/* 

For all phones > average phone price - 'expensive'
< - 'cheap'
*/

SELECT avg(price) FROM phones;

--1

WITH "avg_price" AS (
    SELECT avg(price) AS "avg"
    FROM phones
    )
SELECT *, (
    CASE 
    WHEN price > "avg" THEN 'expensive'
    ELSE 'cheap'
END
    ) AS "price status"
    FROM phones;


    --2

SELECT *, (
    CASE 
    WHEN price > (
        SELECT avg(price) 
        FROM phones
    ) THEN 'expensive'
    ELSE 'cheap'
    END
) AS "price status"
FROM phones;

--------


/* 
Вывести id, email, first_name, last_name
Если у пользователя больше 3 заказов - это постоянный покупатель
Если больше 2 - это активный покупатель
Если больше 0 - это покупатель

*/

SELECT u.id, u.email, ( 
    CASE
    WHEN count(o.id) > 3 THEN 'regular'
    WHEN count(o.id) > 2 THEN 'active'
    ELSE 'buyer'
END
) AS "client_status"
FROM users AS u
LEFT JOIN orders AS o 
ON u.id = o.user_id
GROUP BY u.id, u.email;


/* 
COALESCE - возвращает первый не null
*/

SELECT COALESCE (NULL, 12, 24);

SELECT COALESCE (NULL, NULL, NULL);


ALTER TABLE phones
ADD COLUMN "descr" text;


SELECT model, price, COALESCE(descr, 'not available') AS "description"
FROM phones;


--------

/*
NULLIF (12, 12) - NULL
NULLIF (12, NULL) - 12
NULLIF (15, 24) - 15
NULLIF (NULL, NULL) - NULL

*/

------

/* GREATEST, LEAST */

GREATEST (2, 3, 5, 1, 2, 77) --77

LEAST(44, 23, 11, 2) -- 2

-----

/* Выражение Подзапросов */

/*

IN - NOT IN
SOME/ANY
EXISTS 

*/


/*

Task: Выбрать всех пользователей, которые не делали заказы.

*/

SELECT * FROM users AS u
WHERE u.id NOT IN (
    SELECT user_id 
    FROM orders
);


/* Old good task:
найти все телефоны, которые никто не заказывал

*/

SELECT * FROM phones AS p
WHERE p.id NOT IN (
    SELECT phone_id 
    FROM orders_to_phones
);


-----------

/* EXISTS */

SELECT EXISTS(
    SELECT * FROM users
WHERE users.id = 20);


-------

/* Делал ли пользователь заказ */

SELECT * FROM users AS u
WHERE EXISTS( --подзапрос делается на каждую строку 
    SELECT * 
    FROM orders
    WHERE u.id = orders.user_id
);

------------

/*

ANY/SOME - если для любой строки в подзапросе условие удовлетворяется, то вернется true, иначе - false

*/

----------


/* ALL - возвращает true, если условие истинно сразу для всех строк подзапроса, и false, если для кого-то - нет */

SELECT * 
FROM phones AS p 
WHERE p.id != ALL (
    SELECT "phone_id" 
    FROM orders_to_phones
    );




/* VIEWS - виртуальные таблицы */

SELECT * FROM users;

SELECT u.*, count(o.id) AS "order_amount"
FROM users AS u 
JOIN orders AS o 
ON u.id = o.user_id
GROUP BY u.id, u.email;

CREATE OR REPLACE VIEW "users_with_order_amounts" AS (
    SELECT u.*, count(o.id) AS "order_amount"
    FROM users AS u 
    LEFT JOIN orders AS o 
    ON u.id = o.user_id
    GROUP BY u.id, u.email
);

SELECT * FROM "users_with_order_amounts";

/*
WITH vs VIEWS

WITH возвращает табличное выражение
в рамках 1 запроса

WITH ... AS ()
SELECT ...;

*/

SELECT * FROM "users_with_order_amounts";

--- Заказы с их стоимостью

SELECT o.*, sum(p.price*otp.quantity) 
FROM orders AS o
JOIN orders_to_phones AS otp
ON o.id = otp.order_id
JOIN phones AS p
ON p.id = otp.phone_id
GROUP BY o.id;

------

DROP VIEW "orders_with_price";

CREATE VIEW "orders_with_price" AS (
    SELECT o.user_id, o.id, sum(p.price*otp.quantity) 
FROM orders AS o
JOIN orders_to_phones AS otp
ON o.id = otp.order_id
JOIN phones AS p
ON p.id = otp.phone_id
GROUP BY o.id
);

SELECT u.id, u.email, u.birthday  
FROM "orders_with_price" AS owp
JOIN users AS u
ON u.id = owp.user_id;

CREATE VIEW "spam_list" AS (
    SELECT u.id, u.email, u.birthday  
FROM "orders_with_price" AS owp
JOIN users AS u
ON u.id = owp.user_id
);


/*

Task:

1. Сделайте вью с полным именем, возрастом и гендером пользователей
2. Топ-10 самых дорогих покупок
3. Топ-10 юзеров с самым большим количеством заказов



*/