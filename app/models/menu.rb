class Menu < ApplicationRecord
  def self.tree_structure(parent_id = nil)
    # 查询出所有满足条件的子数据
    children = where(parent_id: parent_id)

    # 遍历子数据，递归调用方法，将子数据的子数据放入其 children 中
    children.each do |child|
      child.children = tree_structure(child.id)
    end

    # 返回包含树形结构的数据的数组
    children
  end

  # 将 children 属性定义为可访问的属性
  attr_accessor :children
end
