require 'sinatra'
require "sinatra/reloader"
require_relative 'lib/database_connection'
require_relative 'lib/account_repository'
require_relative 'lib/post_repository'
require 'date'

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
    new_account = Account.new
    new_account.name = params[:name]
    new_account.user_name = params[:user_name]
    new_account.email = params[:email]
    new_account.password = params[:password]

    repo = AccountRepository.new

    if account_already_exists
      status 400
      return 'This account already exists.'
    else
      repo.create(new_account)
      return erb(:account_created)
    end
  end

  def account_already_exists
    repo = AccountRepository.new
    repo.all.each do |user|
      return true if user.user_name == params[:user_name] || user.email == params[:email]
    end
    return false
  end

  get '/new_post' do
    return erb(:new_post)
  end

  post '/posts' do
    repo = PostRepository.new
    new_post = Post.new
    new_post.message = params[:message]
    new_post.time_made = Time.now
    new_post.account_id = 1 # refactor 

    repo.create(new_post)

    return erb(:post_created)
  end

  get '/list_posts' do
    repo = PostRepository.new
    @posts = repo.all
    return erb(:list_posts)
  end

  get '/login' do
    erb(:login)
  end

end

