class Objective::UserPolicy < ApplicationPolicy

  def show?
    user == record || user = record.manager || user.hr_or_above?
  end

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
