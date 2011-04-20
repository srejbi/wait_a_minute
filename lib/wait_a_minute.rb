require 'active_support/core_ext/numeric/time'
require 'active_support/dependencies'

module WaitAMinute
  # The interval for looking back
  mattr_accessor :lookback_interval
  @@lookback_interval = 2.minutes

  # The maximum allowed requests in lookback_interval
  mattr_accessor :maximum_requests
  @@maximum_requests = 12		# that means a request every 10 seconds on average, that's pretty high from a human behind the IP

  # Debug mode (puts some info in Rails log)
  mattr_accessor :debug
  @@debug = false		# that means a request every 10 seconds on average, that's pretty high from a human behind the IP

  # The desired layout for the 503 error page
  mattr_accessor :layout
  @@layout = nil		# serving a simple page by default

  # Array of strings containing IP addresses that are allowed to pass through
  mattr_accessor :allowed_ips
  @@allowed_ips = []



  autoload :WaitAMinuteRequestLog, File.dirname(__FILE__) + '/wait_a_minute/wait_a_minute_request_log.rb'

  require "rails"

  class Engine < Rails::Engine
    # we have a view
  end

  def self.cleanup
    WaitAMinuteRequestLog.cleanup
  end


  # WaitAMinute::ControllerHelpers
  module ControllerHelpers #:nodoc
    # this will be called as a before filter
    def prevent_dos
      render_dos unless WaitAMinuteRequestLog.allow_request?(request)
    end

    # this will be called if IP exceeds allowed calls
    def render_dos
      respond_to do |type|
        type.html { render :template => "wait_a_minute/wait_a_minute", :status => 503, :layout => WaitAMinute.layout }
        type.all  { render :nothing => true, :status => 503 }
      end
      true
    end

  end   # WaitAMinute::ControllerHelpers

end   # WaitAMinute


# include view helpers in your actions
ActionController::Base.module_eval do
  include WaitAMinute::ControllerHelpers
  before_filter :prevent_dos
end
