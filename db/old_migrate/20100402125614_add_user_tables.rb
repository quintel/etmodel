class AddUserTables < ActiveRecord::Migration
  def self.up
    create_table :sessions do |t|
       t.string :session_id, :null => false
       t.text :data
       t.timestamps
     end

     add_index :sessions, :session_id
     add_index :sessions, :updated_at

     create_table :users do |t|
       t.string :username,    :null => false
       t.string :email,    :null => false
       t.string :company_school,    :null => true
       t.boolean :allow_news,    :default =>1
       t.string :heared_first_at,    :default => '..'
       t.string :crypted_password,    :null => false
       t.string :password_salt,    :null => false
       t.string :persistence_token,    :null => false
       t.string :perishable_token,    :null => false
       t.integer   :login_count,         :null => false, :default => 0 # optional, see Authlogic::Session::MagicColumns
       t.integer   :failed_login_count,  :null => false, :default => 0 # optional, see Authlogic::Session::MagicColumns
       t.datetime  :last_request_at                                    # optional, see Authlogic::Session::MagicColumns
       t.datetime  :current_login_at                                   # optional, see Authlogic::Session::MagicColumns
       t.datetime  :last_login_at                                      # optional, see Authlogic::Session::MagicColumns
       t.string    :current_login_ip                                   # optional, see Authlogic::Session::MagicColumns
       t.string    :last_login_ip                                      # optional, see Authlogic::Session::MagicColumns
       t.integer :role_id
       t.timestamps
     end

     create_table :roles do |t|
       t.string :name

       t.timestamps
     end
  end

  def self.down
    drop_table :sessions
    drop_table :users
    drop_table :roles
  end
end
