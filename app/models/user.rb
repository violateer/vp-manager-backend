class User < ApplicationRecord
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: "邮箱格式不正确" }
  validates :password, presence: {message: "不能为空"}, format: { with: /^(?=.*\d)(?=.*[a-zA-Z])(?=.*[^\da-zA-Z\s]).{8,16}$/, multiline: true , message: "密码格式不正确(至少包含字母、数字、特殊字符，8-16位)" }
  validates :name, presence: {message: "不能为空"}

  def generate_jwt
    payload = { user_id: self.id, exp: (Time.now + 2.hours).to_i }
    JWT.encode payload, Rails.application.credentials.hmac_secret, "HS256"
  end

  def generate_auth_header
    { Authorization: "Bearer #{self.generate_jwt}" }
  end
end
