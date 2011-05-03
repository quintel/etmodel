# Provides methods to do performance profiling
# Adds a method to 
module ApplicationController::PerformanceProfiling
  extend ActiveSupport::Concern
  
  included do
    around_filter :profile
  end


  
  # Profiles the current request, by adding ?profile=true after a request.
  # 
  # Makes use google-perftools, to do the profiling.
  # @see http://google-perftools.googlecode.com/svn/trunk/doc/cpuprofile.html#pprof
  def profile
    return yield if params[:profile].nil?

    raise "Error"
    output_file = '/tmp/request_profiling'
    pdf_file = "#{Rails.rootROOT}/public%s.pdf" % [output_file]

    PerfTools::CpuProfiler.start(output_file) do
      yield
    end 

    # generate pdf
    `pprof.rb --pdf #{output_file} >> #{pdf_file}`

    # generate txt ouput
    out = `pprof.rb --text #{output_file}`
    html = <<-END
      <a href="#{output_file}.pdf">#{output_file}.pdf</a><br /><br /><br />
      <p>Here is how to interpret the columns:</p> 
      <ol> 
        <li> Number of profiling samples in this function
        <li> Percentage of profiling samples in this function
        <li> Percentage of profiling samples in the functions printed so far
        <li> Number of profiling samples in this function and its callees
        <li> Percentage of profiling samples in this function and its callees
        <li> Function name
      </ol>
      <pre><code>#{out}</code></pre>
    END

    response.body.replace html
    response.content_type = "text/html"
  end
  
end

