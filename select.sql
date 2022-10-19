/*
Create - INSERT - DML
Read - SELECT - DQL
Update - UPDATE - DML
Delete - DELETE - DML
*/

SELECT "id", "first_name", "last_name" FROM "users";

SELECT *
FROM "users"
WHERE "gender" = 'male';

/*

1. Получить всех юзеров, у которых четный id
2. Получить всех юзеров, у которых высота больше 1.5
3. Получить всех юзеров женского пола
4. Для тех, кто уже всё сделал -
Получить всех подписанных (subscribed) юзеров мужского пола выше 1.90

*/

SELECT * 
FROM "users"
WHERE "id" % 2 = 0;

SELECT * 
FROM "users"
WHERE "height" > 1.5;

SELECT * 
FROM "users"
WHERE "is_subscribe" = true AND "gender" = 'male' AND "height" > 1.8;

-----

SELECT * 
FROM "users"
WHERE "first_name" IN ('John', 'Jane', 'William');

 /* SELECT * 
FROM "users"
WHERE "first_name" = 'John' 
OR "firt_name" = 'Jane'
OR "first_name" = 'William';
*/

------


SELECT *
FROM "users"
WHERE "height" > 1.5 AND "height" < 1.9;

SELECT *
FROM "users"
WHERE "height" BETWEEN 1.5 AND 1.9;

-----

/*
Получить пользователей с id между 105 и 170
*/

SELECT *
FROM "users"
WHERE "id" BETWEEN 1000 AND 2000;

-------

SELECT *
FROM "users"
WHERE "first_name" LIKE 'K%';

SELECT *
FROM "users"
WHERE "first_name" LIKE '___';

/*
% - любое количество любых символов
_ - 1 любой символ

*/

ALTER TABLE "users"
ADD COLUMN "weight" int CHECK ("weight" != 0);

UPDATE "users"
SET "weight" = 60;

UPDATE "users"
SET "weight" = 65
WHERE "id" = 25;

UPDATE "users"
SET "weight" = 80
WHERE "height" > 1.8;

/*
Пример:
Таблица Employees
- id
- name
- salary
- work_hours


UPDATE "Employees"
SET "salary" = "salary" * 1,2
WHERE work_hours > 150;

*/


-----

DELETE FROM "users"
WHERE "id" = 5;

DELETE FROM "users"
WHERE "height" = 1.95;

SELECT * FROM "users";


------

UPDATE "users"
SET "weight" = 85
WHERE "id" = 12
RETURNING *;

DELETE FROM "users"
WHERE "id" = 6
RETURNING "id", "first_name", "last_name";

INSERT INTO users (first_name, last_name, email, gender, is_subscribe, birthday, height)
VALUES ('First Name', 'helrrrlo', 'rewer@tewerwert.com', 'male', true, '1999-05-10', 1.90)
RETURNING id;

--------


/*
1. Получить всех юзеров женского пола, имя которых начинается на "А".
2. Получить всех пользователей, которые родились в сентябре.
3. Получить всех, кому от 20 до 40 лет.
4. Получить всех совершеннолетних юзеров

*/


--4--

SELECT * FROM "users"
WHERE age("birthday") > make_interval(18);

SELECT * FROM "users"
WHERE extract('year' from "birthday") > 18;

--age(дата)
--make_interval(18)

--2--

SELECT * FROM "users"
WHERE extract('month' from "birthday") = 9;


--3--

SELECT * FROM "users"
WHERE age("birthday") > make_interval(20)
AND age("birthday") < make_interval(40);


------

SELECT * FROM "users"
WHERE extract('month' from "birthday") = 11 AND extract('day' from "birthday") = 10;

--Alias---

SELECT "id" AS "Порядковый номер", 
"first_name" AS "Имя", 
"last_name" AS "Фамилия", 
"email" AS "Почта"
FROM "users";


SELECT * FROM "users" AS "u"
WHERE "u"."id" = 99;


--Pagination---


SELECT * FROM "users"
LIMIT 15;

SELECT * FROM "users"
LIMIT 15
OFFSET 15;
/* OFFSET - отступ
*/


SELECT * FROM "users"
LIMIT 15
OFFSET 30;

/* OFFSET = LIMIT*page
*/


-----

SELECT "id", 
"first_name" || "last_name" AS "Full name"
FROM "users";


SELECT "id", 
"first_name" || ' ' || "last_name" AS "Full name"
FROM "users";

