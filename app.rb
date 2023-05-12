require 'sinatra'
require "sinatra/reloader"
require_relative 'lib/database_connection'
require_relative 'lib/account_repository'
require_relative 'lib/post_repository'
require 'date'
require 'sinatra/base'

DatabaseConnection.connect

class Application < Sinatra::Base

  enable :sessions

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
      return erb(:account_already_exists)
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

  post '/login' do
    repo = AccountRepository.new
    email = params[:submitted_email]
    password = params[:submitted_password]

    if repo.sign_in(email, password) == true
      @account = repo.find_by_email(email)
      session[:account_id] = @account.id
      return erb(:login_success)
    else
      return erb(:login_failure)
    end
  end

  get '/account_page' do
    if session[:account_id] == nil
      return redirect('/login')
    else
      @account = AccountRepository.new.find(session[:account_id])
      return erb(:account_page)
    end
  end

  get '/logout' do
    session[:user_id] = nil
    return redirect('/')
  end

  # def invalid_input(input)
  #   input != '' && !input.match(/[<>]/)
  # end

end

