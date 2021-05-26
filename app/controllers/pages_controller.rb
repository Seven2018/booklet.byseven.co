class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
  end

  def dashboard
    @completed_contents = Training.joins(sessions: :attendees).where(attendees: {user_id: current_user.id, status: 'Completed'})
    @my_contents = Training.joins(sessions: :attendees).where(attendees: {user_id: current_user.id, status: 'Registered'}).where.not('date < ?', Date.today)
    if ['Super Admin', 'Admin', 'HR'].include?(current_user.access_level)
      @available_contents = Training.joins(:sessions).where(company_id: current_user.company_id).where.not('date < ?', Date.today) - @my_contents
    else
      @available_contents = Session.joins(:attendees).where(attendees: {user_id: current_user.id, status: 'Invited'}).where.not('date < ?', Date.today)
    end
  end

  def calendar_month
    @contents = Session.joins(:content).where(contents: {company_id: current_user.company_id})
  end

  def calendar_week
    @contents = Session.joins(:content).where(contents: {company_id: current_user.company_id})
  end

  def catalogue
    if params[:filter].present?
      if params[:filter][:themes].split(',').uniq.present?
        @contents = Content.joins(:content_categories).where(company_id: current_user.company_id, content_categories: {category_id: params[:filter][:themes].split(',')}).order(title: :asc).uniq
      else
        @contents = Content.where(company_id: current_user.company_id).order(title: :asc)
      end
      respond_to do |format|
        format.html {catalogue_path}
        format.js
      end
    # Index with 'search' option and global visibility for SEVEN Users
    elsif current_user.access_level == 'Super Admin'
      @contents = Content.all.order(title: :asc)
      if params[:search].present?
        @contents = Content.where("lower(title) LIKE ?", "%#{params[:search][:title].downcase}%").order(title: :asc)
        respond_to do |format|
          format.html {catalogue_path}
          format.js
        end
      end
    # Index for other Users, with visibility limited to programs proposed by their company only
    else
      @contents = Content.where(company_id: current_user.company.id).order(title: :asc)
      if params[:search].present?
        @contents = Content.where(company_id: current_user.company.id).where("lower(title) LIKE ?", "%#{params[:search][:title].downcase}%").order(title: :asc)
        respond_to do |format|
          format.html {catalogue_path}
          format.js
        end
      end
    end
  end

  def catalogue_content_link_category
    skip_authorization
    if params[:new_category].present?
      Category.create(company_id: current_user.company_id, title: params[:new_category][:title])
      @content = Content.find(params[:new_category][:content_id])
      @modal = 'true'
    elsif params[:delete].present?
      Category.find(params[:category_id]).destroy
      @content = Content.find(params[:content_id])
      @modal = 'true'
    elsif params[:add_categories].present?
      @action = params[:add_categories][:page]
      @content = Content.find(params[:add_categories][:content_id])
      ids = params[:content][:categories].reject{|x| x.empty?}
      ids.each do |category_id|
        unless ContentCategory.find_by(content_id: @content.id, category_id: category_id).present?
          ContentCategory.create(content_id: @content.id, category_id: category_id)
        end
      end
      ContentCategory.where(content_id: @content.id).where.not(category_id: ids).each do |content_category|
        content_category.destroy
      end
    end
    respond_to do |format|
      format.js
    end
  end

  def catalogue_filter_add_category
    skip_authorization
    params[:categories].present? ? @filtered_themes = Category.where(id: (params[:categories].split(',') + params[:category_id].split())) : @filtered_themes = Category.where(id: params[:category_id])
    respond_to do |format|
      format.js
    end
  end

  def organisation
    # Index with 'search' option and global visibility for SEVEN Users
    index_function(User.all)
    # Index for other Users, with visibility limited to programs proposed by their company only
    @tags = Tag.joins(:company).where(companies: {id: current_user.company_id})
    @tag_categories = TagCategory.where(company_id: current_user.company_id).order(position: :asc)
    if params[:add_tags].present?
      users = User.where(id: params[:add_tags][:users].split(','))
      tags = Tag.where(tag_name: params[:add_tags][:tag].reject(&:blank?))
      users.each do |user|
        tags.each do |tag|
          UserTag.create(user_id: user.id, tag_id: tag.id)
        end
      end
    end
    respond_to do |format|
      format.html {organisation_path}
      format.js
    end
  end

  def book
  end

  private

  def index_function(parameter)
    if ['Super Admin', 'HR'].include?(current_user.access_level)
      if params[:search].present?
        if params[:filter][:themes].split(',').uniq.present?
          @users = (parameter.where(company_id: current_user.company.id).where('lower(firstname) LIKE ?', "%#{params[:search][:name].downcase}%") + parameter.where('lower(lastname) LIKE ?', "%#{params[:search][:name].downcase}%"))
        else
          @users = parameter.where(company_id: current_user.company.id).order(id: :asc)
        end
        @users = @users.sort_by{ |user| user.lastname } if @users.present?
      elsif params[:filter].present? && (params[:filter][:job] != [""] || params[:filter][:tag].reject{|x|x.empty?} != [])
        # tags = Tag.where(tag_name: params[:filter][:tag].reject(&:blank?)).map{|x| x.id}
        tags = Tag.where(tag_name: params[:filter][:tag].reject(&:blank?))
        tags_hash = {}
        tags.each do |tag|
          if tags_hash[tag.tag_category_id].present?
            tags_hash[tag.tag_category_id] << tag
          else
            tags_hash[tag.tag_category_id] = [tag]
          end
        end
        if params[:filter][:job] != [""] && params[:filter][:job].present?
          if tags.present?
            @users = (parameter.joins(:user_tags).where(company_id: current_user.company_id, job_title: params[:filter][:job].reject(&:blank?), user_tags: {tag_id: tags}).uniq)
          else
            @users = (parameter.where(company_id: current_user.company_id, job_title: params[:filter][:job].reject(&:blank?)))
          end
        elsif tags.empty?
          @users = parameter.where(company_id: current_user.company.id).order('lastname ASC')
        else
          # @users = (parameter.joins(:user_tags).where(company_id: current_user.company_id, user_tags: {tag_id: tags}).uniq).select{|x| x.tags.map(&:id) & tags == tags}
          # @users = (parameter.joins(:user_tags).where(company_id: current_user.company_id, user_tags: {tag_id: tags}).uniq)
          @users = parameter.joins(:user_tags).where(company_id: current_user.company_id)
          tags_hash.each do |key, value|
            @users = @users.select{|x| (x.tags & value).present?}.uniq
          end
          @users = @users.uniq
        end
        @filter_jobs = params[:filter][:job].reject{|c| c.empty?}
        @filter_tags = params[:filter][:tag].reject{|c| c.empty?}
      elsif params[:order].present?
        if params[:order] == 'tag_category'
          params[:mode] == 'asc' ? @users = User.joins(:tags).merge(Tag.where(tag_category_id: params[:tag_category_id]).order(tag_name: :asc)) : @users = User.joins(:tags).merge(Tag.where(tag_category_id: params[:tag_category_id]).order(tag_name: :desc))
          @users = (@users + User.where(company_id: current_user.company.id).order(lastname: :asc)).uniq
        else
          params[:mode] == 'asc' ? @users = User.where(id: params[:users].split(',')).order(params[:order]) : @users = User.where(id: params[:users].split(',')).order(params[:order]).reverse
        end
      else
        @users = parameter.where(company_id: current_user.company.id).order(id: :asc)
      end
    end
  end
end
