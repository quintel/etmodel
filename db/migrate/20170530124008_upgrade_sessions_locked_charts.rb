# Setting.locked_charts has changed from a hash of {holder => chart_id} to an
# array of [chart_id_1, chart_id_2, ...].
class UpgradeSessionsLockedCharts < ActiveRecord::Migration[5.0]
  def up
    total = ActiveRecord::SessionStore::Session.count

    ActiveRecord::SessionStore::Session.find_each.with_index do |sess, index|
      begin
        setting = sess.data['setting']

        if setting && setting.locked_charts.respond_to?(:values)
          setting.locked_charts = setting.locked_charts.values

          sess.data['setting'] = setting
          sess.save(validate: false)
        end
      rescue ArgumentError
        sess.destroy # dump format error; session cannot be decoded
      end

      puts "#{index}/#{total}" if (index % 100).zero?
    end

    puts "#{total}/#{total}"
  end

  def down
    ActiveRecord::SessionStore::Session.find_each.with_index do |sess, index|
      setting = sess.data['setting']

      if setting && setting.locked_charts.is_a?(Array)
        setting.locked_charts =
          Hash[setting.locked_charts.map.with_index do |id, holder_id|
            ["holder_#{holder_id}", id]
          end]

        sess.save(validate: false)
      end

      puts "#{index}/#{total}" if (index % 100).zero?
    end

    puts "#{total}/#{total}"
  end
end
