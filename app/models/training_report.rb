class TrainingReport < ApplicationRecord
  include ActiveModel::Dirty

  belongs_to :company
  belongs_to :creator, class_name: "User", optional: true

  validates :start_time, :end_time, presence: true
  validate :updateable

  # TODO refacto > model Report from which both TrainingReport and InterviewReport would inherit
  enum state: {
    enqueued: 0,
    started: 10,
    done: 20,
    failed: 30
  }

  enum mode: {
    by_employee: 0,
    by_training: 10
  }, _suffix: true

  before_save :set_signature
  validate :no_duplicate_processing?
  validates :start_time, :end_time, presence: true

  scope :at_least_started, -> { where(state: [:started, :done, :failed]) }
  scope :processing, -> { where.not(state: [:done, :failed]) }

  jsonb_accessor :data,
                 participant_ids: [:string, array: true, default: []],
                 training_ids: [:string, array: true, default: []],
                 computed_participant_ids: [:string, array: true, default: []],
                 computed_training_ids: [:string, array: true, default: []],
                 computed_done_training_ids: [:string, array: true, default: []],
                 computed_total_duration_in_secs: :string,
                 computed_total_cost_cents: :string,
                 computed_done_training_users_count: :string,
                 computed_all_training_users_count: :string,
                 computed_training_lines_by_employee: [:string, array: true,
                  default: [
                    # ex:
                    # ["training_name", "Comment faire un bon mojito ?"],
                    # ["employees", 17],
                    # ["trainings_done", "3/17"]
                    # ["duration_in_secs", 150]
                    # ["cost_per_employee_in_cents", 15000]
                   ]
                 ],
                 computed_training_lines_by_training: [:string, array: true,
                  default: [
                    # ex:
                    # ["training_name", "Comment faire un bon mojito ?"],
                    # ["employees", 17],
                    # ["trained_employees", "3/17"]
                    # ["duration_in_secs", 150]
                    # ["cost_per_employee_in_cents", 15000]
                   ]
                 ]

                 # trainings_count: :string,
                 # results: [:string, array: true, default: []]

  def participants
    participant_ids.blank? ? User.none : User.where(id: participant_ids)
  end

  def trainings
    training_ids.blank? ? Training.none : Training.where(id: training_ids)
  end

  def trainings_done
    "#{computed_done_training_ids.count}/#{computed_training_ids.count}"
  end

  def trained_employees
    "#{computed_done_training_users_count.count}/#{computed_all_training_users_count.count}"
  end

  def cost_per_employee_cents
    computed_total_cost_cents.to_f / computed_participant_ids.count
  end

  def processing?
    enqueued? || started?
  end

  def filename(extension = nil)
    [
      "Campaign Report (#{mode.capitalize}) - ",
      company.name,
      " - ",
      start_time.strftime('%F'),
      " to ",
      end_time.strftime('%F'),
      extension
    ].join
  end

  def computed_training_lines_by_employee_objects
    computed_training_lines_by_employee.map{ |line| line.to_h.to_o }
  end

  def computed_training_lines_by_training_objects
    computed_training_lines_by_training.map{ |line| line.to_h.to_o }
  end


  def to_csv
    CSV.generate("\uFEFF") { |csv| tabular_data.each { |line| csv << line } }
  end

  def to_xlsx
    p = Axlsx::Package.new
    p.workbook.add_worksheet(name: sheetname) do |sheet|
      tabular_data.each { |line| sheet.add_row line }
    end
    temp_file = Tempfile.new([filename, '.xlsx'], Rails.root.join('tmp'), encoding: 'utf-8')
    p.serialize temp_file.path
    temp_file
  end

  private

  def h
    ApplicationController.helpers
  end

  def tabular_data
    a = []
    a << ['Training Report']
    a << ['Created at', updated_at.strftime('%d/%m/%Y')]
    a << ['Created by', "#{creator.fullname}-#{creator.email}"]
    a << ['From', start_time.strftime('%d/%m/%Y')]
    a << ['To', end_time.strftime('%d/%m/%Y')]
    a << ['Type', mode]
    a << []

    if by_employee_mode?
      a << ['Trainings', computed_training_ids.count]
      a << ['Employees', computed_participant_ids.count]
      a << ['Trainings Done', trainings_done]
      a << ['Total duration', h.seconds_to_hms(computed_total_duration_in_secs)]
      a << ['Total cost', h.decimal_eur(computed_total_cost_cents.to_f / 100)]
      a << []
      a << ["Training name", "Employees", "Trainings done", "Duration", "Cost per employee"]
      computed_training_lines_by_employee_objects.each do |line|
        a << [
          line.training_name,
          line.employees,
          line.trainings_done,
          h.seconds_to_hms(line.duration_in_secs),
          h.decimal_eur(line.cost_per_employee_in_cents.to_f / 100)
        ]
      end
    end

    if by_training_mode?
      a << ['Trained employees', trainings_done]
      a << ['Trainings', computed_training_ids.count]
      a << ['Total duration', h.seconds_to_hms(computed_total_duration_in_secs)]
      a << ['Cost per employee', h.decimal_eur(cost_per_employee_cents.to_f / 100)]
      a << ['Total cost', h.decimal_eur(computed_total_cost_cents.to_f / 100)]
      a << []
      a << ["Training name", "Employees", "Trained employees", "Duration", "Cost per employee"]
      computed_training_lines_by_training_objects.each do |line|
        a << [
          line.training_name,
          line.employees,
          line.trained_employees,
          h.seconds_to_hms(line.duration_in_secs),
          h.decimal_eur(line.cost_per_employee_in_cents.to_f / 100)
        ]
      end
    end

    a
  end

  def updateable
    errors.add(:base, 'report is locked once data is generated') if state_was == 'done'
  end

  def sheetname
    "training_report_#{id}"
  end

  def no_duplicate_processing?
    errors.add(:base, 'An identical csv export is currently processing !') if
      InterviewReport.where.not(id: id)
               .where(signature: signature)
               .processing
               .exists?
  end

  def signature
    [
      company_id,
      start_time,
      end_time,
      self.class.modes[mode]
    ].map(&:to_i).sort.join
  end

  def set_signature
    self.signature = signature
  end

end
