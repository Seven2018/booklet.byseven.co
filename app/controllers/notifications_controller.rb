class NotificationsController < ApplicationController
  def mark_as_read
    @notification = Notification.find(params[:notification_id])
    authorize @notification
    @notification.update(status: 'Read')
    notifications = Notification.where(user_id: current_user.id)
    Notification.delete(notifications.first(notifications.count - 5)) if notifications.count > 5
    respond_to do |format|
      format.html {redirect_back(fallback_location: root_path)}
      # format.js { render :partial => 'shared/notifications'}
    end
  end
end
