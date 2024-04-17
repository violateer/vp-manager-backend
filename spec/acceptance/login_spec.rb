# encoding: utf-8
require "rails_helper"
require "rspec_api_documentation/dsl"

resource "登录" do
  authentication :basic, :auth
  let(:current_user) { User.create email: "1828257089@qq.com" }
  let(:auth) { "Bearer #{current_user.generate_jwt}" }
  let(:email) { "1@qq.com" }
  let(:password) { "1@qq.com" }

  post "/api/v1/login" do
    parameter :email, "登录邮箱"
    parameter :password, "密码"

    example "登录" do
      User.new email: "1@qq.com", password: "123456", name: "violateer", phone: "123123"
      do_request
      expect(status).to eq 200
      json = JSON.parse response_body
      p json
    end
  end
end