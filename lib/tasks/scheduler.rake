task :interviews_send_reminders => :environment do
  Interview.send_reminders
end
