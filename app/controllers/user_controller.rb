class UserController < ApplicationController
  include Authable::InstanceMethods

  get '/signup' do
    if session[:user_id]
      redirect '/tweets'
    else
      erb :'/users/signup'
    end
  end

  get '/login' do
    if session[:user_id]
      redirect '/tweets'
    else
      erb :'/users/login'
    end
  end

  post '/login' do
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect '/tweets'
    else
      redirect '/login'
    end
  end

  get '/logout' do
    if logged_in?
      session.clear
      redirect '/login'
    else
      redirect to '/'
    end
  end

  get '/users/:username' do
    @user = User.find_by_slug(params[:username])

    erb :'users/show'
  end

  post '/signup' do
    user = User.new(
      username: params[:username],
      email: params[:email],
      password: params[:password]
    )

    if user.save
      session[:user_id] = user.id
      redirect '/tweets'
    else
      redirect '/signup'
    end
  end
end
