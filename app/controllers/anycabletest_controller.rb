class AnycabletestController < ApplicationController
  skip_after_action :verify_policy_scoped
  def index
    #ActionCable.server.broadcast('welcome_channel', Time.now)
  end
end
