# See https://github.com/rails/activerecord-session_store/issues/6#issuecomment-26214581
ActiveRecord::SessionStore::Session.attr_accessible :data, :session_id
