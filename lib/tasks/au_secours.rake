namespace :au_secours do
  task sos: :environment do
    campaigns = Campaign.where(company_id: 2).where('created_at >= ?', Date.today.beginning_of_week)

    Campaign.where(company_id: 2).where('created_at >= ?', Date.today.beginning_of_week).each do |campaign|

      campaign.interview_forms.each{|x| x.update(answerable_by: 'both', cross: true)}

      campaign.interview_sets.each do |set|
        if set.interviews.select{|x| x&.label == 'Crossed'}.empty?
          cross = Interview.find(set.interviews.find{|x| x.present?}.id).dup
          cross.label = 'Crossed'
          cross.status = 'not_available_yet'
          unless cross.save
            print cross.valid?
            print cross.errors
            binding.pry
          end
        end

        if set.interviews.select{|x| x&.label == 'Employee'}.empty?
          emp = Interview.find(set.interviews.find{|x| x.present?}.id).dup
          emp.label = 'Employee'
          emp.status = 'not_started'
          unless emp.save
            print emp.valid?
            print emp.errors
            binding.pry
          end
        end

        if set.interviews.select{|x| x&.label == 'Manager'}.empty?
          mana = Interview.find(set.interviews.find{|x| x.present?}.id).dup
          mana.label = 'Manager'
          mana.status = 'not_started'
          unless mana.save
            print mana.valid?
            print mana.errors
            binding.pry
          end
        end
      end
    end
  end
end
