class ProfileController < ApplicationController
    before_action :require_login

    def show
        @user = User.find(params[:id])
        redirect_to root_path unless @user == current_user
        @listings = @user.listings

        @transactions = Listing.find_by_sql("SELECT * FROM listings WHERE buyer = #{params[:id]} AND NOT completed;")
        @history = Listing.find_by_sql("SELECT * FROM listings WHERE buyer = #{params[:id]} AND completed;")
    end
end
