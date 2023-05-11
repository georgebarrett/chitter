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
      expect(response.body).to include('<h1>You have successfully created a Chitter account</h1>')
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
      expect(response.body).to include('<h1>You have successfully created a new post</h1>')
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
end