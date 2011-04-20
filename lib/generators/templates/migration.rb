class WaitAMinuteCreateWaitAMinuteRequestLogs < ActiveRecord::Migration
  def self.up
    create_table :wait_a_minute_request_logs, :id => false do |t|
      t.string :ip
      #t.string :url
      t.boolean :refused, :nil => false, :default => false
      t.datetime :created_at, :nil => false

      #t.timestamps
    end
    add_index :wait_a_minute_request_logs, :ip
    #add_index :wait_a_minute_request_logs, :url
    add_index :wait_a_minute_request_logs, :created_at
    add_index :wait_a_minute_request_logs, [:ip, :refused], :name => 'refused_ip_index'
    add_index :wait_a_minute_request_logs, [:ip, :created_at], :name => 'ip_by_date_index'
    add_index :wait_a_minute_request_logs, [:ip, :created_at, :refused], :name => 'index_all'
  end

  def self.down
    drop_table :wait_a_minute_request_logs
  end
end
