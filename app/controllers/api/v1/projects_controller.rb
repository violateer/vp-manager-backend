class Api::V1::ProjectsController < ApplicationController
  def index
    current_user = User.find request.env["current_user_id"]
    return render status :unauthorized if current_user.nil?
    projects = Project.page(params[:page])
              .per(params[:per])

    render json: {
      resources: projects,
      current_user: current_user,
      pager: {
        page: params[:page] || 1,
        per_page: Project.default_per_page,
        count: Project.count,
      },
    }
  end

  def create
    project = Project.new name:'项目1'
    head 201
    # if project.save
    #     render json: { resource: project }, status: :ok
    # else
    #     render json: { errors: project.errors }, status: :unprocessable_entity
    # end
  end

  def show
    p 'show'
  end
end
