class CreateGqlTestCases < ActiveRecord::Migration
  def self.up
    create_table :gql_test_cases, :force => true do |t|
      t.string :name
      t.text :instruction
      t.text :description
      t.timestamps
    end
  end

  def self.down
    drop_table :gql_test_cases
  end
end