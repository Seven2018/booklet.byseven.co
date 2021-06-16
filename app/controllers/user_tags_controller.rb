class UserTagsController < ApplicationController
  def create
    @tag = Tag.find(params[:tag_id])
    @user_tag = UserTag.new
    authorize @user_tag
    # Links User to UserTags through joined table
    array = params[:tag][:user_ids].drop(1).map(&:to_i)
    array.each do |ind|
      if UserTag.where(tag_id: @tag.id, user_id: ind).empty?
        UserTag.create(tag_id: @tag.id, tag_category_id: @tag.tag_category_id, user_id: ind)
      end
    end
    # Select all Users whose checkbox is unchecked and destroy their UserTag, if existing
    (User.where(company_id: current_user.company_id).ids - array).each do |ind|
      unless UserTag.where(tag_id: @tag.id, user_id: ind).empty?
        UserTag.where(tag_id: @tag.id, user_id: ind).first.destroy
      end
    end
    redirect_to tag_path(@tag)
  end
end
