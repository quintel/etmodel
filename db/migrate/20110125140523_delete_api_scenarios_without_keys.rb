class DeleteApiScenariosWithoutKeys < ActiveRecord::Migration
  def self.up
    ApiScenario.delete_all('api_session_key IS NULL')
  end

  def self.down
  end
end
