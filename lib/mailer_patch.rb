module Reminderz::MailerPatch
  extend ActiveSupport::Concern

  module ClassMethods
    def reminderz(options={})
      days = options[:days] || 7
      project = options[:project] ? Project.find(options[:project]) : nil
      tracker = options[:tracker] ? Tracker.find(options[:tracker]) : nil
      user_ids = options[:users]

      scope = Issue.open.where("#{Issue.table_name}.assigned_to_id IS NOT NULL" +
        " AND #{Project.table_name}.status = #{Project::STATUS_ACTIVE}" +
        " AND #{Issue.table_name}.due_date <= ?", days.day.from_now.to_date
      )
      scope = scope.where(:assigned_to_id => user_ids) if user_ids.present?
      scope = scope.where(:project_id => project.id) if project
      scope = scope.where(:tracker_id => tracker.id) if tracker
      scope = apply_extra_options(scope, options)
      issues_by_assignee = scope.includes(:status, :assigned_to, :project, :tracker).
                                group_by(&:assigned_to)
      issues_by_assignee.keys.each do |assignee|
        if assignee.is_a?(Group)
          assignee.users.each do |user|
            issues_by_assignee[user] ||= []
            issues_by_assignee[user] += issues_by_assignee[assignee]
          end
        end
      end

      issues_by_assignee.each do |assignee, issues|
        reminder(assignee, issues, days).deliver if assignee.is_a?(User) && assignee.active?
      end
    end
  end

  private
  def apply_extra_options(issue_scope, options)
    issue_scope = issue_scope.where("#{Issue.table_name}.done_ratio > ?",  options[:ratio_gt])  if options[:ratio_gt]
    issue_scope = issue_scope.where("#{Issue.table_name}.done_ratio >= ?", options[:ratio_gte]) if options[:ratio_gte]
    issue_scope = issue_scope.where("#{Issue.table_name}.done_ratio < ?",  options[:ratio_lt])  if options[:ratio_lt]
    issue_scope = issue_scope.where("#{Issue.table_name}.done_ratio <= ?", options[:ratio_lte]) if options[:ratio_lte]
    issue_scope
  end
end

require_dependency 'mailer'
Mailer.__send__(:include, Reminderz::MailerPatch)
