require_relative 'account'

class AccountRepository

  def all
    sql = 'SELECT id, user_name, email, password FROM accounts;'
    result = DatabaseConnection.exec_params(sql, []) 

    accounts = []

    result.each do |record|
      accounts << record_to_post_object(record)
    end
    return accounts
  end

  def find(id)
    sql = 'SELECT id, user_name, email, password FROM accounts WHERE id = $1;'
    sql_params = [id]
    result = DatabaseConnection.exec_params(sql, sql_params)
    record = result[0]

    return record_to_post_object(record)
  end

  def create(account)
    sql = 'INSERT INTO accounts (user_name, email, password) VALUES ($1, $2, $3);'
    sql_params = [account.user_name, account.email, account.password]
    result = DatabaseConnection.exec_params(sql, sql_params)

    return nil
  end

  def delete(id)
    sql = 'DELETE FROM accounts WHERE id = $1;'
    sql_params = [id]
    result = DatabaseConnection.exec_params(sql, sql_params)

    return nil
  end

  def update(account)
    sql = 'UPDATE accounts SET user_name = $1, email = $2, password = $3 WHERE id = $4;'
    sql_params = [account.user_name, account.email, account.password, account.id]
    result = DatabaseConnection.exec_params(sql, sql_params)

    return nil
  end


  private

  def record_to_post_object(record)
    account = Account.new
    
    account.id = record['id'].to_i
    account.user_name = record['user_name']
    account.email = record['email']
    account.password = record['password']

    return account
  end

end