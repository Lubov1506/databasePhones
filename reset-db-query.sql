/* Удаляем таблицы, если они были - в порядке подчиненности, сначала удаляются подчиненные таблицы, потом главные (а иначе главные и не удалятся вовсе, если на них кто-то ссылается*/

DROP TABLE IF EXISTS "orders_to_phones"; 
/*DROP TABLE IF EXISTS "phones"; */
DROP TABLE IF EXISTS "orders"; 
/* DROP TABLE IF EXISTS users; */

/* Создаем их все заново, определяем столбцы */
/* Структура такая:
Таблица телефонов содержит товары(телефоны)
Таблица заказов относится к таблице юзеров как 1:m
Таблица заказов_к_телефонам - связующая таблица для телефонов и заказов
(связь m:n)

*/


/* CREATE TABLE users(
    id serial PRIMARY KEY,
    first_name varchar(64) NOT NULL CHECK (first_name != ''),
    last_name varchar(64) NOT NULL CHECK (last_name != ''),
    email varchar(256) NOT NULL UNIQUE CHECK (email != ''),
    gender varchar(64) NOT NULL,
    is_subscribe boolean NOT NULL,
    birthday date NOT NULL CHECK (birthday < current_date AND birthday > '1900/1/1'),
    height numeric(3,2) NOT NULL CHECK (height > 0.20 AND height < 3.0)
); */





/* CREATE TABLE "phones"(
    "id" serial PRIMARY KEY,
    "brand" varchar(64) NOT NULL CHECK ("brand" != ''),
    "model" varchar(64) NOT NULL CHECK ("model" != ''),
    "quantity" int NOT NULL CHECK ("quantity" > 0),
    "price" decimal(16, 2) NOT NULL CHECK ("price" > 0),
    UNIQUE ("brand", "model")
); */

CREATE TABLE "orders"(
    "id" serial PRIMARY KEY,
   "user_id" int REFERENCES "users"("id")
);

CREATE TABLE "orders_to_phones"(
    "phone_id" int REFERENCES "phones"("id"),
   "order_id" int REFERENCES "orders"("id"),
   "quantity" int NOT NULL CHECK ("quantity" > 0),
   "status" boolean NOT NULL DEFAULT false,
   PRIMARY KEY("phone_id", "order_id")
);