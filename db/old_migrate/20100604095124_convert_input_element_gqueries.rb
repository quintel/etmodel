class ConvertInputElementGqueries < ActiveRecord::Migration
  def self.up
    InputElement.all.each do |ie|
      %w[start_value_gql min_value_gql max_value_gql].each do |key|
        if old_gql = ie.send(key) and old_gql.present? and !old_gql.include?('(')
          modifier,keys,attribute = old_gql.split('.')
          if keys.include?('_AND_')
            query = "SUM(V(#{keys.gsub('_AND_',',')};#{attribute}))"
          else
            query = "V(#{keys};#{attribute})"
          end
          new_gql = "#{modifier}:#{query}"
          ie.update_attribute key, new_gql
        end
      end
    end
  end

  def self.down
  end
end
