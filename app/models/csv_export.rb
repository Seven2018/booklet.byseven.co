class CsvExport < ApplicationRecord
  class UnknownMode < StandardError; end
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

  def filename
    tail = "#{company.name} - #{start_time.strftime('%F')} to #{end_time.strftime('%F')}.csv"
    case mode.to_sym
    when :classic then "Campaign Export (Analytics) - #{tail}"
    when :data    then "Campaign Export (Data) - #{tail}"
    else
      raise UnknownMode
    end
  end

  private

  def no_duplicate_processing?
    errors.add(:base, message: 'An identical csv export is currently processing !') if
      CsvExport.where.not(id: id)
               .where(signature: signature)
               .processing
               .exists?
  end

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
