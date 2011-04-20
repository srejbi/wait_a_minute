module WaitAMinute
  module Generators
    class MigrationGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)

      desc "Creates a WaitAMinute migration in your application."
      class_option :orm

      def copy_migration
        template 'migration.rb', "db/migrate/#{Time.new.strftime("%Y%m%d%H%M%S")}_create_wait_a_minute.rb"
      end
    end
  end
end
