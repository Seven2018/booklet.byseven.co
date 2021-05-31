class UserInterestsController < ApplicationController

  def create
    user = current_user
    @content = Content.find(params[:content_id])
    user_interest = UserInterest.new(content_id: @content.id, user_id: user.id)
    user_interest.interest_type = 'Interested'
    authorize user_interest
    if user_interest.save
      respond_to do |format|
        format.html {redirect_to catalogue_path}
        format.js
      end
    end
  end

  def destroy
    user_interest = UserInterest.find(params[:id])
    @content = Content.find(user_interest.content_id)
    authorize user_interest
    user_interest.destroy
    respond_to do |format|
      format.html {redirect_to catalogue_path}
      format.js
    end
  end
end
