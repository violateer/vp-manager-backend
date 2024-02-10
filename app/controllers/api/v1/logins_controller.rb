class Api::V1::LoginsController < ApplicationController
    def create
      return render json: { success: false, message: "请输入密码！" }, status: 422 if params[:password].nil?
      return render json: { success: false, message: "请输入邮箱！" }, status: 422 if params[:email].nil?

      user = User.find_by(email: params[:email])
      if user.nil?
        # 如果未找到用户，则返回 404 错误
        render json: { success: false, message: "未查询到账号，请注册！" }, status: :not_found
      else
        if user.authenticate(params[:password])
          # 如果密码正确，则返回 token
          render json: { token: user.generate_jwt }, status: :ok
        else
          # 如果密码不正确，则返回 401 错误
          render json: { success: false, message: "密码不正确！" }, status: :unauthorized
        end
      end
    end
end
