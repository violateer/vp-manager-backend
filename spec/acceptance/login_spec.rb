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
      user = User.create email: "1@qq.com", password: "123456", name: "violateer", phone: "123123"
      p user
      do_request
    #   expect(status).to eq 200
      json = JSON.parse response_body
      p json
    end
  end
end