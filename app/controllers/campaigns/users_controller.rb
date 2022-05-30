class Campaigns::UsersController < Campaigns::BaseController

  def index
    @users = current_user.company.users
                         .ransack(firstname_or_lastname_cont: params[:search])
                         .result(distinct: true)
    @users =  (@users - campaign.employees).first(5)

    respond_to do |format|
      format.json {
        @users
      }
    end
  end
end
