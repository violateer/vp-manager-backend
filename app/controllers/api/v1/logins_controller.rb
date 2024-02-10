class Api::V1::LoginsController < ApplicationController
    def create
      user = User.find_by_email(params[:email])
      render json: { resources: user, status: :ok }
    end
end
