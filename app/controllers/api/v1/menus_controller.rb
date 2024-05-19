class Api::V1::MenusController < ApplicationController
  def create
    current_user = User.find request.env["current_user_id"]
    return render status :unauthorized if current_user.nil?


    parent_menu = Menu.find_by_id params["parent_id"]
    menu = Menu.new name: params[:name], is_system: 0

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
    current_user = User.find request.env["current_user_id"]
    return render status :unauthorized if current_user.nil?
    menus = Menu.order(sequ: :asc).tree_structure()

    # 将菜单数据转换为 JSON 格式，并返回给客户端
    render json: { resource: menus }, status: :ok
  end

  def list
    current_user = User.find request.env["current_user_id"]
    return render status :unauthorized if current_user.nil?
    menus = Menu.all.order(sequ: :asc)
    render json: { resource: menus.as_json(exclude_children: true) }, status: :ok
  end

  def update
    current_user = User.find request.env["current_user_id"]
    return render status :unauthorized if current_user.nil?

    menu = Menu.find params[:id]
    menu.update params.permit(:name)
    if menu.errors.empty?
      render json: { resource: menu }, status: :ok
    else
      render json: { errors: menu.errors }, status: :unprocessable_entity
    end

  end

  def destroy
    current_user = User.find request.env["current_user_id"]
    return render status :unauthorized if current_user.nil?
    menu = Menu.find_by_id params[:id]
    return render status: :not_found if menu.nil?

    return render json: { message: "默认菜单不允许删除！" },status: :forbidden if menu.is_system == "1"

    if Menu.delete_with_children(params[:id])
      # 删除成功，返回成功信息
      render json: { resources: menu, message: "删除成功！" }, status: :ok
    else
      # 删除失败，返回失败信息
      render json: { error: "删除失败！" }, status: :unprocessable_entity
    end
  end

  def delete_multi
    current_user = User.find request.env["current_user_id"]
    return render status :unauthorized if current_user.nil?

    ids = params[:ids].split(',')

    if ids.blank?
      render json: { message: "请传入要删除的id" }, status: :unprocessable_entity
      return
    end

    ids.each do |parent_id|
      Menu.delete_with_children(parent_id)
    end

    render json: { message: "删除成功！" }, status: :ok

  end

end
