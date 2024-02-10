class Api::V1::MenusController < ApplicationController
  def create
    current_user = User.find request.env["current_user_id"]
    return render status :unauthorized if current_user.nil?

    project = Project.find_by_id request.env["active_project_id"]

    parent_menu = Menu.find_by_id params["parent_id"]
    menu = Menu.new name: params[:name], project_id: project.id

    if parent_menu.nil?
      menu.level = 0
    else
      menu.level = parent_menu.level + 1
      menu.parent_id = parent_menu.id
    end

    if menu.save
        render json: { resource: menu }, status: :ok
    else
        render json: { errors: menu.errors }, status: :unprocessable_entity
    end
  end

  def tree
    menus = Menu.tree_structure(request.env["active_project_id"])

    # 将菜单数据转换为 JSON 格式，并返回给客户端
    render json: menus
  end

  def list
    menus = Menu.where({project_id: request.env["active_project_id"]})
    render json: menus.as_json(exclude_children: true)
  end

end
