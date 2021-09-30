# Updated : 2021/07/19

class UserInterestsController < ApplicationController

  # Create a user_interest (like) (pages/catalogue)
  def create
    user = current_user
    @content = Content.find(params[:content_id])
    user_interest = UserInterest.find_by(content_id: @content.id, user_id: user.id)
    if user_interest.nil?
      user_interest = UserInterest.new(content_id: @content.id, user_id: user.id, status: 'Interested')
    elsif user_interest.status != 'Completed'
      user_interest.update(status: 'Interested')
    end
    authorize user_interest
    if user_interest.save
      respond_to do |format|
        format.html {redirect_to catalogue_path}
        format.js
      end
    end
  end

  # Recommend a content to selected users
  def recommend
    # @users = User.where(id: params[:recommend][:users_id])
    @user = User.find(params[:recommend][:user_id])
    if params[:recommend][:folder_id].present?
      @folder = Folder.find(params[:recommend][:folder_id])
    else
      @content = Content.find(params[:recommend][:content_id])
    end
    params[:recommend][:folder_id].present? ? @interest = UserInterest.find_by(user_id: @user.id, folder_id: @folder.id) : @interest = UserInterest.find_by(user_id: @user.id, content_id: @content.id)
    if @interest.present?
      @interest.update(recommendation: 'Pending')
    else
      params[:recommend][:folder_id].present? ? @interest = UserInterest.create(folder_id: @folder.id, user_id: @user.id, recommendation: 'Pending') : @interest = UserInterest.create(content_id: @content.id, user_id: @user.id, recommendation: 'Pending')
    end
    authorize @interest
    respond_to do |format|
      format.js
    end
  end

  # Validate or invalidate a recommendation for current user
  def update_recommendation
    user = current_user
    user_interest = UserInterest.find(params[:answer_reco][:user_interest_id])
    authorize user_interest
    user_interest.recommendation == 'Pending' ? @switch = 'false' : @switch = 'true'
    user_interest.update(recommendation: params[:answer_reco]["answer-#{user_interest.id}"], comments: params[:answer_reco][:comments])

    @recommendations = UserInterest.where(user_id: current_user)
    @pending_recommendations = @recommendations.where(recommendation: "Pending")
    @accepted_recommendations = @recommendations.where(recommendation: "Yes")
    @declined_recommendations = @recommendations.where(recommendation: "No")
    respond_to do |format|
      format.html {redirect_to dashboard_path}
      format.js
    end
  end

  # Remove a user_interest (like) (pages/catalogue, users/show)
  def destroy
    user_interest = UserInterest.find(params[:id])
    @content = Content.find(user_interest.content_id)
    authorize user_interest
    if user_interest.status == 'Interested' && user_interest.recommendation.nil?
      user_interest.destroy
    elsif user_interest.recommendation.present? && user_interest.status != 'Completed'
      user_interest.update(status: nil)
    end
    if params[:redirect_from] == 'user_show'
      @redirect_from = params[:redirect_from]
      @user = current_user
    end
    respond_to do |format|
      format.html {redirect_to catalogue_path}
      format.js
    end
  end
end
