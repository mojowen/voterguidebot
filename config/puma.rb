workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['RAILS_MAX_THREADS'] || 5)
threads threads_count, threads_count

preload_app!

rackup      DefaultRackup
port        ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || 'development'

on_worker_boot do
  ActiveRecord::Base.establish_connection
end

require 'barnes'

before_fork do
  require 'puma_worker_killer'

  Barnes.start

  PumaWorkerKiller.ram = 512

  PumaWorkerKiller.enable_rolling_restart(6 * 3600)
end
