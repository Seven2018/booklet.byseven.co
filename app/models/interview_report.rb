class InterviewReport < ApplicationRecord
  belongs_to :company
  belongs_to :tag_category
  belongs_to :creator, class_name: "User", optional: true

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
  validates :start_time, :end_time, presence: true

  scope :processing, -> { where('state IN (?)', [ states[:enqueued], states[:started] ]) }

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

  def to_csv
    CSV.generate("\uFEFF") { |csv| data.split("\n").each { |row| csv << row.split(',') } }
  end

  def to_xlsx
    p = Axlsx::Package.new
    p.workbook.add_worksheet(name: sheetname) do |sheet|
      data.split("\n").each { |csv_row| sheet.add_row csv_row.split(',') }
    end
    temp_file = Tempfile.new([filename, '.xlsx'], Rails.root.join('tmp'), encoding: 'utf-8')
    p.serialize temp_file.path
    temp_file
  end

  private

  def sheetname
    [
      mode.capitalize,
      start_time.strftime('%F'),
      end_time.strftime('%F')
    ].join('_')
  end

  def no_duplicate_processing?
    errors.add(:base, message: 'An identical csv export is currently processing !') if
      InterviewReport.where.not(id: id)
               .where(signature: signature)
               .processing
               .exists?
  end

  def signature
    [
      company_id,
      tag_category_id,
      start_time,
      end_time,
      self.class.modes[mode]
    ].map(&:to_i).sort.join
  end

  def set_signature
    self.signature = signature
  end
end
