desc <<-_EOS_
Extension of redmine:send_reminders

Available extra options:
  * ratio_gt  => max done ratio (excludes value)
  * ratio_gte => max done ratio (includes value)
  * ratio_lt  => min done ratio (excludes value)
  * ratio_lte => min done ratio (includes value)

Default options:
  See also redmine/lib/tasks/reminder.rake
_EOS_

namespace :redmine do
  task :send_reminderz => :environment do
    options = {}

    # default options
    options[:days] = ENV['days'].to_i if ENV['days']
    options[:project] = ENV['project'] if ENV['project']
    options[:tracker] = ENV['tracker'].to_i if ENV['tracker']
    options[:users] = (ENV['users'] || '').split(',').each(&:strip!)

    # extra options
    options[:ratio_gt]  = ENV['ratio_gt'].to_i  if ENV['ratio_gt']
    options[:ratio_gte] = ENV['ratio_gte'].to_i if ENV['ratio_gte']
    options[:ratio_lt]  = ENV['ratio_lt'].to_i  if ENV['ratio_lt']
    options[:ratio_lte] = ENV['ratio_lte'].to_i if ENV['ratio_lte']

    Mailer.with_synched_deliveries do
      Mailer.reminders(options)
    end
  end
end
