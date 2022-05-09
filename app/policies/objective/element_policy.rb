class Objective::ElementPolicy < ApplicationPolicy

  def my_objectives?
    true
  end

  def my_team_objectives?
    user.access_level_int.to_sym != :employee
  end

  def create?
    true
  end

  # def list?
  #   true
  # end
end
