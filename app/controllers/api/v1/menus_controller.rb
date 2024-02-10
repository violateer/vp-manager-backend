class Api::V1::MenusController < ApplicationController
  def create
    current_user = User.find request.env["current_user_id"]
    return render status :unauthorized if current_user.nil?

    project = current_user.projects.create(name: params[:name])

    if project.save
        render json: { resource: project }, status: :ok
    else
        render json: { errors: project.errors }, status: :unprocessable_entity
    end
  end


end
