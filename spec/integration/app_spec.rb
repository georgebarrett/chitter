require "spec_helper"
require "rack/test"
require_relative '../../app'

describe Application do
  include Rack::Test::Methods
  let(:app) { Application.new }

  def reset_all_table
    seed_sql = File.read('spec/chitter.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'chitter_test' })
    connection.exec(seed_sql)
  end
    
  before(:each) do
    reset_all_table
  end

  context 'POST accounts' do
    it 'creates a new account' do
      response = post('/accounts', name: 'Rob', user_name: 'Words', email: 'rob@gmail.com', password: 'atm')
      
      expect(response.status).to eq (200)
      expect(response.body).to include('<h1>You have successfully created a Chitter account.</h1>')
    end

    it 'fails if email or username already exists' do
      response = post('/accounts', name: 'George', username: 'G-unit', email: 'george@gmail.com', password: 'lol')

      expect(response.body).to include('<h1>This account already exists.</h1>')
    end
  end

  context 'POST posts' do
    it 'creates a new post' do
      response = post('/posts', message: 'EVEN MORE BREAKING NEWS', time_made: '2023-05-01 11:45:23')

      expect(response.status).to eq (200)
      expect(response.body).to include('<h1>You have successfully created a new post.</h1>')
    end
  end

  context 'GET /posts' do
    it "outputs a list of all posts HTML formatted" do
      response = get('/list_posts')

      expect(response.status).to eq 200
      expect(response.body).to include('<h1>Posts</h1>')
      expect(response.body).to include('BREAKING NEWS')
      expect(response.body).to include('2023-02-11 15:30:10')
    end
  end

  context 'GET /login' do
    it 'returns 200' do
      response = get('/login')
      expect(response.status).to eq 200
    end

    it 'returns html with login form using POST /login route' do
      response = get('login')
      expect(response.body).to include '<form action="/login" method="POST">'
      expect(response.body).to include '<input placeholder="Email" type="text" name="email">'
      expect(response.body).to include '<input placeholder="Password" type="text" name="password">'
      expect(response.body).to include '<input type="submit">'
    end

    it 'returns html with link back to homepage' do
      response = get('/login')
      expect(response.body).to include '<a href="/">Back to homepage</a>'
    end
  end

  context 'POST /login' do
    it 'Successfully authenticates user if email and password match' do
      new_account = Account.new
      new_account.name = 'Roger'
      new_account.user_name = 'Podge'
      new_account.email = 'roger@gmail.com'
      new_account.password = 'blah'

      accounts = AccountRepository.new
      accounts.create(new_account)
      
      response = post('/login', submitted_email: 'roger@gmail.com', submitted_password: 'blah')

      expect(response.status).to eq(200)
      expect(response.body).to include('Login successfull!')
    end

    it 'Fails if email or password do not match' do
      new_account = Account.new
      new_account.name = 'Roger'
      new_account.user_name = 'Podge'
      new_account.email = 'roger@gmail.com'
      new_account.password = 'blah'

      accounts = AccountRepository.new
      accounts.create(new_account)
      
      response = post('/login', submitted_email: 'roger@gmail.com', submitted_password: 'meh')

      expect(response.body).to include('<h1>Log in unsuccessful</h1>')
    end
  end

  context 'GET /account_page' do
    it 'the account page is accessible when user is logged in' do
      new_account = Account.new
      new_account.name = 'Denise'
      new_account.user_name = 'Sneeze'
      new_account.email = 'denise@gmail.com'
      new_account.password = 'robot'

      accounts = AccountRepository.new
      accounts.create(new_account)
      
      post('/login', submitted_email: 'denise@gmail.com', submitted_password: 'robot')

      response = get('/account_page')
      
      expect(response.status).to eq(200)
      expect(response.body).to include('<body>')
    end

    it 'account page is not accessible when user is not authenticated' do
      response = get('/account_page')
      
      expect(response.status).to eq(302)
    end
  end

  context 'GET /logout' do
    it 'Logs user out of their session' do
      new_account = Account.new
      new_account.name = 'Graham'
      new_account.user_name = 'Graham101'
      new_account.email = 'graham@gmail.com'
      new_account.password = 'splund'

      accounts = AccountRepository.new
      accounts.create(new_account)
      
      post('/login', submitted_email: 'graham@gmail.com', submitted_password: 'splund')

      logout = get('/logout')
      
      expect(logout.status).to eq(302)
    end
  end
end