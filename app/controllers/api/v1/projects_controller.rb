class Api::V1::ProjectsController < ApplicationController
  def index
    current_user = User.find request.env["current_user_id"]
    return render status :unauthorized if current_user.nil?
    projects = current_user.projects.page(params[:page])
              .per(params[:per])

    render json: {
      resources: projects,
      pager: {
        page: params[:page] || 1,
        per_page: Project.default_per_page,
        count: Project.count,
      },
    }
  end

  def show
    current_user = User.find request.env["current_user_id"]
    return render status :unauthorized if current_user.nil?
    project = current_user.projects.find_by_id params[:id]
    return render status: :not_found if project.nil?
    render json: {
      resource: project
    }
  end

  def create
    current_user = User.find request.env["current_user_id"]
    return render status :unauthorized if current_user.nil?

    project = current_user.projects.create name: params[:name], manager_user: current_user

    if project.save
        render json: { resource: project }, status: :ok
    else
        render json: { errors: project.errors }, status: :unprocessable_entity
    end
  end

  def update
    current_user = User.find request.env["current_user_id"]
    return render status :unauthorized if current_user.nil?
    return render json: { success: false, message: "项目名称不能为空！" }, status: 422 if params[:name].nil?
    project = Project.find_by_id params[:id]
    return render status: :not_found if project.nil?

    return render json: { message: "仅项目管理员允许修改！" },status: :forbidden if project.manager_user != current_user

    project.update params.permit(:name)

    if project.errors.empty?
      render json: { resource: project }, status: :ok
    else
      render json: { errors: project.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    current_user = User.find request.env["current_user_id"]
    return render status :unauthorized if current_user.nil?
    project = Project.find_by_id params[:id]
    return render status: :not_found if project.nil?

    return render json: { message: "仅项目管理员允许删除！" },status: :forbidden if project.manager_user != current_user

    if project.destroy
      # 删除成功，返回成功信息
      render json: { resources: project, message: "删除成功！" }, status: :ok
    else
      # 删除失败，返回失败信息
      render json: { error: "删除失败！" }, status: :unprocessable_entity
    end
  end
end
