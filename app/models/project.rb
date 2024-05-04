class Project < ApplicationRecord
  has_and_belongs_to_many :users
  belongs_to :manager_user, class_name: "User", optional: true

  validates :name, presence: { message: "项目名称不能为空！" }
  
  def self.tree_structure(projects_base, parent_id = nil)
    projects = projects_base.where(parent_id: parent_id)
  
    # 递归构建树结构
    tree = projects.map do |project|
      project_data = project.attributes.symbolize_keys
      children = tree_structure(projects_base, project.id)
      project_data[:children] = children if children.present?
      project_data
    end
  
    # 返回树形结构
    tree
  end
end
