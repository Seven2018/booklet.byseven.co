class Objective::UserPolicy < ApplicationPolicy

  def info?
    true
  end

  def list_current?
    true
  end

  def my_team_objectives?
    user.access_level_int.to_sym != :employee
  end
end
