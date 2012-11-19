require 'action_dispatch/middleware/session/dalli_store'
Etm::Application.config.session_store :dalli_store, :key => "_etmodel"
