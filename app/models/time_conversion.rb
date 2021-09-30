module TimeConversion
  def self.convert(minutes)
    hours = minutes / 60
    rest = minutes % 60
    return "#{hours}h#{rest unless rest == 0}"
  end
end