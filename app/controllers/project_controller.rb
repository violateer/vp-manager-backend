class ProjectController < ApplicationController
  def create
    project = Project.new name:'项目1'
    if project.save
        render json: { resource: project }, status: :ok
      else
        render json: { errors: project.errors }, status: :unprocessable_entity
      end
  end

  def show
    p 'show'
  end
end
