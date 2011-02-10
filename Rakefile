require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'

task :default => 'spec:unit'

namespace :spec do
  desc "Run unit specs"
  RSpec::Core::RakeTask.new('unit') do |t|
    t.pattern = 'spec/**/*_spec.rb'
  end
end