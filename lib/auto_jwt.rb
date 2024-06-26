# encoding: utf-8

class AutoJwt
  def initialize(app)
    @app = app
  end

  def call(env)
    # 排除不需要jwt的接口
    return @app.call(env) if ["/api/v1/session", "/api/v1/login", "/api/v1/register"].include? env["PATH_INFO"]

    header = env["HTTP_AUTHORIZATION"]
    jwt = header.split(" ")[1] rescue ""

    begin
      payload = JWT.decode jwt, Rails.application.credentials.hmac_secret, true, { algorithm: "HS256" }
    rescue JWT::ExpiredSignature
      return [401, {}, [JSON.generate({ errno: 40101, message: "token expired" })]]
    rescue
      return [401, {}, [JSON.generate({ errno: 40102, message: "token invalid" })]]
    end
    env["current_user_id"] = payload[0]["user_id"] rescue nil

    current_user = User.find env["current_user_id"]
    if current_user.present?
      env["active_project_id"] = current_user.active_project_id rescue nil
    end

    @status, @headers, @response = @app.call(env)

    # 状态码 ， 响应头 ， 响应体
    [@status, @headers, @response]
  end
end
