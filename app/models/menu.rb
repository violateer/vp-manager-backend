class Menu < ApplicationRecord
  # 将 children 属性定义为可访问的属性
  attr_accessor :children

  validates :name, presence: {message: "不能为空"}
  validates :level, presence: {message: "不能为空"}

  belongs_to :parent, class_name: "Menu", optional: true
  has_many :children, class_name: "Menu", foreign_key: "parent_id", dependent: :destroy


  def self.tree_structure(parent_id = nil)
    # 查询出所有满足条件的子数据
    children = where(parent_id: parent_id).order(sequ: :asc)

    # 遍历子数据，递归调用方法，将子数据的子数据放入其 children 中
    children.each do |child|
      child.children = tree_structure(child.id)
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

  # 删除父级及子级
  def self.delete_with_children(parent_id)
    menu = Menu.find_by(id: parent_id)
    return unless menu

    children = menu.children.to_a
    children.each do |child|
      delete_with_children(child.id)
    end

    menu.destroy
  end
end
