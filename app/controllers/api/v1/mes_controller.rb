class Api::V1::MesController < ApplicationController
  def show
    p 'current_user'
    p request.env["current_user_id"]
    current_user = User.find request.env["current_user_id"]
    return render status :unauthorized if current_user.nil?

    active_project = Project.find_by(id: current_user.active_project_id)
    project_name = active_project&.name

    # 将 project_name 拼接到 current_user 对象中
    fields_to_exclude = ['password_digest', 'updated_at', 'created_at']
    current_user_with_project = current_user.attributes.except(*fields_to_exclude).merge(active_project_name: project_name)


    render json: { resource: current_user_with_project }
  end
end
