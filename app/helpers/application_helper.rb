module ApplicationHelper
  def page
    params[:page] || 1
  end

  def decimal_eur(number)
    has_decimal = number % 1 != 0
    has_decimal ? "#{'%.2f' % number} €" : "#{number.to_i} €"
  end

  def seconds_to_hms(sec)
    sec = sec.to_i
    # "%02d:%02d:%02d" % [sec / 3600, sec / 60 % 60, sec % 60]
    "%2dh%02d" % [sec / 3600, sec / 60 % 60, sec % 60]
  end
end
