require 'account_repository'
require 'bcrypt'

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
    expect(accounts[0].name).to eq 'George'
    expect(accounts[0].user_name).to eq 'G-unit'
    expect(accounts[0].email).to eq 'george@gmail.com'
    expect(accounts[0].password).to eq 'lol'
  end

  it 'gets a single account' do
    repo = AccountRepository.new

    accounts = repo.find(1)

    expect(accounts.name).to eq 'George'
    expect(accounts.user_name).to eq 'G-unit'
    expect(accounts.email).to eq 'george@gmail.com'
    expect(accounts.password).to eq 'lol'
  end

  it 'gets the details of another single account' do
    repo = AccountRepository.new

    accounts = repo.find(2)

    expect(accounts.name).to eq 'Aphra'
    expect(accounts.user_name).to eq 'Pepina'
    expect(accounts.email).to eq 'aphra@gmail.com'
    expect(accounts.password).to eq 'tbh'
  end

  it 'creates an account' do
    new_account = Account.new
    new_account.name = 'Saxon'
    new_account.user_name = 'Saxophone'
    new_account.email = 'saxon@gmail.com'
    new_account.password = 'hmu'

    repo = AccountRepository.new
    repo.create(new_account)

    accounts = repo.all
    expect(accounts[-1].name).to eq 'Saxon'
    expect(accounts[-1].user_name).to eq 'Saxophone'
    expect(accounts[-1].email).to eq 'saxon@gmail.com'
  end

  it 'deletes an account with the id of 1' do
    repo = AccountRepository.new
    id_to_delete = 1

    repo.delete(id_to_delete)
    all_accounts = repo.all
    
    expect(all_accounts.length).to eq 1
    expect(all_accounts[0].id).to eq 2
  end

  it 'deletes multiple accounts' do
    repo = AccountRepository.new

    repo.delete(1)
    repo.delete(2)

    all_accounts = repo.all
    expect(all_accounts.length).to eq 0
  end

  it 'updates an entire account' do 
    repo = AccountRepository.new

    account = repo.find(1)
    account.name = 'George'
    account.user_name = 'G-unit'
    account.email = 'george@gmail.com'
    account.password = 'lol'

    repo.update(account)

    updated_account = repo.find(1)
    
    expect(updated_account.name).to eq 'George'
    expect(updated_account.user_name).to eq 'G-unit'
    expect(updated_account.email).to eq 'george@gmail.com'
  end

  it 'updates only one value of an account' do
    repo = AccountRepository.new

    account = repo.find(2)
    account.name = 'Aphra'

    repo.update(account)
    updated_account = repo.find(2)
    
    expect(updated_account.name).to eq 'Aphra'
    expect(updated_account.email).to eq 'aphra@gmail.com'
  end

  it 'finds an account by email' do
    repo = AccountRepository.new
    account = repo.find_by_email('george@gmail.com')

    expect(account.user_name).to eq 'G-unit'
  end

  it 'Logs a user in if their email and password are correct' do
    new_account = Account.new
    new_account.name = 'Roger'
    new_account.user_name = 'Podge'
    new_account.email = 'roger@gmail.com'
    new_account.password = 'lol'

    accounts = AccountRepository.new
    accounts.create(new_account)
    
    result = accounts.sign_in('roger@gmail.com', 'lol')

    expect(result).to eq true
  end
end