class Api::V1::RegistersController < ApplicationController
  def create
    user = User.select(:id, :email, :name, :phone, :avatar, :created_at, :updated_at).find_by_email(params[:email])
    if user.nil?
      newUser = User.new email: params[:email], password: params[:password], name: params[:name]
        if newUser.save
            render json: { resource: newUser, token: newUser.generate_jwt }, status: :ok
        else
            render json: { errors: newUser.errors }, status: :unprocessable_entity
        end
    else
      render json: { success: false, message: "该邮箱已注册！" }, status: 409
    end
  end
end
