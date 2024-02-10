class Api::V1::ProjectsController < ApplicationController
  def index
    projects = Project.page(params[:page])
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
    project = Project.find_by_id params[:id]
    return render status: :not_found if project.nil?
    render json: {
      resource: project
    }
  end

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

  def update
    return render json: { success: false, message: "项目名称不能为空！" }, status: 422 if params[:name].nil?
    project = Project.find_by_id params[:id]
    return render status: :not_found if project.nil?

    project.update params.permit(:name)

    if project.errors.empty?
      render json: { resource: project }, status: :ok
    else
      render json: { errors: project.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    project = Project.find_by_id params[:id]
    return render status: :not_found if project.nil?

    if project.destroy
      # 删除成功，返回成功信息
      render json: { resources: project, message: "删除成功！" }, status: :ok
    else
      # 删除失败，返回失败信息
      render json: { error: "删除失败！" }, status: :unprocessable_entity
    end
  end
end
