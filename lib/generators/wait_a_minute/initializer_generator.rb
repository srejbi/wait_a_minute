module WaitAMinute
  module Generators
    class InitializerGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)

      desc "Creates a WaitAMinute initializer in your application."
      class_option :orm

      def copy_initializer
        template "initializer.rb", "config/initializers/wait_a_minute.rb"
      end
    end
  end
end

