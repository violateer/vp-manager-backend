class ProjectUser < ApplicationRecord
    validates :project_id, presence: { message: "project_id不能为空！" }
    validates :user_id, presence: { message: "user_id不能为空！" }
end
