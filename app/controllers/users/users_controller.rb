class Users::UsersController < ApplicationController
before_filter :authenticate_user!
  def post_twitt
   if  params[:message].present?
    current_user.post_tweets(params[:message])
    redirect_to :back
   else
   redirect_to:back
   end
  end
  def twitt
  end
end