SELECT "id", 
concat("first_name", ' ', "last_name") AS "Full name"
FROM "users";


/*

Получить всех юзеров, у которых длина полного имени больше 15 символов

*/

SELECT "id", 
concat("first_name", ' ', "last_name") AS "Full name"
FROM "users"
WHERE char_length(concat("first_name", ' ', "last_name")) > 15;


SELECT * FROM
    (SELECT "id", 
    concat("first_name", ' ', "last_name") AS "Full name"
    FROM "users") AS "FN"
WHERE char_length("FN"."Full name") > 15;

------


SELECT * FROM "users"
WHERE extract('year' from age("birthday")) = 27;


----Агрегатные функции------

/*
avg - среднее арифметическое
sum - сумма всех значений
min - минимальное из значений
max - максимальное из значений
count - количество значений


*/


SELECT max("height") FROM "users";

SELECT min("height") FROM "users";

SELECT count(*) FROM "users";

SELECT avg("weight") FROM "users";

-----

SELECT avg("weight"), "gender"
FROM "users"
GROUP BY "gender";

SELECT max("weight"), "gender"
FROM "users"
WHERE extract('year' from age("birthday")) > 18
GROUP BY "gender";


SELECT count(*), "gender"
FROM "users"
WHERE extract('year' from age("birthday")) > 18
GROUP BY "gender";

/*
Практика:

1. Средний рост всех пользователей
2. Средний рост всех мужчин и женщин отдельно
3. Минимальный и максимальный рост мужчин и женщин
4. Количество юзеров, родившихся после 1998г.
5. Количество людей по определенному имени.
6. Количество людей в возрасте от 20 до 30 лет.


*/



SELECT avg(weight), gender 
FROM users
GROUP BY gender;



--  1. Посчитать количество телефонов, которые были проданы 
--  (то есть количестве телефонов в заказах).
 
 SELECT sum(quntity) FROM orders_to_phones;

--  2. Количество телефонов, которые есть на "складе".
SELECT sum(quntity) FROM phones;

--  3. Средняя цена всех телефонов
SELECT avg(price) FROM phones;

--  4. Средняя цена каждого бренда
SELECT avg(price), brand FROM phones
GROUP BY brand;

--  5. Стоимость всех товаров (цена*количество) 
--  на складе в диапазоне их цен от 1000 до 2000.
SELECT sum(quantity*price)
FROM phones
WHERE price BETWEEN 1000 AND 2000;


--  6. Количество моделей каждого бренда
SELECT count(*), brand FROM phones
GROUP BY brand;


-- проверяем
SELECT * FROM phones
WHERE brand = 'Nokia';

--  7. Количество заказов каждого пользователя, который совершал заказы.
SELECT count(*), user_id
FROM orders
GROUP BY user_id;
 
--  8. Средняя цена телефонов Nokia.
SELECT avg(price)
FROM phones
WHERE brand = 'Nokia';

/*

Фильтрация групп,
Сортировка

*/

SELECT * 
FROM phones
ORDER BY quantity ASC
LIMIT 10;


-- Sorting

/* 
ORDER BY field {ASC|DESC}
*/

-- по высоте, возр.

SELECT * 
FROM users
ORDER BY height ASC;

-- по высоте, если высота одинаковая - то по дате рождения

SELECT * 
FROM users
ORDER BY height ASC, birthday ASC ;

--если и высота, и дата рождения одинаковые, отсортируй еще и по имени, по нисходящей
SELECT * 
FROM users
ORDER BY height ASC, birthday ASC, first_name DESC ;



/*
2. Отсортируйте телефоны по цене, от самого дорогого до самого дешевого.
*/
SELECT * FROM phones
ORDER BY price DESC;

/*
1. Отсортируйте пользователей по возрасту (по количеству полных лет) и по имени, если они одногодки.
*/
SELECT *, extract('year' from age(birthday)) AS "Age"
FROM users
ORDER BY extract('year' from age(birthday)), first_name ASC;

--количестве одногодок

SELECT count(*), "Age" 
FROM
(SELECT *, 
extract('year' from age(birthday)) AS "Age"
FROM users) AS "u_w_age"
GROUP BY "Age"
ORDER BY "Age";

/*
Фильтрация групп
HAVING
*/

SELECT count(*), "Age" 
FROM
(SELECT *, 
extract('year' from age(birthday)) AS "Age"
FROM users) AS "u_w_age"
GROUP BY "Age"
HAVING count(*) >= 10
ORDER BY count(*) DESC;

