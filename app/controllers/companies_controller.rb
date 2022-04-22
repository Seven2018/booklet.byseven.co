class CompaniesController < ApplicationController
  before_action :set_company, only: [:update, :destroy]

  # Form for registering a new company (pages/dashboard)
  def new
    @company = Company.new
    authorize @company
  end

  # Register a new company (pages/dashboard)
  def create
    @company = Company.new(company_params)
    authorize @company
    if @company.save
      if current_user.employee?
        current_user.update(access_level_int: :account_owner, company_id: @company.id)
      end
      redirect_to trainings_path
    else
      render :new
    end
  end

  # Update a company (not used)
  def update
    authorize @company
    @company.update(company_params)
    @company.save ? (redirect_to company_path(@company)) : (render "_edit")
  end


  # Delete a company (not used)
  def destroy
    @company.destroy
    authorize @company
    redirect_to companies_path
  end

  private

  def set_company
    @company = Company.find(params[:id])
  end

  def company_params
    params.require(:company).permit(:name, :siret, :address, :zipcode, :city, :logo)
  end
end
