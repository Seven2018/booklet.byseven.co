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
      @redirect_from = params[:redirect_from]
      if @redirect_from == 'user_show'
        @user = current_user
      end
      format.html {redirect_to catalogue_path}
      format.js
    end
  end

  def complete_content
    skip_authorization
    @user_interest = UserInterest.find_by(user_id: current_user.id, content_id: params[:content_id])
    if @user_interest.present?
      @user_interest.update(interest_type: 'Completed')
    else
      UserInterest.create(user_id: current_user.id, content_id: params[:content_id], interest_type: 'Completed')
    end
    respond_to do |format|
      format.js
    end
  end
end
