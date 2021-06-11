class AttendeesController < ApplicationController
  before_action :set_attendee, only: [:update, :destroy]

  def create
    @attendee = Attendee.new(training_content_id: params[:training_content_id], user_id: params[:user_id], status: 'Confirmed', creator_id: current_user.id)
    authorize @attendee
    if @attendee.save
      redirect_to redirect_path(list: "#{params[:user_id]} ", training_content_id: "|#{params[:training_content_id]}|", to_delete: " ")
    else
      raise
    end
  end

  def update
    authorize @attendee
    @attendee.update(status: params[:status])
    redirect_back(fallback_location: root_path) if @attendee.save
  end

  def destroy
    authorize @attendee
    @attendee.destroy
    event_to_delete = @attendee.user_id.to_s+':'+@attendee.calendar_uuid+',' if @attendee.calendar_uuid.present?
    redirect_to redirect_path(list: "#{@attendee.user_id} ", training_content_id: "|#{@attendee.training_content.id}|", to_delete: "#{event_to_delete} ")
  end

  def invite_user_to_content
    training_content = Session.find(params[:training_content_id])
    @attendees = Attendee.where(training_content_id: training_content.id)
    authorize @attendees
    user_ids = params[:training_content][:user_ids].drop(1).map(&:to_i)
    users = User.where(id: [user_ids])
    set_current_user
    event_to_delete = ''
    users.each do |user|
      # new_attendee = Attendee.create(training_content_id: training_content.id, user_id: user.id, status: 'Invited')
      new_attendee = Attendee.new(training_content_id: training_content.id, user_id: user.id, status: params[:status], creator_id: current_user.id)
      if !new_attendee.save && params[:invite][:transform] == 'true'
        Attendee.find_by(training_content_id: training_content.id, user_id: user.id).update(status: 'Registered')
      elsif new_attendee.save
        Notification.create(content: "You have been invited to the following content: #{training_content.title}", user_id: user.id)
        # UserMailer.with(attendee_id: new_attendee.id).invite_email(user, new_attendee).deliver
      end
    end
    (User.joins(:attendees).where(attendees: {training_content_id: training_content.id}) - users).each do |user|
      attendee = Attendee.find_by(user_id: user.id, training_content_id: training_content.id)
      event_to_delete+=user.id.to_s+':'+attendee.calendar_uuid+',' if attendee.calendar_uuid.present?
      attendee.destroy
      Notification.create(content: "Invitation cancelled: #{training_content.title}", user_id: user.id)
    end
    # Lists all pre-existing SessionTrainers, to be deleted
    event_to_delete = event_to_delete[0...-1]
    redirect_to redirect_path(list: "#{user_ids.join(',')}", training_content_id: "|#{training_content.id}|", to_delete: "#{event_to_delete}")
  end

  def mark_as_completed
    @attendees = Attendee.where(training_content_id: params[:training_content_id])
    authorize @attendees
    user_ids = params[:training_content][:user_ids].drop(1).map(&:to_i)
    @attendees.each do |attendee|
      attendee.mark_as_completed if user_ids.include?(attendee.user_id)
    end
    redirect_back(fallback_location: root_path)
  end

  def confirm_training_content
    training_content = Session.find(params[:training_content_id])
    @attendee = Attendee.where(training_content_id: training_content.id, user_id: current_user.id).first
    authorize @attendee
    @attendee.update(status: 'Completed')
    redirect_back(fallback_location: root_path)
  end

  def redirect
    skip_authorization
    client = Signet::OAuth2::Client.new(client_options)
    # Allows to pass informations through the Google Auth as a complex string
    client.update!(state: Base64.encode64(params[:list]+params[:training_content_id]+params[:to_delete]))
    redirect_to client.authorization_uri.to_s
  end

  def callback
    client = Signet::OAuth2::Client.new(client_options)
    client.code = params[:code]
    response = client.fetch_access_token!
    session[:authorization] = response
    redirect_to "#{create_url}/?code=#{params[:code]}"
  end

  def calendars
    # Gets clearance from OAuth
    client = Signet::OAuth2::Client.new(client_options)
    skip_authorization
    client.code = params[:code]
    client.update!(client.fetch_access_token!)
    # Initiliaze GoogleCalendar
    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = client
    # Lists the users for whom an event will be created
    list = Base64.decode64(params[:state]).split('|').first.split(',')
    # Calendars ids
    calendars_ids = []
    list.each do |ind|
      calendars_ids << User.find(ind).email
    end
    # Get the targeted contents
    content_array = Base64.decode64(params[:state]).split('|')[1]
    if content_array.length == 1
      contents_ids = content_array.split(',')
    else
      contents_ids = content_array[1..-2].split(', ')
    end

    # Lists the users and the events ids of the events to be deleted
    to_delete_string = Base64.decode64(params[:state]).split('|').last
    if to_delete_string.split(',').count > 1
      to_delete_array = []
      to_delete_string.split(',').each do |pair|
        unless pair.empty?
          value = pair.split(':')
          to_delete_array << value
        end
      end
      # Deletes the events
      to_delete_array.each do |value|
        begin
          service.delete_event(User.find(value[0].to_i).email, value[1]) if value.present?
        rescue
        end
      end
    else
      to_delete_hash = {}
      to_delete_string.split(',').each do |pair|
        unless pair.empty?
          key = pair.split(':')[0]
          value = pair.split(':')[1]
          to_delete_hash[key] = value
        end
      end
      # Deletes the events
      to_delete_hash.each do |key, value|
        begin
          service.delete_event(User.find(key.to_i).email, value) if value.present?
        rescue
        end
      end
    end

    begin
      # Creates the events into calendars
      contents_ids.each do |index|
        content = Session.find(index.to_i)
        day = content.date.strftime('%Y-%m-%d')
        event = Google::Apis::CalendarV3::Event.new({
          start: {
            date_time: day+'T'+content.starts_at.strftime('%H:%M:%S'),
            time_zone: 'Europe/Paris',
          },
          end: {
            date_time: day+'T'+content.ends_at.strftime('%H:%M:%S'),
            time_zone: 'Europe/Paris',
          },
          summary: "Formation - " + content.title
        })
        # Creates the event in all the targeted calendars
        list.each do |ind|
          create_calendar_id(ind, content.id, event, service, calendars_ids)
        end
      end
    rescue
    end
    contents_ids.count == 1 ? (redirect_to training_content_path(Session.find(contents_ids[0].to_i))) : (redirect_to training_path(Training.joins(:training_contents).find_by(training_contents: {id: contents_ids})))
  end

  private

  def set_attendee
    @attendee = Attendee.find(params[:id])
  end

  def set_current_user
    Current.user = current_user
  end

  def client_options
    {
      client_id: Rails.application.credentials.google_client_id,
      client_secret: Rails.application.credentials.google_client_secret,
      authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
      token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
      scope: Google::Apis::CalendarV3::AUTH_CALENDAR,
      redirect_uri: "#{request.base_url}/calendars"
    }
  end

  def create_calendar_id(user_id, training_content_id, event, service, array)
    event.id = SecureRandom.hex(32)
    attendee = Attendee.where(user_id: user_id, training_content_id: training_content_id).first
    unless attendee.calendar_uuid.present?
      attendee.update(calendar_uuid: event.id)
      service.insert_event(array[user_id.to_i - 1], event)
    end
  end
end
