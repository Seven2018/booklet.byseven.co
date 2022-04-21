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
end
