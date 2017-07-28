module ApplicationHelper
  attr_reader :exp

  def protected!
    authorised? || redirect('/auth/sign_in')
  end

  def extract_token
    request.env['access_token'] || request['access_token'] || session['access_token']
  end

  def authorised?
    @token = extract_token
    payload, header = JWT.decode(@token, settings.verify_key, true)
    @exp = header['exp']
    return false if !token_have_exp? && token_expired?
    @user_id = payload['user_id']
  rescue JWT::DecodeError
    return false
  end

  private

  def token_have_exp?
    !exp.nil?
  end

  def token_expired?
    @exp = Time.at(exp.to_i).utc
    Time.now.utc > exp
  end
end
