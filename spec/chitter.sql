TRUNCATE TABLE accounts RESTART IDENTITY CASCADE;

INSERT INTO accounts (user_name, email, password) VALUES ('George', 'george@gmail.com', 'lol');
INSERT INTO accounts (user_name, email, password) VALUES ('Aphra', 'aphra@gmail.com', 'tbh');

TRUNCATE TABLE posts RESTART IDENTITY CASCADE;

INSERT INTO posts (message, time_made, account_id) VALUES ('BREAKING NEWS', '2023-02-11 15:30:10', 1);
INSERT INTO posts (message, time_made, account_id) VALUES ('MORE BREAKING NEWS', '2023-02-11 16:45:35', 2);