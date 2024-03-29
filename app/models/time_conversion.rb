module TimeConversion
  def self.convert(minutes)
    hours = minutes / 60
    rest = minutes % 60
    return "#{hours}h#{format('%02d', rest)}"
  end
end
