class AttendeesController < ApplicationController
  before_action :set_attendee, only: [:destroy]

  def create
    @attendee = Attendee.new(training_workshop_id: params[:training_workshop_id], user_id: params[:user_id], status: 'Confirmed')
    authorize @attendee
    if @attendee.save
      redirect_to redirect_path(list: "#{params[:user_id]} ", training_workshop_id: "|#{params[:training_workshop_id]}|", to_delete: " ")
    else
      raise
    end
  end

  def create_all
    training = Training.find(params[:training_id])
    @attendees = Attendee.where(training_workshop_id: [training.training_workshops.ids], user_id: params[:user_id])
    authorize @attendees
    unless training.training_workshops.nil?
      training.training_workshops.each do |workshop|
        Attendee.create(training_workshop_id: workshop.id, user_id: params[:user_id], status: 'Confirmed')
      end
    end
    redirect_to redirect_path(list: "#{params[:user_id]} ", training_workshop_id: "|#{training.training_workshops.ids}|", to_delete: " ")
  end

  def destroy
    authorize @attendee
    @attendee.destroy
    event_to_delete = @attendee.user_id.to_s+':'+@attendee.calendar_uuid+',' if @attendee.calendar_uuid.present?
    redirect_to redirect_path(list: "#{@attendee.user_id} ", training_workshop_id: "|#{@attendee.training_workshop.id}|", to_delete: "#{event_to_delete} ")
  end

  def destroy_all
    @attendees = Attendee.joins(:training_workshop).where(training_workshops: {training_id: params[:training_id]}, user_id: params[:user_id])
    authorize @attendees
    training = Training.find(params[:training_id])
    event_to_delete = ''
    @attendees.each do |attendee|
      event_to_delete+=attendee.user_id.to_s+':'+attendee.calendar_uuid+',' if attendee.calendar_uuid.present?
    end
    unless training.training_workshops.nil?
      training.training_workshops.each do |workshop|
        Attendee.find_by(user_id: params[:user_id], training_workshop_id: workshop.id).destroy
      end
    end
    redirect_to redirect_path(list: "#{params[:user_id]} ", training_workshop_id: "|#{training.training_workshops.ids}|", to_delete: "#{event_to_delete} ")
  end

  def invite_user_to_training
    training = Training.find(params[:training_id])
    @attendees = Attendee.where(training_workshop_id: [training.training_workshops.ids])
    authorize @attendees
    params.permit
    user_ids = params[:training][:user_ids].drop(1).map(&:to_i)
    users = User.where(id: [user_ids])
    users.each do |user|
      training.training_workshops.each do |training_workshop|
        # new_attendee = Attendee.create(training_workshop_id: training_workshop.id, user_id: user.id, status: 'Invited')
        new_attendee = Attendee.create(training_workshop_id: training_workshop.id, user_id: user.id, status: 'Confirmed')
        Notification.create(content: "You have been invited to the following training: #{training.title}", user_id: user.id)
        UserMailer.with(attendee_id: new_attendee.id).invite_email(user, new_attendee).deliver
      end
    end
    (User.joins(:attendees).where(attendees: {training_workshop_id: [training.training_workshops.ids]}).uniq - users).each do |user|
      Attendee.where(training_workshop_id: [training.training_workshops.ids], user_id: user.id).destroy_all
      Notification.create(content: "Invitation cancelled: #{training.title}", user_id: user.id)
    end
    redirect_back(fallback_location: root_path)
  end

  def invite_user_to_workshop
    training_workshop = TrainingWorkshop.find(params[:training_workshop_id])
    @attendees = Attendee.where(training_workshop_id: training_workshop.id)
    authorize @attendees
    user_ids = params[:training_workshop][:user_ids].drop(1).map(&:to_i)
    users = User.where(id: [user_ids])
    users.each do |user|
      # new_attendee = Attendee.create(training_workshop_id: training_workshop.id, user_id: user.id, status: 'Invited')
      new_attendee = Attendee.create(training_workshop_id: training_workshop.id, user_id: user.id, status: 'Confirmed')
      Notification.create(content: "You have been invited to the following workshop: #{training_workshop.title}", user_id: user.id)
      UserMailer.with(attendee_id: new_attendee.id).invite_email(user, new_attendee).deliver
    end
    (User.joins(:attendees).where(attendees: {training_workshop_id: training_workshop.id}) - users).each do |user|
      Attendee.find_by(user_id: user.id, training_workshop_id: training_workshop.id).destroy
      Notification.create(content: "Invitation cancelled: #{training_workshop.title}", user_id: user.id)
    end
    redirect_back(fallback_location: root_path)
  end

  def mark_as_completed
    @attendees = Attendee.where(training_workshop_id: params[:training_workshop_id])
    authorize @attendees
    user_ids = params[:training_workshop][:user_ids].drop(1).map(&:to_i)
    @attendees.each do |attendee|
      attendee.mark_as_completed if user_ids.include?(attendee.user_id)
    end
    redirect_back(fallback_location: root_path)
  end

  def confirm_training
    training = Training.find(params[:training_id])
    @attendees = Attendee.where(training_workshop_id: [training.training_workshops.ids], user_id: current_user.id)
    authorize @attendees
    @attendees.update_all(status: 'Confirmed')
    redirect_back(fallback_location: root_path)
  end

  def confirm_training_workshop
    training_workshop = TrainingWorkshop.find(params[:training_workshop_id])
    @attendee = Attendee.where(training_workshop_id: training_workshop.id, user_id: current_user.id).first
    authorize @attendee
    @attendee.update(status: 'Confirmed')
    redirect_back(fallback_location: root_path)
  end

  def redirect
    skip_authorization
    client = Signet::OAuth2::Client.new(client_options)
    # Allows to pass informations through the Google Auth as a complex string
    client.update!(state: Base64.encode64(params[:list]+','+params[:training_workshop_id]+','+params[:to_delete]))
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
    # Get the targeted workshops
    workshop_array = Base64.decode64(params[:state]).split('|')[1]
    if workshop_array.length == 1
      workshops_ids = workshop_array.split(',')
    else
      workshops_ids = workshop_array[1..-2].split(', ')
    end

    # Lists the users and the events ids of the events to be deleted
    to_delete_string = Base64.decode64(params[:state]).split('|').last
    if calendars_ids.count == 1
      to_delete_array = []
      to_delete_string.split(',').each do |pair|
        unless pair.empty?
          value = pair.split(':')[1]
          to_delete_array << value
        end
      end
      # Deletes the events
      to_delete_array.each do |value|
        begin
          service.delete_event(calendars_ids.first, value) if value.present?
        rescue
        end
      end
    else
      to_delete_hash = {}
      raise
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
          service.delete_event(calendars_ids[key.to_i - 1], value) if value.present?
        rescue
        end
      end
    end

    begin
      # Creates the events into calendars
      workshops_ids.each do |index|
        workshop = TrainingWorkshop.find(index.to_i)
        day = workshop.date.strftime('%Y-%m-%d')
        event = Google::Apis::CalendarV3::Event.new({
          start: {
            date_time: day+'T'+workshop.starts_at.strftime('%H:%M:%S'),
            time_zone: 'Europe/Paris',
          },
          end: {
            date_time: day+'T'+workshop.ends_at.strftime('%H:%M:%S'),
            time_zone: 'Europe/Paris',
          },
          summary: "Formation - " + workshop.title
        })
        # Creates the event in all the targeted calendars
        list.each do |ind|
          create_calendar_id(ind, workshop.id, event, service, calendars_ids)
        end
      end
    rescue
    end

    # # Calendars ids
    # calendars_ids = ['yahya.fallah@byseven.co', 'brice.chapuis@byseven.co', 'thomas.fraudet@byseven.co', 'jorick.roustan@byseven.co', 'mathilde.meurer@byseven.co', 'vum1670hi88jgei65u5uedb988@group.calendar.google.com', '', '', '', '', '', '', '', 'camille.briand@byseven.co']

    # # Lists the users and the events ids of the events to be deleted
    # to_delete_string = Base64.decode64(params[:state]).split('|').last.split('%').last
    # to_delete_hash = {}
    # to_delete_string.split(',').each do |pair|
    #   key = pair.split(':')[0]
    #   key
    #   value = pair.split(':')[1]
    #   to_delete_hash[key] = value
    # end
    # # Deletes the events
    # to_delete_hash.each do |key, value|
    #   begin
    #     if %w(1 2 3 4 5 14).include?(key)
    #       service.delete_event(calendars_ids[key.to_i - 1], value) if value.present?
    #     else
    #       service.delete_event(calendars_ids[5], value) if value.present?
    #     end
    #   rescue
    #   end
    # end

    # # Lists the users for whom an event will be created
    # list = Base64.decode64(params[:state]).split('|').first.split(',')
    # # Creates the event in all the targeted calendars
    # list.each do |ind|
    #   if %w(1 2 3 4 5 14).include?(ind)
    #     create_calendar_id(ind, session.id, event, service, calendars_ids)
    #   else
    #     sevener = User.find(ind)
    #     initials = sevener.firstname.first.upcase + sevener.lastname.first.upcase
    #     event.summary = session.training.client_company.name.upcase + " - " + session.training.title + " - " + initials
    #     event.id = SecureRandom.hex(32)
    #     session_trainer = SessionTrainer.where(user_id: sevener.id, session_id: session.id).first
    #     session_trainer.update(calendar_uuid: event.id)
    #     service.insert_event(calendars_ids[5], event)
    #   end
    # end

    redirect_to dashboard_path
  end

  private

  def set_attendee
    @attendee = Attendee.find(params[:id])
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

  def create_calendar_id(user_id, training_workshop_id, event, service, array)
    event.id = SecureRandom.hex(32)
    attendee = Attendee.where(user_id: user_id, training_workshop_id: training_workshop_id).first
    attendee.update(calendar_uuid: event.id)
    service.insert_event(array[user_id.to_i - 1], event)
  end
end
