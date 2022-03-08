module ApplicationHelper
  def page
    params[:page] || 1
  end

  def decimal_eur(number)
    "#{'%.2f' % number} €"
  end
end