/*
Извлечь все бренды, у которых количество телефонов > 1000, отсортировать по алфавиту
*/

SELECT sum(quantity), brand
FROM phones
GROUP BY brand
HAVING sum(quantity) > 1000;

/*
text pattern

LIKE
ILIKE

SIMILAR TO

~ -- регулярка
~* -- регулярка с игнором кейза

!~ - not 
!~* - not с игнором кейза

*/

SELECT * FROM users
WHERE first_name ILIKE 'A%'; --'Aba' 'aba'

--'%' = *
--'_' = .


SELECT * FROM users
WHERE first_name SIMILAR TO '%i{2}%';

SELECT * FROM users
WHERE first_name ~ '.*i{2}.*'; --регистрозависимый запрос

SELECT * FROM users
WHERE first_name ~* '.*i{2}.*'; --регистрозависимый запрос


/*
Среди всех сообщений в таблице "сообщения" найти слово "паровоз"
*/

SELECT * FROM "messages"
WHERE body ILIKE '%паровоз%';


/*

1. Выбрать 1 пользователя с самым длинным полным именем (full name)
*/

SELECT char_length(concat("first_name", ' ', "last_name")) AS "name length", * 
FROM users
ORDER BY "name length" DESC
LIMIT 1;


/*
2. Посчитать количество юзеров с одинаковой длиной полного имени, и отсеять те группы, где количество символов < 15
*/

SELECT char_length(concat("first_name", ' ', "last_name")) AS "name length", count(*)
FROM users
GROUP BY "name length"
HAVING char_length(concat("first_name", ' ', "last_name")) > 15
ORDER BY "name length";


/*
-------------

*/
DROP TABLE A;
DROP TABLE B;

CREATE TABLE A (
    v char(3),
    t int
);

CREATE TABLE B(
    v char(3)
);

INSERT INTO A VALUES 
('XXX', 1),('XXY', 1),('XXZ', 1),
('XYX', 2),('XYY', 2),('XYZ', 2),
('YXX', 3),('YXY', 3),('YXZ', 3),
('YZX', 3),('ZXY', 3),('ZZZ', 3);

INSERT INTO B VALUES 
('YXX'),('YXY'),('YXZ'),
('YZX'),('ZXY'),('AAA');

SELECT * FROM A;

SELECT * FROM B;

SELECT * FROM A,B; --декартово произведение

/* Объединение - 1 таблица + 2, повторяющиеся значения исключаются */
SELECT v FROM A
UNION
SELECT * FROM B;


/* Пересечение - только те значения, которые есть и в 1 таблице и во 2 */
SELECT v FROM A
INTERSECT
SELECT * FROM B;


/* Вычитание - только те значения А, которых нет в В */
SELECT v FROM A
EXCEPT
SELECT * FROM B;

SELECT * FROM B
EXCEPT
SELECT v FROM A;


--------

INSERT INTO users (
    first_name,
    last_name,
    email,
    gender,
    is_subscribe,
    birthday,
    height,
    weight
  )
VALUES (
    'Spiderman',
    'Guy',
    'email@.test',
    'male',
    TRUE,
    '2020/05/19',
    1.8,
    65
  ),
  (
    'Iron',
    'Man',
    'tony@.test',
    'male',
    TRUE,
    '2019/05/19',
    1.9,
    65
  )
  ;

  -----------

/* все юзеры, которые когда-либо делали заказы */

  SELECT "id" FROM "users"
  INTERSECT
  SELECT "user_id" FROM "orders";

  /* все юзеры, которые никогда заказов не делали*/
  
SELECT "id" FROM "users"
  EXCEPT
  SELECT "user_id" FROM "orders";

 
  -----

/* Соединение, но плохой код*/

  SELECT * FROM A,B
  WHERE A.v = B.v;

  SELECT A.v AS "model",
  A.t AS "id",
  B.v AS "brand"
  FROM A, B
  WHERE A.v = B.v;

  /* JOIN */

  SELECT * 
  FROM A JOIN B
  ON A.v = B.v;

  /* Предикат, чаще всего: PK => <= FK */

   /* Я хочу получить все заказы определенного юзера, вместе с инфой об этом юзере */

  SELECT * FROM users
  WHERE id = 2;

  SELECT * FROM orders
  WHERE user_id = 2;

SELECT * 
FROM users JOIN orders
ON orders.user_id = users.id
WHERE users.id = 2;

