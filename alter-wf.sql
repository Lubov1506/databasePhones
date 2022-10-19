/*  ALTER  */

DROP TABLE tasks;

CREATE TABLE user_tasks(
    id serial PRIMARY KEY,
    user_id int REFERENCES users,
    body text NOT NULL,
    is_done boolean DEFAULT false,
    deadline timestamp NOT NULL DEFAULT current_timestamp
);

INSERT INTO user_tasks (user_id, body, is_done)
VALUES (14, 'test', false), 
(17, 'hello', true), 
(21, 'need review', false),
(28, 'bye', true);


-- Добавлять столбцы

ALTER TABLE user_tasks
ADD COLUMN created_at timestamp NOT NULL DEFAULT current_timestamp;

ALTER TABLE user_tasks
ADD COLUMN test int;


-- • Удалять столбцы

ALTER TABLE user_tasks
DROP COLUMN test;

-- • Добавлять ограничения

ALTER TABLE user_tasks
ADD CONSTRAINT check_created_time CHECK (created_at <= current_timestamp);

-- add not-null constraint

ALTER TABLE user_tasks
ALTER COLUMN is_done SET NOT NULL;


-- • Удалять ограничения

ALTER TABLE user_tasks
DROP CONSTRAINT check_created_time;

--delete not-null constraint

ALTER TABLE user_tasks
ALTER COLUMN is_done DROP NOT NULL;




-- • Изменять значения по умолчанию
-- добавить, изменение, удаление default

ALTER TABLE user_tasks
ALTER COLUMN is_done
DROP DEFAULT;

ALTER TABLE user_tasks
ALTER COLUMN is_done
SET DEFAULT true;


-- • Изменять типы столбцов

ALTER TABLE user_tasks
ALTER COLUMN body TYPE varchar(512);

-- • Переименовывать столбцы

ALTER TABLE user_tasks
RENAME COLUMN is_done TO status;

-- • Переименовывать таблицы

ALTER TABLE user_tasks RENAME TO tasks;



/*     --------    */

/* Status: 'new', 'processing', 'done', 'overdue' */

/* CREATE TYPE type_name AS ENUM (value1, value2, value3); */

ALTER TABLE tasks
ALTER COLUMN status
DROP DEFAULT;

DROP TYPE tasks_status;

CREATE TYPE tasks_status AS ENUM ('new', 'processing', 'done', 'overdue');

ALTER TABLE tasks
ALTER COLUMN status
TYPE tasks_status USING (
    CASE status
    WHEN false THEN 'new'
    WHEN true THEN 'done'
    ELSE 'processing'
END
)::tasks_status;


/*
Practice: 
users: login, password, email

employees: salary, department, position, hire_date, name


CREATE SCHEMA schema_name;

CREATE TABLE schema_name.table_name;

*/

CREATE SCHEMA nt;

CREATE TABLE nt.users (
    id serial PRIMARY KEY,
    login varchar(64) NOT NULL CHECK (login != ''),
    password varchar(32) NOT NULL,
    email varchar(64) NOT NULL CHECK (email != '')
);


CREATE TABLE nt.employees (
    id serial PRIMARY KEY,
    name varchar(64) NOT NULL CHECK (name != ''),
    salary numeric(10, 2),
    department varchar(64) NOT NULL CHECK (department != ''),
    position varchar(64) NOT NULL CHECK (position != ''),
    hire_date date NOT NULL CHECK (hire_date <= current_date)
);


INSERT INTO nt.users (login, password_hash, email) VALUES 
('login1', 'b4a47964ac291b7b9ef2abc96785fdeedbf7bf9ba82c5fc340e882a424b3f66e', 'mail4@te'),
('login2', 'b4a47964ac291b7b9ef2abc96785fdeedbf7bf9ba82c5fc340e882a424b3f66e', 'mail15@te');


ALTER TABLE nt.users
ADD UNIQUE (login);

ALTER TABLE nt.users
ADD UNIQUE (email);

