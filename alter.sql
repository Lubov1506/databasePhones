CREATE TABLE user_tasks(
    id serial PRIMARY KEY,
    user_id int REFERENCES users,
    body text NOT NULL,
    is_done boolean DEFAULT false,
    deadline timestamp NOT NULL DEFAULT current_timestamp
);

INSERT INTO user_tasks(user_id, body, is_done) VALUES 
(1, 'text', false),
(2, 'arty', true),
(3, 'segrt', false),
(4, 'ghkyuo', true);

--добавление столбцов
ALTER TABLE user_tasks
ADD COLUMN created_at timestamp NOT NULL DEFAULT current_timestamp;

ALTER TABLE user_tasks
ADD COLUMN test int;

--удаление столбца
ALTER TABLE user_tasks
DROP COLUMN test;

ALTER TABLE user_tasks
ADD CONSTRAINT check_created_time CHECK (created_at<= current_timestamp);

ALTER TABLE user_tasks
DROP CONSTRAINT check_created_time 

-- добавление ограничения NOT NULL
ALTER TABLE user_tasks
ALTER COLUMN is_done SET NOT NULL

ALTER TABLE user_tasks
ALTER COLUMN is_done DROP NOT NULL

ALTER TABLE user_tasks
ALTER COLUMN is_done
DROP DEFAULT;

ALTER TABLE user_tasks
ALTER COLUMN is_done
SET DEFAULT true;

ALTER TABLE user_tasks
ALTER COLUMN body TYPE varchar(512)

ALTER TABLE user_tasks
RENAME COLUMN is_done TO status

ALTER TABLE user_tasks RENAME TO tasks;


CREATE TYPE tasks_status AS ENUM ('new', 'processing', 'done', 'overdue');

ALTER TABLE tasks
ALTER COLUMN status
TYPE tasks_status;

ALTER TABLE tasks
ALTER COLUMN status
DROP DEFAULT;

-- did not work
ALTER TABLE tasks
ALTER COLUMN status
TYPE tasks_status USING (
    CASE status
    WHEN false THEN 'new'
    WHEN true THEN 'done'
    ELSE 'processing'
    END
)::tasks_status 

INSERT INTO tasks (user_id, body, status) VALUES
(24, 'hello', 'processing'),
(28, 'df', 'overdue');

CREATE SCHEMA new
DROP TABLE new.users;
DROP TABLE new.employers;

CREATE TABLE new.users(
    id serial PRIMARY KEY,
    login varchar(64) NOT NULL CHECK (login != ''),
    password varchar(32) NOT NULL CHECK (password != ''),
    email varchar(32) NOT NULL CHECK (email != '')
)
CREATE TABLE new.employers(
    id serial PRIMARY KEY,
    name varchar(32) NOT NULL CHECK (name!=''),
    salary numeric(10,2),
    department varchar(32) NOT NULL CHECK (department!=''),
    position varchar(32) NOT NULL CHECK (position!=''),
    hire_date date CHECK (hire_date <= current_date)
)


INSERT INTO new.users (login,password_hash,email) VALUES
('test1', 's5474edfgh%&*h28939d', 'tess3et1@SDFmail' ),
('test2', 's5474eghf%xczs@$&*h28939d', 'testG42545GD@mail' ),
('test3', 'wkiuhht99*&wkiuh99', 'testFDG42256@mail' ),
('test4', 's5474tgrrge%&*h28939d', 'test1@6345' ),
('test8', 's5474ecvw%xczs@$&*h28939d', 'testdrt2G42GD@mail' ),
('test9', 'wkiuh99wrr*&wkiuh99', 'testFDG444235@mail' );

ALTER TABLE new.users
ADD UNIQUE (login);

ALTER TABLE new.users
ADD UNIQUE (email);

ALTER TABLE new.users
DROP COLUMN password;

ALTER TABLE new.users
ADD COLUMN password_hash text;

ALTER TABLE new.employers
DROP COLUMN id;

ALTER TABLE new.employers
ADD COLUMN user_id int PRIMARY KEY REFERENCES new.users;

INSERT INTO new.employers (
    name,
    salary,
    department,
    position,
    hire_date,
    user_id
  )
VALUES (
    'Jack',
    5000,
    'sales',
    'sale',
    '2022/05/02',
    2
  ),
  (
    'Sam',
    7000,
    'Dev',
    'developer',
    '2022/05/02',
    5
  ),
  (
    'Jake',
    15000,
    'HR',
    'top-manager',
    '2022/05/02',
    7
  );

SELECT u.email,COALESCE(e.salary, 0) AS "salary"
FROM new.users AS u
LEFT JOIN new.employers AS e
ON u.id=e.user_id;

SELECT *
FROM new.users AS u 
WHERE u.id NOT IN (SELECT user_id FROM new.employers)

CREATE SCHEMA wf;

CREATE TABLE wf.departments(
  id serial PRIMARY KEY,
  name varchar(64) NOT NULL
);
INSERT INTO wf.departments (name)
VALUES ('HR'), ('Sales'), ('Development'), ('Drivers');

CREATE TABLE wf.employers(
    id serial PRIMARY KEY,
    department_id int REFERENCES wf.departments,
  name varchar(64) NOT NULL,
  salary numeric(10,2) NOT NULL CHECK(salary>=0)
)
INSERT INTO wf.employers (department_id, name, salary)
VALUES 
(1,'John', 5000),
(1,'Jane', 7000),
(2,'Rob', 8000),
(2,'Mike', 15000),
(2,'Rem', 6700),
(3,'Helen', 8500),
(3,'Yohan', 15000),
(3,'Lurry', 1500);


SELECT d.name, count(e.id) AS "employer count"
FROM wf.departments AS d
JOIN wf.employers AS e
ON d.id=e.department_id
GROUP BY d.id;


SELECT e.*, d.name
FROM wf.departments AS d
JOIN wf.employers AS e
ON d.id=e.department_id;

SELECT avg(e.salary), d.name
FROM wf.departments AS d
JOIN wf.employers AS e
ON d.id=e.department_id
GROUP BY d.id;


SELECT e.*, d.*, "avg_salary"
FROM wf.departments AS d
JOIN wf.employers AS e
ON d.id=e.department_id
JOIN (
  SELECT avg(e.salary), d.name, d.id
  FROM wf.departments AS d
  JOIN wf.employers AS e
  ON d.id=e.department_id
  GROUP BY d.id
) AS "das"
ON das.id=d.id;

SELECT e.*, d.*, avg(e.salary) OVER (PARTITION BY d.id) AS "avg_salary"
FROM wf.departments AS d
JOIN wf.employers AS e
ON d.id=e.department_id;

SELECT e.*, d.*, avg(e.salary) OVER () AS "sum_avg_salary", avg(e.salary) OVER (PARTITION BY d.id) AS "avg_salary"
FROM wf.departments AS d
JOIN wf.employers AS e
ON d.id=e.department_id;


SELECT e.*, d.*, sum(e.salary) OVER () AS "sum_salary", sum(e.salary) OVER (PARTITION BY d.id) AS "dep_sum_salary"
FROM wf.departments AS d
JOIN wf.employers AS e
ON d.id=e.department_id

