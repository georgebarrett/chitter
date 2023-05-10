require 'sinatra'
require "sinatra/reloader"
require_relative 'lib/database_connection'
require_relative 'lib/account_repository'
require_relative 'lib/post_repository'

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/account_repository'
    also_reload 'lib/post_repository'
  end

  get '/' do
    return erb(:index)
  end

  get '/new_account' do
    return erb(:new_account)
  end

  post '/accounts' do
    repo = AccountRepository.new
    new_account = Account.new
    new_account.user_name = params[:user_name]
    new_account.email = params[:email]
    new_account.password = params[:password]

    repo.create(new_account)

    return erb(:account_created)
  end

end

