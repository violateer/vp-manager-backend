class Api::V1::RegistersController < ApplicationController
  def create
    return render json: { success: false, message: "两次密码不一致！" }, status: 422 if params[:password] != params[:password_confirm]

    user = User.select(:id, :email, :name, :phone, :avatar, :created_at, :updated_at).find_by_email(params[:email])
    if user.nil?
      newUser = User.new email: params[:email], password: params[:password], name: params[:name]
      if newUser.save
          # 创建账号时默认创建一个自己的项目
          project = newUser.projects.create name: "我的个人空间", manager_user: newUser
          project.save

          newUser.update active_project: project

          render json: { token: newUser.generate_jwt }, status: :ok
      else
          render json: { errors: newUser.errors }, status: :unprocessable_entity
      end
    else
      render json: { success: false, message: "该邮箱已注册！" }, status: 409
    end
  end
end
