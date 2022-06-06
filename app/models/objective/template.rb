
class Objective::Template < Objective::Element
  default_scope { rewhere(template: true ) }

  def self.create(**args)
    super(**args.merge({template: true}))
  end
end