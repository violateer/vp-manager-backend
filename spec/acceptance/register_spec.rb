# encoding: utf-8
require "rails_helper"
require "rspec_api_documentation/dsl"

resource "注册" do

  post "/api/v1/register" do
    parameter :email, "登录邮箱"
    parameter :name, "用户名"
    parameter :password, "密码"
    parameter :password_confirm, "确认密码"

    let(:email) { "1@qq.com" }
    let(:name) { "test" }
    let(:password) { "1@qq.com" }
    let(:password_confirm) { "1@qq.com" }

    example "注册" do
      do_request
      expect(status).to eq 200
      json = JSON.parse response_body
      expect(json).to include("token")
    end
  end
end