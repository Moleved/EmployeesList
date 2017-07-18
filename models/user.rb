class User < ActiveRecord::Base
  include BCrypt

  validates :name, :email, :password, presence: true
  validates :email, uniqueness: true
  validates :password,
            length: { minimum: 6,
                      too_short: '%{count} character is minimum required' }

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  def self.from_github(auth_hash)
    user = find_by(uid: auth_hash['uid'], provider: auth_hash['provider'])
    user.nil? && (user = create_user_from_github(auth_hash))
    user
  end

  private

  def create_user_from_github(args)
    user = User.new
    user.uid = args['uid']
    user.provider = args['provider']
    user.name = args['info']['name']
    user.url = args['info']['urls']['GitHub']
    user.email = args['info']['email']
    user.password = Forgery::Basic.password
    user.save!
    user
  end

end
