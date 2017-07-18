require 'sinatra/base'
require 'sinatra/activerecord'
require 'active_record'
require 'dotenv/load'
require 'jwt'
require 'openssl'
require 'bcrypt'
require 'omniauth-github'
require 'forgery'

require './app/helpers/application_helper.rb'
require './app/controllers/application_controller.rb'
require './app/controllers/users_controller.rb'
require './app/controllers/session_controller.rb'

Dir.glob('./app/{helpers, controllers}/*.rb').each { |file| require file }
Dir.glob('./models/*.rb').each { |file| require file }

run ApplicationController
map('/users') { run UsersController }
run SessionController
