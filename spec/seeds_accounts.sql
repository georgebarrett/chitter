TRUNCATE TABLE accounts RESTART IDENTITY CASCADE;

INSERT INTO accounts (user_name, email, password) VALUES ('George', 'george@gmail.com', 'lol');
INSERT INTO accounts (user_name, email, password) VALUES ('Aphra', 'aphra@gmail.com', 'tbh');