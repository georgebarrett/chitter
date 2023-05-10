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
      response = post('/accounts', user_name: 'Rob', email: 'rob@gmail.com', password: 'atm')
      
      expect(response.status).to eq (200)
      expect(response.body).to include('<h1>You have successfully created a Chitter account</h1>')
    end
  end

end