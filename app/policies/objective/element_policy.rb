class Objective::ElementPolicy < ApplicationPolicy

  def create?
    true
  end

  def show?
    #TODO Better definition of this policy
    user == record.employee || record.manager
  end

  def my_objectives?
    true
  end

  def my_team_objectives?
    user.access_level_int.to_sym != :employee
  end
end
