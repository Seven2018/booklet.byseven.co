class Hash
  def to_o
    JSON.parse to_json, object_class: OpenStruct
  end

  def trues
    select { |_, v| v }.keys
  end
  alias cans trues

  def falses
    select { |_, v| !v }.keys
  end
  alias cants falses

  def to_string
    result = ''
    self.each do |k,v|
      result += "#{k}:#{v}," if v.present?
    end

    return result[0...-1]
  end

  def stringify_keys
    h = self.map do |k,v|
      v_str = if v.instance_of? Hash
                v.stringify_keys
              else
                v
              end

      [k.to_s, v_str]
    end
    Hash[h]
  end

  def symbol_keys
    h = self.map do |k,v|
      v_sym = if v.instance_of? Hash
                v.symbol_keys
              else
                v
              end

      [k.to_sym, v_sym]
    end
    Hash[h]
  end

  def compact(opts={})
    inject({}) do |new_hash, (k,v)|
      if v.present?
        new_hash[k] = opts[:recurse] && v.class == Hash ? v.compact(opts) : v
      end
      new_hash
    end
  end

end
