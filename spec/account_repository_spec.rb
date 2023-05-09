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
    expect(accounts[0].email).to eq 'george@gmail.com'
    expect(accounts[0].password).to eq 'lol'
  end

end