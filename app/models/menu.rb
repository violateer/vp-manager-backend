class Menu < ApplicationRecord
  # 将 children 属性定义为可访问的属性
  attr_accessor :children

  validates :name, presence: {message: "不能为空"}
  validates :project_id, presence: {message: "不能为空"}
  validates :level, presence: {message: "不能为空"}


  def self.tree_structure(project_id, parent_id = nil)
    # 查询出所有满足条件的子数据
    children = where(parent_id: parent_id, project_id: project_id).order(sequ: :asc)

    # 遍历子数据，递归调用方法，将子数据的子数据放入其 children 中
    children.each do |child|
      child.children = tree_structure(project_id, child.id)
    end

    # 返回包含树形结构的数据的数组
    children
  end

  def as_json(options = {})
    if options[:exclude_children]
      super(options)
    else
      super(options.merge({methods: [:children]}))
    end
  end
end
