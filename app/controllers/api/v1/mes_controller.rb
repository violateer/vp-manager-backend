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

  def switch_project
    current_user = User.find request.env["current_user_id"]
    return render status :unauthorized if current_user.nil?
    active_project = Project.find request.env["active_project_id"]
    return render status :unauthorized if active_project.nil?

    to_project_id = params[:project_id]

    if to_project_id.blank?
      render json: { message: "请传入project_id" }, status: :unprocessable_entity
      return
    end

    # 根据传入的 project_id 更新当前用户的 active_project_id
    to_project = Project.find_by(id: to_project_id)
    
    if to_project.nil?
      render json: { message: "未找到指定的项目" }, status: :not_found
      return
    end
    
    current_user.update_columns active_project_id: to_project.id

    p current_user.errors

    render json: { message: "切换成功！" }, status: :ok

  end
end
