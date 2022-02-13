class CsvExport < ApplicationRecord
  belongs_to :company

  enum state: {
    enqueued: 0,
    started: 10,
    done: 20,
    failed: 30
  }

  enum mode: {
    classic: 0,
    data: 10
  }, _suffix: true

  before_save :set_signature
  validate :no_duplicate_processing?
  validates :category, :start_time, :end_time, presence: true

  scope :processing, -> { where('state IN (?)', [ states[:enqueued], states[:started] ]) }

  def no_duplicate_processing?
    errors.add(:base, message: 'An identical csv export is currently processing !') if
      CsvExport.where.not(id: id)
               .where(signature: signature)
               .processing
               .exists?
  end

  def filename
    if classic_mode?
      "Campaign Export (Analytics) - #{current_user.company.name} - #{params.dig(:select_period_temp, :start)} to #{params.dig(:select_period_temp, :end)}.csv"
    end
  end

  private

  def signature
    [
      company_id,
      category,
      start_time,
      end_time,
      self.class.modes[mode]
    ].map(&:to_i).sort.join
  end

  def set_signature
    self.signature = signature
  end
end
