namespace :guides do
  desc "Archives guides six months after their election date"
  task :archive => [:environment] do
    Guide.where('active = true AND election_date < ?', 6.months.ago)
         .update_all(active: false)
  end
end
