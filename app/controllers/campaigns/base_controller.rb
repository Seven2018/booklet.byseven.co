class Campaigns::BaseController < ApplicationController
  private

  def campaign
    @campaign ||= Campaign.find params[:id]
  end
end
