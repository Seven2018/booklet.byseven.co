class ContentsController < ApplicationController
  before_action :set_content, only: [:show, :view_mode, :edit, :update, :update_content, :destroy]
  before_action :force_json, only: [:change_author]
  helper VideoHelper

  # def index
  #   # Index with 'search' option and global visibility for SEVEN Users
  #   if current_user.access_level == 'Super Admin'
  #     @contents = policy_scope(Content)
  #     if params[:search]
  #       @contents = ((Content.where("lower(title) LIKE ?", "%#{params[:search][:title].downcase}%").order(title: :asc)) + (Content.joins(:company).where("lower(companies.name) LIKE ?", "%#{params[:search][:title].downcase}%"))).flatten(1).uniq
  #     elsif params[:filter]
  #       @contents = Content.joins(:content_categories).where(content_categories: {category_id: params[:filter].map(&:to_i)})
  #     end
  #   # Index for other Users, with visibility limited to programs proposed by their company only
  #   else
  #     @contents = policy_scope(Content)
  #     @contents = Content.where(company_id: current_user.company.id)
  #     if params[:search]
  #       @contents = @contents.where("lower(title) LIKE ?", "%#{params[:search][:title].downcase}%").order(title: :asc)
  #     end
  #   end
  # end

  def show
    authorize @content
    @content_skill = ContentSkill.new
  end

  def view_mode
    authorize @content
  end

  def new
    @content = Content.new
    authorize @content
  end

  def create
    @content = Content.new(content_params)
    authorize @content
    @content.company_id = current_user.company.id
    @content.author_id = current_user.id
    if @content.save

      # # Links Content to Categories through joined table
      # array = params[:content][:category_ids].drop(1).map(&:to_i)
      # array.each do |ind|
      #   if ContentCategory.where(content_id: @content.id, category_id: ind).empty?
      #     ContentCategory.create(content_id: @content.id, category_id: ind)
      #   end
      # end
      # # Select all Categories whose checkbox is unchecked and destroy their ContentCategory, if existing
      # (Category.ids - array).each do |ind|
      #   unless ContentCategory.where(content_id: @content.id, category_id: ind).empty?
      #     ContentCategory.where(content_id: @content.id, category_id: ind).first.destroy
      #   end
      # end

      redirect_to content_path(@content)
    else
      render :new
    end
  end

  def create_content
    @new_content = Content.new(title: params[:new_content][:title], description: params[:new_content][:description], company_id: current_user.company_id, author_id: current_user.id)
    skip_authorization
    if @new_content.save
      # params[:new_content][:categories].reject!(&:empty?).each do |category_id|
      #   ContentCategory.create(content_id: @new_content.id, category_id: category_id.to_i)
      # end
    end
    respond_to do |format|
      format.html {redirect_to new_content_path}
      format.js
    end
  end

  def edit
    authorize @content
  end

  def update
    authorize @content
    @content.update(content_params)
    if @content.save
      redirect_to content_path(@content)
    else
      render :edit
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

  def add_category
    skip_authorization
    # if params[:ajax].present?
    content = Content.find(params[:content_id])
    category = Category.find(params[:category_id])
    ContentCategory.create(content_id: content.id, category_id: category.id)
    respond_to do |format|
      format.html {redirect_to catalogue_path}
      format.js
    end
    # else
    #   @categories = Category.where(company_id: current_user.company_id).ransack(title_cont: params[:search]).result(distinct: true)
    #   respond_to do |format|
    #     format.json {
    #       @users = @categories.limit(5)
    #     }
    #   end
    # end
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
    redirect_to catalogue_path
  end

  def filter
    @contents = @contents = Content.where(company_id: current_user.company.id)
    authorize @contents
    category_ids = params[:content][:category_ids].drop(1).map(&:to_i)
    redirect_to contents_path(filter: category_ids)
  end

  def book
    @content = Content.find(params[:id])
    authorize @content
    if params[:commit] == 'Clear'
      redirect_to url_for(filter: params[:filter].except(:tag, :job).permit!.merge(only_path: true))
    elsif params[:commit] == 'Book Now'
      params.permit!
      participants = params[:participant][:user_ids].reject{|x| x.empty?}.map{|c| c.to_i}
      content = Content.find(params[:id].to_i)
      # training_contents = []
      # @training_content = Session.new(content.attributes.except("id", "created_at", "updated_at", "author_id").merge(date: Date.strptime(params[:filter][:date], '%d/%m/%Y'), starts_at: DateTime.strptime(params[:filter]['starts_at(4i)']+'-'+params[:filter]['starts_at(5i)'] + ' CET', '%H-%M %Z'), ends_at: DateTime.strptime(params[:filter]['ends_at(4i)']+'-'+params[:filter]['ends_at(5i)'] + ' CET', '%H-%M %Z'), date1: Date.strptime(params[:filter][:date1], '%d/%m/%Y'), starts_at1: Time.strptime(params[:filter]["starts_at(4i)1"] + '-' + params[:filter]["starts_at(5i)1"] + ' CET', '%H-%M %Z'), ends_at1: Time.strptime(params[:filter]["ends_at(4i)1"] + '-' + params[:filter]["ends_at(5i)1"] + ' CET', '%H-%M %Z'), date2: Date.strptime(params[:filter][:date2], '%d/%m/%Y'), starts_at2: Time.strptime(params[:filter]["starts_at(4i)12"] + '-' + params[:filter]["starts_at(5i)12"] + ' CET', '%H-%M %Z'), ends_at2: Time.strptime(params[:filter]["ends_at(4i)12"] + '-' + params[:filter]["ends_at(5i)12"] + ' CET', '%H-%M %Z'), date3: Date.strptime(params[:filter][:date3], '%d/%m/%Y'), starts_at3: Time.strptime(params[:filter]["starts_at(4i)123"] + '-' + params[:filter]["starts_at(5i)123"] + ' CET', '%H-%M %Z'), ends_at3: Time.strptime(params[:filter]["ends_at(4i)123"] + '-' + params[:filter]["ends_at(5i)123"] + ' CET', '%H-%M %Z'), date4: Date.strptime(params[:filter][:date4], '%d/%m/%Y'), starts_at4: Time.strptime(params[:filter]["starts_at(4i)1234"] + '-' + params[:filter]["starts_at(5i)1234"] + ' CET', '%H-%M %Z'), ends_at4: Time.strptime(params[:filter]["ends_at(4i)1234"] + '-' + params[:filter]["ends_at(5i)1234"] + ' CET', '%H-%M %Z')))
      @training_content = Session.new(content.attributes.except("id", "created_at", "updated_at", "author_id").merge(params.require(:filter).permit(:title, :duration, :participant_number, :description, :content, :image, :date, :available_date, :starts_at, :ends_at, :date1, :starts_at1, :ends_at1, :date2, :starts_at2, :ends_at2, :date3, :starts_at3, :ends_at3, :date4, :starts_at4, :ends_at4)))
      # training_contents << @training_content
      @training_content.content_id = content.id
      if @training_content.save
        # if params[:filter]['date-1'].present?
        #   i = 1
        #   while true
        #     if params[:filter]["date-#{i}"].present?
        #       new_training_content = Session.create(content.attributes.except("title", "id", "created_at", "updated_at", "author_id").merge(title: content.title + " #{i}/#{training_contents.count + 1}",date: Date.strptime(params[:filter]["date-#{i}"], '%d/%m/%Y'), starts_at: DateTime.strptime(params[:filter]["starts_at(1i)"]+'-'+params[:filter]["starts_at(2i)"]+'-'+params[:filter]["starts_at(3i)"]+'-'+params[:filter]["starts_at(4i)-#{i}"]+'-'+params[:filter]["starts_at(5i)-#{i}"], '%Y-%m-%d-%H-%M'), ends_at: DateTime.strptime(params[:filter]['ends_at(1i)']+'-'+params[:filter]['ends_at(2i)']+'-'+params[:filter]['ends_at(3i)']+'-'+params[:filter]["ends_at(4i)-#{i}"]+'-'+params[:filter]["ends_at(5i)-#{i}"], '%Y-%m-%d-%H-%M'), content_id: content.id))
        #       training_contents << new_training_content
        #       i += 1
        #     else
        #       break
        #     end
        #   end
        #   @training_content.update(title: content.title + " 1/#{training_contents.count}")
        # end
        participants.each do |participant|
          Attendee.create(training_content_id: @training_content.id, user_id: participant)
        end
        redirect_to training_content_path(@training_content)
      end
    end
    @training_content = Session.new
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
