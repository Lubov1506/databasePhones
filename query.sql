SELECT * FROM users 
WHERE is_subscribe = true;

SELECT *,(
    CASE
    WHEN is_subscribe = true THEN 'subscribe'
    ELSE 'not subscribe'
    END
) AS "is_subscribe"
FROM users 

SELECT * ,(
    CASE EXTRACT ('month' from birthday)
    WHEN 1 THEN 'winter'
    WHEN 2 THEN 'winter'
    WHEN 3 THEN 'spring'
    WHEN 4 THEN 'spring'
    WHEN 5 THEN 'spring'
    WHEN 6 THEN 'summer'
    WHEN 7 THEN 'summer'
    WHEN 8 THEN 'summer'
    WHEN 9 THEN 'autumn'
    WHEN 10 THEN 'autumn'
    WHEN 11 THEN 'autumn'
    WHEN 12 THEN 'winter'
    END
) AS "season"
FROM users

SELECT first_name, birthday , (
    CASE 
    WHEN extract(year from age("birthday")) <=30 THEn 'not adult'
    ELSE 'adult'
    END
) AS "age status"
FROM users


SELECT brand , (
    CASE 
    WHEN brand ILIKE 'iphone' THEN 'APPLE'
    ELSE 'other'
    END
) AS "manufacturer"
FROM phones;

SELECT price, (
    CASE
    WHEN price < 5000 THEN 'cheap'
    WHEN price >= 8000 THEN 'flagman'
    ELSE 'middle'
    END
) AS "class"
FROM phones;
 
SELECT avg(price)
FROM phones

SELECT price, (
    CASE
    WHEN price < (
        SELECT  avg(price)
        FROM phones
    ) THEN 'cheap'
    ELSE 'expensive'
    END
) AS "price class"
FROM phones;

SELECT u.id,u.email, u.first_name, u.last_name,count(u.id), (
    CASE 
    WHEN count(u.id) > 3 THEN 'constant buyer'
    WHEN count(u.id) > 2 THEN 'active buyer'
    ELSE 'buyer'
    END
)
FROM users AS u 
JOIN orders AS o
ON u.id=o.user_id
GROUP BY u.id;

ALTER TABLE phones 
ADD COLUMN "descr" text;

SELECT model, price, COALESCE (descr, 'not available')
FROM phones;

SELECT * FROM users AS u 
WHERE u.id NOT IN(SELECT user_id FROM orders); -- everywhen not buy

SELECT * FROM users AS u 
WHERE u.id IN(SELECT user_id FROM orders) --everywhen buy

SELECT * from phones AS p 
WHERE p.id NOT IN (SELECT phone_id FROM orders_to_phones);

SELECT EXISTS(
    SELECT * FROM users
WHERE users.id = 2006)


SELECT * FROM users AS u
WHERE EXISTS(
    SELECT *
    FROM orders
    WHERE u.id=orders.user_id
)

SELECT * FROM phones AS p
WHERE p.id !=ALL( 
    SELECT phone_id
    FROM orders_to_phones
)


