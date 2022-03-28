module Companies::AssetsMeta

  def clear_bg_logo_meta(size)
    case size
    when :desktop then AssetMeta.new(width: 150, height: 30)
    when :mobile  then AssetMeta.new(width: 150, height: 30)
    else
      raise AssetMetableFormatError, "#{self.class} => #{id}"
    end
  end

  def dark_bg_logo_meta(size)
    case size
    when :desktop then AssetMeta.new(width: 150, height: 30)
    when :mobile  then AssetMeta.new(width: 150, height: 30)
    else
      raise AssetMetableFormatError, "#{self.class} => #{id}"
    end
  end

  def my_interviews_bg_picture_meta(size)
    case size
    when :desktop then AssetMeta.new(width: 600, height: 300)
    when :mobile  then AssetMeta.new(width: 200, height: 100)
    else
      raise AssetMetableFormatError, "#{self.class} => #{id}"
    end
  end

  def my_team_interviews_bg_picture_meta(size)
    case size
    when :desktop then AssetMeta.new(width: 600, height: 300)
    when :mobile  then AssetMeta.new(width: 200, height: 100)
    else
      raise AssetMetableFormatError, "#{self.class} => #{id}"
    end
  end

  def my_trainings_bg_picture_meta(size)
    case size
    when :desktop then AssetMeta.new(width: 600, height: 300)
    when :mobile  then AssetMeta.new(width: 200, height: 100)
    else
      raise AssetMetableFormatError, "#{self.class} => #{id}"
    end
  end

  def my_team_trainings_bg_picture_meta(size)
    case size
    when :desktop then AssetMeta.new(width: 600, height: 300)
    when :mobile  then AssetMeta.new(width: 200, height: 100)
    else
      raise AssetMetableFormatError, "#{self.class} => #{id}"
    end
  end
end
