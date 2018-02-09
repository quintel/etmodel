class DefaultUserAllowNewsToFalse < ActiveRecord::Migration[5.1]
  def up
    change_column :users, :allow_news, :boolean, default: false
  end

  def down
    change_column :users, :allow_news, :boolean, default: true
  end
end
