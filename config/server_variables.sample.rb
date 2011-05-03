# 
#
# SERVER_CONFIG is used in ServerConfig class. It uses this variabl to check which server_config has
# to be loaded. Check ServerConfig for more information.
#
#
# This file has to be copied to #{shared_path}/config_files/server_variables.rb
#  on every server. From there it will be copied to config/server_variables.rb
#  when deploying.
#

ENV['SERVER_CONFIG'] = :development