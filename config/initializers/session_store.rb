# require 'action_dispatch/middleware/session/dalli_store'
Etm::Application.config.session_store :active_record_store, key: "_etmodel"