/*
delete PASSWORD
add password_hash 
 */

 ALTER TABLE nt.users
 DROP COLUMN password;

 ALTER TABLE nt.users
 ADD COLUMN password_hash text;


 /*

users <=> employees
 1         0..1


 Исключительно alter-ом
 */

 ALTER TABLE nt.employees
 DROP COLUMN id;

 ALTER TABLE nt.employees
 ADD COLUMN user_id int PRIMARY KEY REFERENCES nt.users;



INSERT INTO nt.employees (
    name,
    salary,
    department,
    position,
    hire_date,

    user_id
  )
VALUES (
    'John',
    5000,
    'sales',
    'sale',
    '2022/05/20',
    2
  ),
   (
    'Jane',
    7000,
    'Develop',
    'Developer',
    '2022/05/20',
    3
  ),
   (
    'Jake',
    15000,
    'HR',
    'top-manager',
    '2022/05/20',
    5
  );



  /*  Вытащить всех users с инфой об их зп  */

  SELECT u.*, COALESCE(e.salary, 0) AS "salary"
  FROM nt.users AS u
  LEFT JOIN nt.employees AS e 
  ON e.user_id = u.id;


  /* Вытащить всех пользователей, которые не сотрудники*/

  SELECT * 
  FROM nt.users AS u
  WHERE u.id NOT IN (SELECT user_id FROM nt.employees);



  /* Window FUNCTIONS */

  CREATE SCHEMA wf;

  CREATE TABLE wf.departments (
      id serial PRIMARY KEY,
      name varchar(64) NOT NULL
  );

  INSERT INTO wf.departments (name) VALUES ('HR'), ('Sales'), ('Delepment'), ('Driver');

  CREATE TABLE wf.employees(
      id serial PRIMARY KEY,
      department_id int REFERENCES wf.departments,
      name varchar(64) NOT NULL,
      salary numeric(10,2) NOT NULL CHECK (salary >= 0)
  );

  INSERT INTO wf.employees (department_id,
  name,
  salary) VALUES 
  (1, 'John', 5000), 
  (1, 'Jane', 7000), 
  (2, 'JAke', 10000), 
  (2, 'Klay', 8000), 
  (2, 'Nike', 5000), 
  (3, 'Riki', 9000),
    (3, 'Morty', 11000),
    (3, 'Rich', 3000);

    /* Посчитать количество сотрудников в отделах */

SELECT d.name, count(e.id) AS "employee count"
FROM wf.departments AS d
JOIN wf.employees AS e
ON e.department_id = d.id
GROUP BY d.id;

/* Сотрудник и название его отдела */

SELECT e.*, d.name
FROM wf.departments AS d
JOIN wf.employees AS e
ON e.department_id = d.id;


/* Среднюю зарплату по каждому отделу */


SELECT avg(e.salary), d.name
FROM wf.departments AS d
JOIN wf.employees AS e
ON e.department_id = d.id
GROUP BY d.id;

/* Вся инфа о сотрудниках, департаментах и средняя зп всего департамента */

SELECT e.*, d.*, "avg salary"
FROM wf.departments AS d
JOIN wf.employees AS e
ON e.department_id = d.id
JOIN (
    SELECT avg(e.salary) AS "avg salary", d.name, d.id
FROM wf.departments AS d
JOIN wf.employees AS e
ON e.department_id = d.id
GROUP BY d.id
) AS "das"
ON das.id = d.id;


SELECT e.*, d.*, 
avg(e.salary) OVER (PARTITION BY d.id) AS "avg salary"
FROM wf.departments AS d
JOIN wf.employees AS e
ON e.department_id = d.id;



SELECT e.*, d.*, 
avg(e.salary) OVER () AS "summary salary",
avg(e.salary) OVER (PARTITION BY d.id) AS "avg salary"
FROM wf.departments AS d
JOIN wf.employees AS e
ON e.department_id = d.id;

/* 
Вывести всех сотрудников, с название отдела, суммарной зарплатой всего отдела и суммарной зарплатой всей компании

*/