SELECT u.*, o.id AS "order number" 
FROM
users AS u 
JOIN orders AS o
ON o.user_id = u.id
WHERE u.id = 2;

-------------


SELECT * 
FROM A 
JOIN B ON A.v = B.v 
JOIN phones ON A.t = phones.id;


/* 
Найти id всех заказов, в которых есть телефон бренда Samsung

*/

SELECT o.id AS "Order number", p.model 
FROM orders AS o
JOIN orders_to_phones AS otp
ON o.id =otp.order_id
JOIN phones AS p
ON p.id = otp.phone_id
WHERE p.brand ILIKE 'samsung';



/* Посчитать, сколько моделей самсунга в каждом заказе
*/

SELECT o.id AS "Order number", count(p.model) 
FROM orders AS o
JOIN orders_to_phones AS otp
ON o.id =otp.order_id
JOIN phones AS p
ON p.id = otp.phone_id
WHERE p.brand ILIKE 'samsung'
GROUP BY o.id;

------------

INSERT INTO phones (brand, model, quantity, price)
VALUES (
    'FRESHPHONE',
    'X',
    3,
    30000
  );

  SELECT phone_id, p.model, sum(otp.quantity) AS "summary"
  FROM orders_to_phones AS otp
  JOIN phones AS p
  ON p.id = otp.phone_id
  GROUP BY phone_id, p.model
  ORDER BY phone_id;

  /*найти телефоны, которые никто никогда не покупал
  */

    SELECT phone_id, p.model
  FROM orders_to_phones AS otp
  RIGHT JOIN phones AS p
  ON p.id = otp.phone_id
  GROUP BY otp.phone_id, p.model
;

SELECT *
 FROM phones
 WHERE id NOT IN (SELECT phone_id 
 FROM orders_to_phones AS otp);

------

/*
Найти email всех пользователей, которые делали заказы

*/

SELECT DISTINCT users.email FROM users
JOIN orders 
ON users.id = orders.user_id;


SELECT users.email FROM users
JOIN orders 
ON users.id = orders.user_id
GROUP BY users.email;

/*  
Мейлы пользователей, котоыре покупали samsung
*/

SELECT u.email
FROM users AS u
JOIN orders AS o
ON u.id = o.user_id
JOIN orders_to_phones AS otp 
ON o.id = otp.order_id
JOIN phones AS p
ON otp.phone_id = p.id
WHERE p.brand ILIKE 'samsung'
GROUP BY u.email;


/*
Найти пользователей и их количество заказов

*/

SELECT count(o.id) AS "Order quantity", u.* 
FROM users AS u
LEFT JOIN orders AS o
ON o.user_id = u.id
GROUP BY o.user_id, u.id
ORDER BY "Order quantity";



/*

1. Найти стоимость каждого заказа
2. Найти количество заказов конкретного пользователя, вывести его email


*/

SELECT sum(otp.quantity*p.price), o.id
FROM orders AS o
JOIN orders_to_phones AS otp
ON o.id = otp.order_id
JOIN phones AS p
ON otp.phone_id = p.id
GROUP BY o.id;


/*
A + B

INNER JOIN - JOIN - общее в таблицах, которое удовлетворяет условие

LEFT [OUTER] JOIN - INNER JOIN + всё уникальное из А
RIGHT [OUTER] JOIN - INNER JOIN + всё уникальное из В

FULL OUTER - INNER + всё уникальное из А и В

*/


-----------



/*
Достать все заказы, в которых есть определенная модель определенного бренда

*/

SELECT otp.order_id AS "Order Number", p.brand, p.model
FROM orders_to_phones AS otp
JOIN phones AS p
ON otp.phone_id = p.id
WHERE p.brand ILIKE 'iphone' AND p.model ILIKE '5%'
;

/* Посчитать, сколько заказов этой модели */

SELECT count(*), p.brand, p.model
FROM orders_to_phones AS otp
JOIN phones AS p
ON otp.phone_id = p.id
WHERE p.brand ILIKE 'iphone' AND p.model ILIKE '5%'
GROUP BY p.model, p.brand
;


/*
1. Извлечь все купленные телефоны (бренд + модель) конкретного заказа
*/

SELECT p.brand, p.model
FROM orders_to_phones AS otp
JOIN phones as p
ON otp.phone_id = p.id
WHERE otp.order_id = 35;

SELECT * FROM orders_to_phones
WHERE order_id = 35;

