class ContentsController < ApplicationController
  before_action :set_content, only: [:show, :duplicate, :view_mode, :edit, :update, :update_content, :destroy]
  before_action :force_json, only: [:change_author]
  helper VideoHelper

  def show
    authorize @content
    @content_skill = ContentSkill.new
  end

  def view_mode
    authorize @content
  end

  def create
    @content = Content.new(content_params)
    authorize @content
    @content.company_id = current_user.company.id
    @content.author_id = current_user.id
    if @content.save
      redirect_to content_path(@content)
    end
  end

  def edit
    authorize @content
  end

  def update
    authorize @content
    @content.update(content_params)
    if @content.save
      @content = @content
      respond_to do |format|
        format.html {content_path(@content)}
        format.js
      end
    end
  end

  def update_content
    skip_authorization
    @content.update(title: params[:new_content][:title], description: params[:new_content][:description])
    if @content.save
      params[:new_content][:categories].reject!(&:empty?).each do |category_id|
        unless ContentCategory.where(content_id: @content.id, category_id: category_id.to_i).present?
          ContentCategory.create(content_id: @content.id, category_id: category_id.to_i)
        end
      end
      to_destroy = Category.where(company_id: current_user.company_id).map(&:id) - params[:new_content][:categories].map{|x| x.to_i}
      ContentCategory.where(content_id: @content.id, category_id: to_destroy).destroy_all
    end
    respond_to do |format|
      format.html {redirect_to new_content_path}
      format.js
    end
  end

  def duplicate
    authorize @content
    @new_content = Content.new(@content.attributes.except("id", "created_at", "updated_at"))
    @new_content.title = @content.title + ' - Duplicate'
    if @new_content.save
      @contents_filtered = Content.where(id: (params[:contents].split(',')+[@new_content.id]))
      @new_content.description = @content.description.dup
      @new_content.description.record_id = @new_content.id
      @new_content.description.update(body: @content.description.body.dup)
      redirect_to content_path(@new_content)
    end
  end

  def add_category
    skip_authorization
    # if params[:ajax].present?
    @content = Content.find(params[:content_id])
    category = Category.find(params[:category_id])
    ContentCategory.create(content_id: content.id, category_id: category.id)
    @action = params[:page]
    respond_to do |format|
      format.html {redirect_to catalogue_path}
      format.js
    end
  end

  def content_link_category
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

  def change_author
    skip_authorization
    if params[:ajax].present?
      @content = Content.find(params[:content_id])
      @content.update(author_id: params[:user_id])
      redirect_to content_path(@content)
    else
      @users = User.ransack(firstname_or_lastname_cont: params[:search]).result(distinct: true)
      respond_to do |format|
        format.json {
          # render json: @users
          @users = @users.limit(5)
        }
      end
    end
  end

  def destroy
    @content.destroy
    authorize @content
    #if params[:catalogue].present?
    #  @contents = Content.where(id: params[:contents].split(','))
    #  respond_to do |format|
    #    format.js
    #  end
    #else
      redirect_to catalogue_path
    #end
  end

  private

  def set_content
    @content = Content.find(params[:id])
  end

  def content_params
    params.require(:content).permit(:title, :description, :duration, :image, :content, :content_type)
  end

  def force_json
    request.format = :json
  end
end
