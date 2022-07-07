namespace :au_secours do
  task sos: :environment do
    campaigns = Campaign.where(company_id: 2).where('created_at >= ?', Date.today.beginning_of_day)

    campaigns.each do |campaign|

      campaign.interview_forms.each{|x| x.update cross: true}

      campaign.interview_sets.each do |set|
        if set.interviews.count < 3
          cross = set.interviews.last.deep_dup
          cross.label = 'Crossed'
          cross.status = 'not_available_yet'
          cross.save
        end
      end
    end
  end
end
