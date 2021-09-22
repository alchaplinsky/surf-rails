class SubmissionPolicy < ApplicationPolicy

  def update?
    is_owner?
  end

  def destroy?
    is_owner?
  end

end
