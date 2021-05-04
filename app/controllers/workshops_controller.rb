class WorkshopsController < ApplicationController
  before_action :set_workshop, only: [:show, :view_mode, :edit, :update, :update_workshop, :destroy]
  before_action :force_json, only: [:change_author]
  helper VideoHelper

  # def index
  #   # Index with 'search' option and global visibility for SEVEN Users
  #   if current_user.access_level == 'Super Admin'
  #     @workshops = policy_scope(Workshop)
  #     if params[:search]
  #       @workshops = ((Workshop.where("lower(title) LIKE ?", "%#{params[:search][:title].downcase}%").order(title: :asc)) + (Workshop.joins(:company).where("lower(companies.name) LIKE ?", "%#{params[:search][:title].downcase}%"))).flatten(1).uniq
  #     elsif params[:filter]
  #       @workshops = Workshop.joins(:workshop_categories).where(workshop_categories: {category_id: params[:filter].map(&:to_i)})
  #     end
  #   # Index for other Users, with visibility limited to programs proposed by their company only
  #   else
  #     @workshops = policy_scope(Workshop)
  #     @workshops = Workshop.where(company_id: current_user.company.id)
  #     if params[:search]
  #       @workshops = @workshops.where("lower(title) LIKE ?", "%#{params[:search][:title].downcase}%").order(title: :asc)
  #     end
  #   end
  # end

  def show
    authorize @workshop
    @workshop_skill = WorkshopSkill.new
    @workshop_category = WorkshopCategory.new
  end

  def view_mode
    authorize @workshop
  end

  def new
    @workshop = Workshop.new
    authorize @workshop
    @workshop_category = WorkshopCategory.new
  end

  def create
    @workshop = Workshop.new(workshop_params)
    authorize @workshop
    @workshop.company_id = current_user.company.id
    @workshop.author_id = current_user.id
    if @workshop.save

      # # Links Workshop to Categories through joined table
      # array = params[:workshop][:category_ids].drop(1).map(&:to_i)
      # array.each do |ind|
      #   if WorkshopCategory.where(workshop_id: @workshop.id, category_id: ind).empty?
      #     WorkshopCategory.create(workshop_id: @workshop.id, category_id: ind)
      #   end
      # end
      # # Select all Categories whose checkbox is unchecked and destroy their WorkshopCategory, if existing
      # (Category.ids - array).each do |ind|
      #   unless WorkshopCategory.where(workshop_id: @workshop.id, category_id: ind).empty?
      #     WorkshopCategory.where(workshop_id: @workshop.id, category_id: ind).first.destroy
      #   end
      # end

      redirect_to workshop_path(@workshop)
    else
      render :new
    end
  end

  def create_workshop
    @new_workshop = Workshop.new(title: params[:new_workshop][:title], description: params[:new_workshop][:description], company_id: current_user.company_id, author_id: current_user.id)
    skip_authorization
    if @new_workshop.save
      # params[:new_workshop][:categories].reject!(&:empty?).each do |category_id|
      #   WorkshopCategory.create(workshop_id: @new_workshop.id, category_id: category_id.to_i)
      # end
    end
    respond_to do |format|
      format.html {redirect_to new_workshop_path}
      format.js
    end
  end

  def edit
    authorize @workshop
  end

  def update
    authorize @workshop
    @workshop.update(workshop_params)
    if @workshop.save
      redirect_to workshop_path(@workshop)
    else
      render :edit
    end
  end

  def update_workshop
    skip_authorization
    @workshop.update(title: params[:new_workshop][:title], description: params[:new_workshop][:description])
    if @workshop.save
      params[:new_workshop][:categories].reject!(&:empty?).each do |category_id|
        unless WorkshopCategory.where(workshop_id: @workshop.id, category_id: category_id.to_i).present?
          WorkshopCategory.create(workshop_id: @workshop.id, category_id: category_id.to_i)
        end
      end
      to_destroy = Category.where(company_id: current_user.company_id).map(&:id) - params[:new_workshop][:categories].map{|x| x.to_i}
      WorkshopCategory.where(workshop_id: @workshop.id, category_id: to_destroy).destroy_all
    end
    respond_to do |format|
      format.html {redirect_to new_workshop_path}
      format.js
    end
  end

  def change_author
    skip_authorization
    if params[:ajax].present?
      @workshop = Workshop.find(params[:workshop_id])
      @workshop.update(author_id: params[:user_id])
      redirect_to workshop_path(@workshop)
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
    @workshop.destroy
    authorize @workshop
    redirect_to catalogue_path
  end

  def filter
    @workshops = @workshops = Workshop.where(company_id: current_user.company.id)
    authorize @workshops
    category_ids = params[:workshop][:category_ids].drop(1).map(&:to_i)
    redirect_to workshops_path(filter: category_ids)
  end

  def book
    @workshop = Workshop.find(params[:id])
    authorize @workshop
    if params[:commit] == 'Clear'
      redirect_to url_for(filter: params[:filter].except(:tag, :job).permit!.merge(only_path: true))
    elsif params[:commit] == 'Book Now'
      params.permit!
      participants = params[:participant][:user_ids].reject{|x| x.empty?}.map{|c| c.to_i}
      workshop = Workshop.find(params[:id].to_i)
      @training_workshop = TrainingWorkshop.create(workshop.attributes.except("id", "created_at", "updated_at", "author_id"))
      @training_workshop.workshop_id = workshop.id
      if @training_workshop.save
        @training_workshop.update(date: Date.strptime(params[:filter][:date], '%d/%m/%Y'), starts_at: DateTime.strptime(params[:filter]['starts_at(1i)']+'-'+params[:filter]['starts_at(2i)']+'-'+params[:filter]['starts_at(3i)']+'-'+params[:filter]['starts_at(4i)']+'-'+params[:filter]['starts_at(5i)'], '%Y-%m-%d-%H-%M'), ends_at: DateTime.strptime(params[:filter]['ends_at(1i)']+'-'+params[:filter]['ends_at(2i)']+'-'+params[:filter]['ends_at(3i)']+'-'+params[:filter]['ends_at(4i)']+'-'+params[:filter]['ends_at(5i)'], '%Y-%m-%d-%H-%M'))
        participants.each do |participant|
          Attendee.create(training_workshop_id: @training_workshop.id, user_id: participant)
        end
        redirect_to training_workshop_path(@training_workshop)
      end
    end
    @training_workshop = TrainingWorkshop.new
    if params[:filter].present? && (params[:filter][:job] != [""] || params[:filter][:tag].reject{|x|x.empty?} != []) && params[:filter][:tag].present?
      tags = Tag.where(tag_name: params[:filter][:tag].reject(&:blank?)).map{|x| x.id}
      if params[:filter][:job] != [""]
        if tags.present?
          @users = (User.joins(:user_tags).where(company_id: current_user.company_id, job_description: params[:filter][:job].reject(&:blank?), user_tags: {tag_id: Tag.where(tag_name: params[:filter][:tag].reject(&:blank?)).map{|x| x.id}}).uniq)
        else
          @users = (User.where(company_id: current_user.company_id, job_description: params[:filter][:job].reject(&:blank?)))
        end
      else
        @users = (User.joins(:user_tags).where(company_id: current_user.company_id, user_tags: {tag_id: tags}).uniq)
      end
    else
      @users = User.where(company_id: current_user.company_id)
    end
  end

  private

  def set_workshop
    @workshop = Workshop.find(params[:id])
  end

  def workshop_params
    params.require(:workshop).permit(:title, :description, :duration, :image, :content, :workshop_type)
  end

  def force_json
    request.format = :json
  end
end
