# {{Accounts}} Model and Repository Classes Design Recipe

_Copy this recipe template to design and implement Model and Repository classes for a database table._

## 1. Design and create the Table

If the table is already created in the database, you can skip this step.

Otherwise, [follow this recipe to design and create the SQL schema for your table](./single_table_design_recipe_template.md).

*In this template, we'll use an example table `students`*

```
# EXAMPLE

Table: accounts

Columns:
id | user_name | email | password
```

## 2. Create Test SQL seeds

Your tests will depend on data stored in PostgreSQL to run.

If seed data is provided (or you already created it), you can skip this step.

```sql
-- EXAMPLE
-- (file: spec/seeds_accounts.sql)

-- Write your SQL seed here. 

-- First, you'd need to truncate the table - this is so our table is emptied between each test run,
-- so we can start with a fresh state.
-- (RESTART IDENTITY resets the primary key)

TRUNCATE TABLE accounts RESTART IDENTITY; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO accounts (user_name, email, password) VALUES ('George', 'george@gmail.com', 'lol');
INSERT INTO accounts (user_name, email, password) VALUES ('Aphra', 'aphra@gmail.com', 'tbh');
```

Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

```bash
psql -h 127.0.0.1 chitter < seeds_accounts.sql
psql -h 127.0.0.1 chitter_test < seeds_accounts.sql
```

## 3. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by `Repository` for the Repository class name.

```ruby
# EXAMPLE
# Table name: accounts

# Model class
# (in lib/account.rb)
class Account
end

# Repository class
# (in lib/account_repository.rb)
class AccountRepository
end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# EXAMPLE
# Table name: accounts

# Model class
# (in lib/account.rb)

class Account
  attr_accessor :id, :user_name, :email, :password
end

# The keyword attr_accessor is a special Ruby feature
# which allows us to set and get attributes on an object,
# here's an example:
#
# account = Account.new
# account.user_name = 'George'
# account.email = 'george@gmail.com'
# account.password = 'lol'
```

*You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed.*

## 5. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# EXAMPLE
# Table name: accounts

# Repository class
# (in lib/accounts_repository.rb)

class AccountRepository

  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT id, user_name, email, password, FROM accounts;

    # Returns an array of Account objects.
  end

  # select a single account record given its id
  def find(id) 
    # executes the SQL
    # SELECT id, user_name, email, password FROM accounts WHERE id =$1;
    # returns a single Account object
  end

  # inserting a new account
  def create(account)
    # INSERT INTO accounts (user_name, email, password) VALES($1, $2, $3)

    # returns nothing
  end

  # deletes an account
  # takes an id as an object argument
  def delete(id)
    # sql
    # DELETE FROM accounts WHERE id = $1;

    # returns nothing
  end

  # updates an account
  # takes an account as the object argument 
  def update(account)
    # sql
    # UPDATE accounts SET user_name = $1, email = $2, password = $3 WHERE id = $4

    # returns nothing
  end

end
```

## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
# EXAMPLES

# Get all accounts

repo = AccountRepository.new

accounts = repo.all

accounts.length = 2
accounts[0].id = "1"
accounts[0].user_name = "George"

# get single account ('George')

repo = AccountRepository.new

accounts = repo.find(1)

account.user_name # => George
account.email # => george@gmail.com
account.password # => lol

# get a different single account ('Aphra')

repo = AccountRepository.new

accounts = repo.find(2)

accounts.user_name # => Aphra
accounts.email # => aphra@gmail.com
accounts.password # => tbh


# insert a new account
repo = AccountRepository.new

account = Account.new
account.user_name = 'Nathan'
account.email = 'nathan@gmail.com'
account.password = 'ikr'

repo.create(account)

all_accounts = repo.all

last_account = accounts.last
last_account.name = 'Nathan'
last_account.email = 'nathan@gmail.com'
last_account.password = 'ikr'
 
# delete account

repo = AccountRepository.new

id_to_delete = 1

repo.delete(id_to_delete)

all_accounts = repo.all
all_accounts.length # => 1 (the seeds start the database with two)
all_accounts[0].id # => 2

# deletes both accounts
repo = AccountRepository.new

repo.delete(1)
repo.delete(2)

all_accounts = repo.all
expect(all_accounts.length).to eq (0)

# update entire account

repo = AccountRepository.new

account = repo.find(1)
account.user_name = 'GeorgeB'
account.email = 'georgenew@gmail.com'
account.password = 'lollol'

repo.update(account)

updated_account = repo.find(1)
updated_account.user_name = 'GeorgeB'
updated_account.email = 'georgenew@gmail.com'
account.password = 'lollol'

# update single value of an account

repo = AccountRepository.new

account = repo.find(1)
account.user_name = 'George'

repo.update(album)

updated_account = repo.find(1)

expect(updated_account.user_name).to eq 'George'
expect(updated_account.email).to eq 'georgebarrett@gmail.com'
expect(updated_account.password).to eq 'lol'

```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

# file: spec/album_repository_spec.rb

def reset_accounts_table
  seed_sql = File.read('spec/seeds_accounts.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'chitter_test' })
  connection.exec(seed_sql)
end

describe AccountRepository do
  before(:each) do 
    reset_accounts_table
  end

  # (your tests will go here).
end
```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._