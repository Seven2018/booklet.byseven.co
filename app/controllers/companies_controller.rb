class CompaniesController < ApplicationController
  before_action :set_company, only: [:show, :edit, :update, :destroy]

  # Index with "search" option
  def index
    params[:search] ? @companies = policy_scope(Company).where("lower(name) LIKE ?", "%#{params[:search][:name].downcase}%").order(name: :asc) : @companies = policy_scope(Company).order(name: :asc)
  end

  def show
    authorize @company
  end

  def new
    @company = Company.new
    authorize @company
  end

  def create
    @company = Company.new(company_params)
    authorize @company
    @company.save ? (redirect_to company_path(@company)) : (render :new)
  end

  def edit
    authorize @company
  end

  def update
    authorize @company
    @company.update(company_params)
    @company.save ? (redirect_to company_path(@company)) : (render "_edit")
  end

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
    params.require(:company).permit(:name, :address, :zipcode, :city, :description, :logo, :company_type)
  end
end
