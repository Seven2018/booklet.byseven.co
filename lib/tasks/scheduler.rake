##########
# EMAILS #
##########

task :interviews_send_reminders => :environment do

  reminder_days = [7,3,0].map{|num| Time.zone.today + num.days}

  Interview.where.not(status: :submitted).where(date: reminder_days).each do |interview|

    interviewee = interview.employee
    interviewer = interview.interviewer
    time_remaining = (interview.date - Time.zone.today).to_i

    CampaignMailer.with(user: interviewee)
        .interview_reminder_time(interviewer, interviewee, interview, time_remaining)
        .deliver_later

  end

end

task :sessions_send_reminders => :environment do

  reminder_days = [7,3,0].map{|num| Time.zone.today + num.days}

  Session.where(date: reminder_days).each do |session|

    time_remaining = (session.date - Time.zone.today).to_i

    session.attendees.map(&:user).each do |user|

      TrainingMailer.with(user: user)
        .session_reminder(user, session, time_remaining)
        .deliver_now

    end

  end

end


###################
# CAMPAIGN DRAFTS #
###################

namespace :campaign_drafts do
  task :clean_campaign_drafts => :environment do
    CampaignDraft.where('created_at < ?', 7.days.ago.beginning_of_day).destroy_all
  end
end
