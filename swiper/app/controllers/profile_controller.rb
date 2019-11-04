class ProfileController < ApplicationController
    before_action :require_login

    def show
        @user = User.find(params[:id])
        redirect_to root_path unless @user == current_user
        @listings = @user.listings

        @transactions = ActiveRecord::Base.connection.exec_query("SELECT * FROM listings WHERE buyer = #{params[:id]};")
    end
end
