# Updated : 2021/07/19

class UserInterestsController < ApplicationController

  # Create a user_interest (like) (pages/catalogue)
  def create
    user = current_user
    @content = Content.find(params[:content_id])
    user_interest = UserInterest.new(content_id: @content.id, user_id: user.id, status: 'Interested')
    authorize user_interest
    if user_interest.save
      respond_to do |format|
        format.html {redirect_to catalogue_path}
        format.js
      end
    end
  end

  # Recommend a content for specified user
  def recommend
    @user = User.find(params[:recommend][:user_id])
    @content = Content.find(params[:recommend][:content_id])
    @user_interest = UserInterest.find_by(content_id: @content.id, user_id: @user.id)
    if @user_interest.present? && params[:recommend][:select] == '1'
      @user_interest.update(recommendation: 'Pending')
      @action = 'Add'
    elsif @user_interest.present? && @user_interest.status.nil? && params[:recommend][:select] == '0'
      @user_interest.destroy
      @action = 'Delete'
    else
      @user_interest = UserInterest.create(content_id: @content.id, user_id: @user.id, recommendation: 'Pending')
      @action = 'Add'
    end
    authorize @user_interest
    respond_to do |format|
      format.js
    end
  end

  # Validate or invalidate a recommendation for current user
  def update_recommendation
    user = current_user
    @user_interest = UserInterest.find(params[:answer_reco][:user_interest_id])
    authorize @user_interest
    ['Yes', 'No'].include?(@user_interest.recommendation) ? @switch = 'true' : @switch = 'false'
    @user_interest.update(recommendation: params[:answer_reco][:answer], comments: params[:answer_reco][:comments])
    respond_to do |format|
      format.js
    end
  end

  # Remove a user_interest (like) (pages/catalogue, users/show)
  def destroy
    user_interest = UserInterest.find(params[:id])
    @content = Content.find(user_interest.content_id)
    authorize user_interest
    user_interest.destroy if user_interest.status == 'Interested' && user_interest.recommendation.nil?
    if params[:redirect_from] == 'user_show'
      @redirect_from = params[:redirect_from]
      @user = current_user
    end
    respond_to do |format|
      format.html {redirect_to catalogue_path}
      format.js
    end
  end

  # Mark a content as completed by user (contents/show)
  def complete_content
    skip_authorization
    @user_interest = UserInterest.find_by(user_id: current_user.id, content_id: params[:content_id])
    if @user_interest.present?
      @user_interest.update(status: 'Completed', recommendation: nil)
    else
      UserInterest.create(user_id: current_user.id, content_id: params[:content_id], status: 'Completed')
    end
    respond_to do |format|
      format.js
    end
  end
end
