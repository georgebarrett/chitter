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