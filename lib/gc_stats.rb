# Basic middleware to help developers track their memory usage
# DO NOT USE IN PRODUCTION
# Currently only tested on Ruby 1.9 and no support guaranteed

# Output example:
#
#  GC run, previous cycle was 255 requests ago.
#
# GC 40 invokes.
# Index    Invoke Time(sec)       Use Size(byte)     Total Size(byte)         Total Object                    GC Time(ms)
#     1               1.267              3094640              4063232               101432        14.47700000000007314327
#     2               1.391              3088480              4063232               101432        13.95699999999999718625
#     3               1.514              3091160              4063232               101432        13.84699999999994268762
#     4               1.643              3093400              4063232               101432        14.65799999999983782573
#     5               1.771              3094800              4063232               101432        15.47099999999979047516
#     6               1.899              3089200              4063232               101432        14.96900000000001007550
#     7               2.028              3091600              4063232               101432        17.90399999999969793407
#     8               2.164              3093320              4063232               101432        15.38599999999989975663
#     9               2.298              3091440              4063232               101432        15.29500000000005854872
#    10               2.432              3089800              4063232               101432        16.75899999999996836664
#    11               2.570              3093280              4063232               101432        14.70199999999977080734
#
# ## 23900 freed objects. ##
# [60%] 14414 freed strings.
# [12%] 2927 freed arrays.
# [9%] 2268 freed big numbers.
# [2%] 564 freed hashes.
# [1%] 373 freed objects.
# [5%] 1351 freed parser nodes (eval usage).
#
#
# or:
#
# [GC Stats] 146 new allocated objects.

class GCStats

  @@req_since_gc_cycle = 0

  def initialize(app)
    GC::Profiler.enable unless GC::Profiler.enabled?
    @app = app
  end

  def call(env)
    before_stats = ObjectSpace.count_objects
    response = @app.call(env)
    after_stats = ObjectSpace.count_objects
    if before_stats[:TOTAL] < after_stats[:TOTAL]
      puts "Total objects in memory bumped by #{after_stats[:TOTAL] - before_stats[:TOTAL]} objects."
    end

    if before_stats[:FREE] > after_stats[:FREE]
      puts "\033[0;32m[GC Stats]\033[1;33m #{before_stats[:FREE] - after_stats[:FREE]} new allocated objects.\033[0m"
      @@req_since_gc_cycle += 1
    else
      report = GC::Profiler.result
      GC::Profiler.clear
      if report != ''
        puts red("\n GC run, previous cycle was #{@@req_since_gc_cycle} requests ago.\n")
        puts report
        total_freed   = after_stats[:FREE] - before_stats[:FREE]
        freed_strings = before_stats[:T_STRING] - after_stats[:T_STRING]
        freed_arrays  = before_stats[:T_ARRAY] - after_stats[:T_ARRAY]
        freed_nums    = before_stats[:T_BIGNUM] - after_stats[:T_BIGNUM]
        freed_hashes  = before_stats[:T_HASH] - after_stats[:T_HASH]
        freed_objects = before_stats[:T_OBJECT] - after_stats[:T_OBJECT]
        freed_nodes   = before_stats[:T_NODE] - after_stats[:T_NODE]

        freed_strings_percent = ((freed_strings * 100) / total_freed)
        freed_arrays_percent = ((freed_arrays * 100) / total_freed)
        freed_nums_percent = ((freed_nums * 100) / total_freed)
        freed_hashes_percent = ((freed_hashes * 100) / total_freed)
        freed_objects_percent = ((freed_objects * 100) / total_freed)
        freed_nodes_percent = ((freed_nodes * 100) / total_freed)

        puts red("\n## #{total_freed} freed objects. ##")
        puts red("[#{freed_strings_percent}%] #{freed_strings} freed strings.")
        puts red("[#{freed_arrays_percent}%] #{freed_arrays} freed arrays.")
        puts red("[#{freed_nums_percent}%] #{freed_nums} freed bignums.")
        puts red("[#{freed_hashes_percent}%] #{freed_hashes} freed hashes.")
        puts red("[#{freed_objects_percent}%] #{freed_objects} freed objects.")
        puts red("[#{freed_nodes_percent}%] #{freed_nodes} freed parser nodes (eval usage).")

        # puts "before objects: #{before_stats.inspect}"
        # puts "after objects: #{after_stats.inspect}"
        puts "\n------\n"
        @@req_since_gc_cycle = 0
      end
    end

    response
  end

  def red(text)
    "\033[0;31m#{text}\033[0m"
  end

end
