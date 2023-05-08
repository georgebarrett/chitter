CREATE TABLE accounts (
  id SERIAL PRIMARY KEY,
  user_name text,
  email text,
  password text
);

-- Then the table with the foreign key first.
CREATE TABLE posts (
  id SERIAL PRIMARY KEY,
  message text,
  time_made time,
-- The foreign key name is always {other_table_singular}_id
  account_id int,
  constraint fk_account foreign key(account_id)
    references accounts(id)
    on delete cascade
);