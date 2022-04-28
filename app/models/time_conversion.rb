module TimeConversion
  def self.convert(minutes)
    hours = minutes / 60
    rest = minutes % 60
    return "#{hours}h#{format('%02d', rest)}"
  end

  def self.gen_time_duration_args(minutes)
    minutes_for_obj = minutes * 60
    ActiveSupport::Duration.build(minutes_for_obj).parts.reverse_merge(hours: 0, minutes: 0)
  end
end
