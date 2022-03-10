class Campaigns::UsersController < Campaigns::BaseController

  def index
    @users = current_user.company.users
                         .ransack(firstname_or_lastname_cont: params[:search])
                         .result(distinct: true)
    @users =  (@users - campaign.employees).first(5)
    render json: { users: users }
  end

  private

  def users
    @users.map do |user|
      {
        name: user.fullname,
        # url: user_path(user), #unused in this context
        id: user.id
      }
    end
  end
end
