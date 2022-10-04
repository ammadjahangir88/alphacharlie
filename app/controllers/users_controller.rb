class UsersController < ApplicationController


    def index
        @users=User.all
    end


    def show


    end


    def destroy
        
        @user = User.find(params[:id])
       
        @user.destroy
    
        flash[:danger] = "User and all articles created by user have been deleted"
    
        redirect_to users_path
    end


    




end