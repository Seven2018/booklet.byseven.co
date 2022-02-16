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

  def processing?
    enqueued? || started?
  end

  def filename(extension = nil)
    [
      "Campaign Export (#{mode.capitalize}) - ",
      company.name,
      " - ",
      start_time.strftime('%F'),
      " to ",
      end_time.strftime('%F'),
      extension
    ].join
  end

  def to_xlsx
    p = Axlsx::Package.new
    p.workbook.add_worksheet(name: sheetname) do |sheet|
      data.each { |csv_row| sheet.add_row csv_row }
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
