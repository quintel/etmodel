#!/usr/bin/env ruby
require 'fileutils'

template_executable_file = File.join(File.dirname(__FILE__), "application_files", "script", "oink")
executable_file = File.expand_path("#{File.dirname(__FILE__)}/../../../script/oink")

FileUtils.copy template_executable_file, executable_file
FileUtils.chmod 0755, executable_file
