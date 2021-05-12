class TrainingWorkshopsController < ApplicationController
  before_action :set_training_workshop, only: [:show, :view_mode, :update, :update_book, :destroy]
  helper VideoHelper

  def show
    @training_workshop = TrainingWorkshop.find(params[:id])
    authorize @training_workshop
    ['Super Admin', 'Admin', 'HR'].include?(current_user.access_level) ? @tags = Tag.where(company_id: current_user.company_id) : @tags = current_user.tags
    @users = User.where(company_id: current_user.company_id)
  end

  def view_mode
    authorize @training_workshop
    @workshop = Workshop.find(@training_workshop.workshop_id)
  end

  def update
    @training_workshop = TrainingWorkshop.find(params[:id])
    authorize @training_workshop
    @training_workshop.update(training_workshop_params)
    redirect_back(fallback_location: root_path) if @training_workshop.save
  end

  def copy
    @training_workshop = TrainingWorkshop.find(params[:id])
    authorize @training_workshop
    new_training_workshop = TrainingWorkshop.new(@training_workshop.attributes.except("id", "created_at", "updated_at"))
    new_training_workshop.title = params[:copy][:title]
    new_training_workshop.date = params[:copy][:date]
    redirect_to training_path(@training_workshop.tpararaining) if new_training_workshop.save
  end

  def update_book
    authorize @training_workshop
    if params[:commit] == 'Clear'
      redirect_to url_for(clear: true)
    elsif params[:commit] == 'Update'
      params.permit!
      participants = params[:participant][:user_ids].reject{|x| x.empty?}.map{|c| c.to_i}
      # @training_workshop.update(date: Date.strptime(params[:filter][:date], '%d/%m/%Y'), starts_at: DateTime.strptime(params[:filter]['starts_at(1i)']+'-'+params[:filter]['starts_at(2i)']+'-'+params[:filter]['starts_at(3i)']+'-'+params[:filter]['starts_at(4i)']+'-'+params[:filter]['starts_at(5i)'], '%Y-%m-%d-%H-%M'), ends_at: DateTime.strptime(params[:filter]['ends_at(1i)']+'-'+params[:filter]['ends_at(2i)']+'-'+params[:filter]['ends_at(3i)']+'-'+params[:filter]['ends_at(4i)']+'-'+params[:filter]['ends_at(5i)'], '%Y-%m-%d-%H-%M'))
      @training_workshop.update(training_workshop_params)
      if @training_workshop.save
        Attendee.where(training_workshop_id: @training_workshop.id).where.not(user_id: participants).map{|x| x.destroy}
        participants.each do |participant|
          Attendee.create(training_workshop_id: @training_workshop.id, user_id: participant)
        end
        redirect_to training_workshop_path(@training_workshop)
      end
    end
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
    elsif params[:clear].present?
      @users = User.where(company_id: current_user.company_id).order(lastname: :asc)
    else
      @users = (User.joins(:attendees).where(attendees: {training_workshop_id: @training_workshop.id}).order(lastname: :asc) + User.where(company_id: current_user.company_id).order(lastname: :asc)).uniq
    end
  end

  def destroy
    authorize @training_workshop
    @training_workshop.destroy
    redirect_to dashboard_path
  end

  private

  def set_training_workshop
    @training_workshop = TrainingWorkshop.find(params[:id])
  end

  def training_workshop_params
    params.require(:filter).permit(:title, :duration, :participant_number, :description, :content, :image, :date, :available_date, :starts_at, :ends_at, :date1, :starts_at1, :ends_at1, :date2, :starts_at2, :ends_at2, :date3, :starts_at3, :ends_at3, :date4, :starts_at4, :ends_at4)
  end
end
