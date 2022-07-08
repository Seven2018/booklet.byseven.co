namespace :workplace do
  desc 'Add missing pictures with Big Mamma Workplace'
  task add_missing_pictures: :environment do
    Workplace::MissingPicturesAddWorker.perform_async({})
  end
end
