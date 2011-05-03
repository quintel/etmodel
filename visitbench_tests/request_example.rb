
host = "http://testing.et-model.com"



performance_engine = VisitBench.new(:host => host, :headers => {'Authorization' => 'Basic ZGV2X3RlYW06RW5lcmd5Mi4w'}) do |pe|
  pe.add_session do |session|
    session.add_request '/', :time_on_page => 3
    session.add_request '/', :time_on_page => 1, :method => :post, :params => {"country"=>"nl", "region"=>{"nl"=>"nl"}, "end_year"=>"2020", "complexity"=>"3", "commit"=>"Start", "controller"=>"pages", "action"=>"root"}
    session.add_request '/policy', :time_on_page => 2 
    session.add_request '/demand/households'
    session.add_request '/query/update/33/?198=15.3&t=1285155984855', :time_on_page => 3
    session.add_request '/query/update/34/?234=39.7&t=1285156022704', :time_on_page => 3
    session.add_request '/query/update/36/?193=156.5&194=0.0&195=0.0&t=1285156067792', :time_on_page => 3
    session.add_request '/policy/dependence'
  end
end

benchmark = performance_engine.run(:amt_times => 1, :concurrent_users => 1)
puts "Done benchmarking."
puts ""
puts ""
100.times { print "-"}
puts ""
puts "Performance Report"
100.times { print "-"}
puts ""

puts Report.new(benchmark)

