require 'sinatra/base'
require 'sinatra/activerecord'
require 'active_record'
require 'dotenv/load'
require 'jwt'
require 'openssl'
require 'bcrypt'
require 'omniauth-github'
require 'forgery'

$LOAD_PATH.push File.expand_path(__dir__)

%w[application].each { |f| require "app/helpers/#{f}_helper" }
%w[application users session].each { |f| require "app/controllers/#{f}_controller" }

%w[user].each { |f| require "models/#{f}" }

run ApplicationController
map('/users') { run UsersController }
run SessionController
