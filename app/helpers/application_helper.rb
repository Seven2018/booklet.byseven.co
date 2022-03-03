module ApplicationHelper

  def page
    params[:page] || 1
  end
end
