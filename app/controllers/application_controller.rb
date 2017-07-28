class ApplicationController < Sinatra::Base
  helpers ApplicationHelper

  set :views, File.expand_path('../../views', __FILE__)
  set :public_folder, File.expand_path('../../assets', __FILE__)

  signing_key_path = File.expand_path('../../../app.rsa', __FILE__)
  verify_key_path = File.expand_path('../../../app.rsa.pub', __FILE__)

  signing_key = ''
  verify_key = ''

  File.open(signing_key_path) do |file|
    signing_key = OpenSSL::PKey.read(file)
  end

  File.open(verify_key_path) do |file|
    verify_key = OpenSSL::PKey.read(file)
  end

  use OmniAuth::Builder do
    provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET'], scope: 'user:email'
  end

  set :signing_key, signing_key
  set :verify_key, verify_key

  configure :production, :development do
    enable :logging
    enable :sessions
  end

  get '/' do
    haml :index
  end
end
