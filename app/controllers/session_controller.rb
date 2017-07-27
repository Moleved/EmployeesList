class SessionController < ApplicationController
  attr_reader :user, :token

  get '/auth/sign_up' do
    haml :sign_up
  end

  post '/auth/sign_up' do
    @user = User.new(params[:user])
    if user.save
      generate_token
      write_token_to_session

      redirect '/users'
    else
      'Sorry, there was an error!'
    end
  end

  get '/auth/sign_in' do
    haml :sign_in
  end

  post '/auth/sign_in' do
    @params = params[:user]
    @user = User.all.find_by email: @params[:email]
    if user.password == @params[:password]
      generate_token
      write_token_to_session

      redirect to('/')
    else
      haml :sign_in
    end
  end

  get '/auth/logout' do
    session['access_token'] = nil
    redirect '/'
  end

  get '/auth/:provider/callback' do
    @user = User.from_github(request.env['omniauth.auth'])
    generate_token
    write_token_to_session
    redirect '/'
  end

  private

  def generate_token
    headers = { exp: Time.now.to_i + 30 }
    @token = JWT.encode({ user_id: user.id }, settings.signing_key, 'RS256', headers)
  end

  def write_token_to_session
    session['access_token'] = token
  end
end
