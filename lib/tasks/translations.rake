namespace :translations do
  desc 'Checks which translations are to be translated in the YAML files.'
  task :check do
    nl_keys = list_all_keys("", YAML::load_file('config/locales/nl.yml')["nl"])
    en_keys = list_all_keys("", YAML::load_file('config/locales/en.yml')["en"])

    puts "Keys in EN, but not in NL:"
    puts display_keys(en_keys - nl_keys)

    puts "Keys in NL, but not in EN:"
    puts  display_keys(nl_keys - en_keys)
  end
end


def display_keys(arr)
  arr.map{ |x| "\t%s\n" % x }.join
end

# Lists all keys in the hash
# For example:
#
# a = {'level1' => {'item1' => 'value', 'item2' => 'value', 'item3' => {'some' => 'asdasd'}}}
# => ['level1.item1', 'level1.item2', 'level1.item3.some']
#
def list_all_keys(key, arr)
  out = []
  arr.each do |k, value|
    new_key = key == "" ? k : "%s.%s" % [key, k]

    if value.kind_of?(Hash)
      out += list_all_keys(new_key, value)
    else
      out << new_key
    end
  end
  out
end
