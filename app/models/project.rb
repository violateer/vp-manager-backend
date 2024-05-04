class Project < ApplicationRecord
  has_and_belongs_to_many :users
  belongs_to :manager_user, class_name: "User", optional: true

  validates :name, presence: { message: "项目名称不能为空！" }
  
  def self.tree_structure(projects)
    project_hash = projects.index_by(&:id)
    tree = []

    projects.each do |project|
      parent_id = project.parent_id 

      if parent_id.nil?
        tree << project.attributes.merge(children: [])
      else
        parent = project_hash[parent_id]
        parent.children ||= []
        parent.children << project.attributes.merge(children: [])
      end
    end

    tree
  end
end
