class UsersController < ApplicationController
  before do
    protected!
  end

  get '/' do
    @users = User.all
    haml :users
  end

  get '/:id' do
    @user = User.find(params[:id])
  end
end
