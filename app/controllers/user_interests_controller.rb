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

  def recommend_all
    @content = Content.find(params[:recommend_all][:content_id])
    @users_all = User.where(company_id: current_user.company_id)
    @users_yes = @users_all.joins(:user_interests).where(company_id: current_user.company_id, user_interests: {content_id: @content.id, recommendation: 'Yes'})
    @users_no = @users_all.joins(:user_interests).where(company_id: current_user.company_id, user_interests: {content_id: @content.id, recommendation: 'No'})
    @users_pending = @users_all.joins(:user_interests).where(company_id: current_user.company_id, user_interests: {content_id: @content.id, recommendation: 'Pending'})
    @users = User.where(id: params[:recommend_all][:users_ids].split(','))
    @tag_categories = TagCategory.includes([:tags]).where(company_id: current_user.company_id).order(position: :asc)
    @checked = params[:recommend_all][:checked]
    skip_authorization
    if @checked == 'true'
      @users.each do |user|
        user_interest = UserInterest.find_by(content_id: @content.id, user_id: user.id)
        user_interest.present? && user_interest.recommendation.nil? ? user_interest.update(recommendation: 'Pending') : user_interest = UserInterest.create(content_id: @content.id, user_id: user.id, recommendation: 'Pending')
      end
    else
      @users.each do |user|
        user_interest = UserInterest.find_by(content_id: @content.id, user_id: user.id)
        if user_interest.present? && user_interest.status.nil?
          user_interest.destroy
        elsif user_interest.present? && user_interest.recommendation == 'Pending'
          user_interest.update(recommendation: nil)
        end
      end
    end
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
