# encoding: utf-8
require "rails_helper"
require "rspec_api_documentation/dsl"

resource "登录" do

  post "/api/v1/login" do
    parameter :email, "登录邮箱"
    parameter :password, "密码"

    let(:email) { "1@qq.com" }
    let(:password) { "1@qq.com" }

    example "登录" do
      User.create email: "1@qq.com", password: "1@qq.com", name: "test", phone: "123123"
      do_request
      expect(status).to eq 200
      json = JSON.parse response_body
      expect(json).to include("token")
    end
  end
end