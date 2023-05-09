require 'account_repository'

def reset_accounts_table
  seed_sql = File.read('spec/seeds_accounts.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'chitter_test' })
  connection.exec(seed_sql)
end

describe AccountRepository do
  before(:each) do 
    reset_accounts_table
  end

  it 'gets all the accounts' do
    repo = AccountRepository.new

    accounts = repo.all

    expect(accounts.length).to eq 2
    expect(accounts[0].id).to eq 1
    expect(accounts[0].user_name).to eq 'George'
    expect(accounts[0].email).to eq 'george@gmail.com'
    expect(accounts[0].password).to eq 'lol'
  end

  it 'gets a single account' do
    repo = AccountRepository.new

    accounts = repo.find(1)

    expect(accounts.user_name).to eq 'George'
    expect(accounts.email).to eq 'george@gmail.com'
    expect(accounts.password).to eq 'lol'
  end

  it 'gets the details of another single account' do
    repo = AccountRepository.new

    accounts = repo.find(2)

    expect(accounts.user_name).to eq 'Aphra'
    expect(accounts.email).to eq 'aphra@gmail.com'
    expect(accounts.password).to eq 'tbh'
  end

  it 'creates an account' do
    new_account = Account.new
    new_account.user_name = 'Saxon'
    new_account.email = 'saxon@gmail.com'
    new_account.password = 'hmu'

    repo = AccountRepository.new
    repo.create(new_account)

    accounts = repo.all
    expect(accounts[-1].user_name).to eq 'Saxon'
    expect(accounts[-1].email).to eq 'saxon@gmail.com'
    expect(accounts[-1].password).to eq 'hmu'
  end

  # it 'deletes an account with the id of 1' do
  #   repo = AccountRepository.new
  #   id_to_delete = 1

  #   repo.delete(id_to_delete)
  #   all_accounts = repo.all
    
  #   expect(all_accounts.length).to eq 1
  #   expect(all_accounts[0].id).to eq 2
  # end

  it 'updates an entire post' do 
    repo = AccountRepository.new

    account = repo.find(1)
    account.user_name = 'George'
    account.email = 'george@gmail.com'
    account.password = 'lol'

    repo.update(account)

    updated_account = repo.find(1)
    
    expect(updated_account.user_name).to eq 'George'
    expect(updated_account.email).to eq 'george@gmail.com'
    expect(updated_account.password).to eq 'lol'
  end

  it 'updates only one value of an account' do
    repo = AccountRepository.new

    account = repo.find(2)
    account.user_name = 'Aphra'

    repo.update(account)
    updated_account = repo.find(2)
    
    expect(updated_account.user_name).to eq 'Aphra'
    expect(updated_account.email).to eq 'aphra@gmail.com'
  end

end