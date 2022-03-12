module ApplicationHelper
  def page
    params[:page] || 1
  end

  def decimal_eur(number)
    "#{'%.2f' % number} €"
  end

  def seconds_to_hms(sec)
    sec = sec.to_i
    # "%02d:%02d:%02d" % [sec / 3600, sec / 60 % 60, sec % 60]
    "%2dh%02d" % [sec / 3600, sec / 60 % 60, sec % 60]
  end
end
