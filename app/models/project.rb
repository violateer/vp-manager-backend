class Project < ApplicationRecord
  has_and_belongs_to_many :users
  belongs_to :manager_user, class_name: "User", optional: true

  validates :name, presence: { message: "项目名称不能为空！" }
end