/*
2. Количество позиций в определенном заказе
*/

SELECT count(*)
FROM orders_to_phones AS otp
JOIN phones as p
ON otp.phone_id = p.id
WHERE otp.order_id = 35
GROUP BY otp.order_id;


/*
3. Найти самый популярный телефон.
*/

SELECT sum(otp.quantity) as "amount", p.brand, p.model
FROM orders_to_phones AS otp
JOIN phones AS p
ON otp.phone_id = p.id
GROUP BY p.id
ORDER BY "amount" DESC
LIMIT 1;

/*
4. Вытащить всех пользователей и количество купленных ими моделей телефонов
*/

SELECT u.id AS "uid", 
p.id AS "pid"
FROM users AS u
JOIN orders AS o
ON u.id = o.user_id
JOIN orders_to_phones AS otp
ON o.id = otp.order_id
JOIN phones AS p
ON otp.phone_id = p.id
GROUP BY u.id, p.id;

SELECT count("pid"), "uid"
FROM (
  SELECT u.id AS "uid", 
p.id AS "pid"
FROM users AS u
JOIN orders AS o
ON u.id = o.user_id
JOIN orders_to_phones AS otp
ON o.id = otp.order_id
JOIN phones AS p
ON otp.phone_id = p.id
GROUP BY u.id, p.id
) AS "uid_w_pid"
GROUP BY "uid";

/* теперь есть айди, мейлы юзеров и количество заказанных ими моделей телефонов */
WITH users_with_count AS (
    SELECT u.*
    FROM users AS u
    JOIN orders AS o
    ON u.id = o.user_id
    JOIN orders_to_phones AS otp
    ON o.id = otp.order_id
    JOIN phones AS p
    ON otp.phone_id = p.id
)
SELECT count(*), uwc.id, uwc.email 
FROM users_with_count AS uwc
GROUP BY uwc.id, uwc.email;

/*
5. Средний чек по всем заказам.
*/

SELECT avg("summary")
FROM
  (SELECT sum(otp.quantity * p.price) AS "summary"
FROM orders_to_phones AS otp 
JOIN phones AS p
ON otp.phone_id = p.id
GROUP BY otp.order_id) AS "sum of orders"
;



/*
6. Извлечь все заказы, стоимостью выше среднего чека в магазине.
*/

--1) Считаем стоимость каждого заказа
SELECT otp.order_id, sum(otp.quantity * p.price) AS "cost"
FROM orders_to_phones AS otp 
JOIN phones AS p
ON otp.phone_id = p.id
GROUP BY otp.order_id;

--2) Получаем средний чек
SELECT avg("cost")
FROM (
  SELECT otp.order_id, sum(otp.quantity * p.price) AS "cost"
FROM orders_to_phones AS otp 
JOIN phones AS p
ON otp.phone_id = p.id
GROUP BY otp.order_id
) AS "owc";

--3) Получаем все заказы, выше этого среднего чека
SELECT "owc".*
FROM (SELECT otp.order_id, sum(otp.quantity * p.price) AS "cost"
FROM orders_to_phones AS otp 
JOIN phones AS p
ON otp.phone_id = p.id
GROUP BY otp.order_id) AS "owc"
WHERE "owc"."cost" > ( -- скалярный подзапрос
      SELECT avg("cost")
    FROM (
      SELECT otp.order_id, sum(otp.quantity * p.price) AS "cost"
    FROM orders_to_phones AS otp 
    JOIN phones AS p
    ON otp.phone_id = p.id
    GROUP BY otp.order_id
    ) AS "owc" 
);

-- 4) Рефактор
/* WITH псевдоним_таблицы AS (табличное выражение)
SELECT....;
*/

WITH "orders_with_costs" AS (
    SELECT otp.order_id, sum(otp.quantity * p.price) AS "cost"
    FROM orders_to_phones AS otp 
    JOIN phones AS p
    ON otp.phone_id = p.id
    GROUP BY otp.order_id
    )
SELECT "owc".*
FROM "orders_with_costs" AS "owc"
WHERE "owc"."cost" > (
  SELECT avg("owc"."cost")
  FROM "orders_with_costs" AS "owc"
);


/*
7. Извлечь всех пользователей, у которых количество заказов выше среднего
-- 1) количество заказов по каждому пользователю
-- 2) найти среднее количество заказов
-- 3) найти пользователей, у которых количество больше среднего
*/
