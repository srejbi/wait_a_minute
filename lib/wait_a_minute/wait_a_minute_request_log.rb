require 'active_record'
require 'active_support/configurable'

module WaitAMinute
  class WaitAMinuteRequestLog < ActiveRecord::Base

    def self.allow_request?(req = nil)
      return false unless req && (req.is_a?(ActionDispatch::Request) || req.is_a?(ActionController::TestRequest))
      allow = false
      ip = req.env['REMOTE_ADDR']
      if WaitAMinute.allowed_ips.include?(ip)
        Rails.logger.debug("IP #{ip} PASSING THROUGH WITHOUT REQUEST QUOTA CHECK...") if WaitAMinute.debug
        allow = true
      else
        interval = WaitAMinute.lookback_interval
        rinterval = 1.minutes
        limit = WaitAMinute.maximum_requests

        reqcount = nil
        allow = self.where(:ip => ip, :refused => true).where('created_at > ?', (Time.new - rinterval) ).count == 0
        allow &= (limit > (reqcount = self.where(:ip => ip).where('created_at > ?', (Time.new - interval) ).count)) if allow
        newreq = self.create( :ip => ip, :refused => !allow )

        Rails.logger.debug("IP #{ip} HAD #{reqcount} REQUESTS IN TIME WINDOW (max #{WaitAMinute.maximum_requests})...") if WaitAMinute.debug && !reqcount.nil?
        Rails.logger.debug("IP #{ip} HAD ALREADY REFUSED REQUESTS IN TIME WINDOW...HE WON'T STOP") if WaitAMinute.debug && reqcount.nil?
      end
      allow
    end

    def self.cleanup
      sql = ActiveRecord::Base.connection()

      sql.execute "SET autocommit=0"
      sql.begin_db_transaction
      sql.delete("DELETE FROM `#{self.name.to_s.underscore.downcase.gsub(/[a-z0-9_]+\//,'').pluralize}` WHERE created_at < '#{Time.new - WaitAMinute.lookback_interval}'")
      sql.commit_db_transaction
    end
  end
end
