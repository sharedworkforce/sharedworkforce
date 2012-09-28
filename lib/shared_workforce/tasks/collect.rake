desc "Collects completed responses"
namespace :shared_workforce do
  task :collect => :environment do
    $stdout.sync = true
    puts "=> Please note: expect a delay of about 30 seconds after a task is completed before seeing a response."
    puts "=> This gives the worker a chance to change their answer."
    puts "=> Connecting to Shared Workforce..."
    SharedWorkforce::ResponseCollector.start
  end
end

namespace :sw do
  desc "Alias of shared_workforce:collect"
  task :collect => "shared_workforce:collect"
end

namespace :sharedworkforce do
  task :collect => "shared_workforce:collect"
end