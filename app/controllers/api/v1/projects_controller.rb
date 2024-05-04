class Api::V1::ProjectsController < ApplicationController
  def index
    current_user = User.find request.env["current_user_id"]
    return render status :unauthorized if current_user.nil?

        
    # 查询manager_user_id为user_id的projects
    projects_managed_by_user = Project.where(manager_user_id: current_user.id)

    # 查询project_users中有user_id的结果，然后根据project_id查询projects
    projects_associated_with_user = Project.where(id: ProjectUser.where(user_id: current_user.id).pluck(:project_id))

    # 将两个查询结果合并并去重
    projects = projects_managed_by_user.or(projects_associated_with_user).distinct.order(created_at: :asc).page(params[:page]).per(params[:per])

    render json: {
      resources: projects,
      pager: {
        page: params[:page] || 1,
        per_page: Project.default_per_page,
        count: Project.count,
      },
    }
  end

  def list
    current_user = User.find request.env["current_user_id"]
    return render status :unauthorized if current_user.nil?
        
    # 查询manager_user_id为user_id的projects
    projects_managed_by_user = Project.where(manager_user_id: current_user.id)

    # 查询project_users中有user_id的结果，然后根据project_id查询projects
    projects_associated_with_user = Project.where(id: ProjectUser.where(user_id: current_user.id).pluck(:project_id))

    # 将两个查询结果合并并去重
    projects = projects_managed_by_user.or(projects_associated_with_user).distinct.order(created_at: :asc)

    render json: {
      resources: projects,
    }
  end

  def tree
    current_user = User.find request.env["current_user_id"]
    return render status :unauthorized if current_user.nil?

    projects_managed_by_user = Project.where(manager_user_id: current_user.id)

    projects_associated_with_user = Project.where(id: ProjectUser.where(user_id: current_user.id).pluck(:project_id))

    projects = projects_managed_by_user.or(projects_associated_with_user).distinct.order(created_at: :asc)
    projects_tree = Project.tree_structure(projects)

    # 将菜单数据转换为 JSON 格式，并返回给客户端
    render json: { resource: projects_tree }, status: :ok
  end

  def show
    current_user = User.find request.env["current_user_id"]
    return render status :unauthorized if current_user.nil?
    project = Project.find_by_id params[:id]
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
