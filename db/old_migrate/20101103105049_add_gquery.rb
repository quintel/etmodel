class AddGquery < ActiveRecord::Migration
  def self.up
    unless Gquery.find_by_key('not_renewable_percentage')
      execute("INSERT INTO `gqueries` (`id`,`key`,`query`,`name`,`description`,`created_at`,`updated_at`,`not_cacheable`,`usable_for_optimizer`) VALUES (NULL, 'not_renewable_percentage', 'SUM(\n	1, NEG(\n		Q(share_of_renewable_energy)\n	)\n)', NULL, NULL, '2010-11-01 12:03:14', '2010-11-01 12:03:14', 0, 1);")
    else
      puts "You already got the not_renewable_percentage gquery. No need to add it."
    end
    execute("UPDATE `gqueries` SET `usable_for_optimizer`= 0 WHERE `key` = 'renewable_percentage'")    
  end

  def self.down
  end
end
