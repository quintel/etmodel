Autotest.add_discovery { "rails" }
Autotest.add_discovery { "rspec2" }

Autotest.add_hook :green do 
  Kernel.system('find . -name "*.rb" | xargs grep -n "# DEBT"')
end
