task :interviews_send_reminders => :environment do

  reminder_days = [7,3,0].map{|num| Date.today + num.days}

  Interview.where(date: reminder_days).each do |interview|

    interviewee = interview.employee
    interviewer = interview.interviewer
    time_remaining = (interview.date - Date.today).to_i

    CampaignMailer.with(user: interviewee)
        .interview_reminder_time(interviewer, interviewee, interview, time_remaining)
        .deliver_later

  end

end
