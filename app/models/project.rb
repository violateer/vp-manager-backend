class Project < ApplicationRecord
  has_and_belongs_to_many :users

  validates :name, presence: { message: "项目名称不能为空！" }, uniqueness: { message: "项目名称已存在！" }
end
