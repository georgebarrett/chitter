TRUNCATE TABLE accounts RESTART IDENTITY CASCADE;

INSERT INTO accounts (name, user_name, email, password) VALUES ('George', 'G-unit', 'george@gmail.com', 'lol');
INSERT INTO accounts (name, user_name, email, password) VALUES ('Aphra', 'Pepina', 'aphra@gmail.com', 'tbh');