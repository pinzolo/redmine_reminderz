Redmine::Plugin.register :redmine_reminderz do
  name 'Redmine Reminderz plugin'
  author 'pinzolo'
  description 'This is a plugin for Redmine that provides extra filters for reminders.'
  version '0.0.1'
  url 'https://github.com/pinzolo/redmine_reminderz'
  author_url 'https://github.com/pinzolo'
end

require_relative 'lib/reminderz'
