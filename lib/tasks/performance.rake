namespace :p do
  task :flatten => :environment do
    arr = (0..1000).to_a.map{|i| [Qernel::Converter.new(i, "test#{i}")]}
    Benchmark.bm(40) do |b|
      b.report { arr.flatten }
    end
  end


  desc "Gqueries" 
  task :parsing => :environment do
    parser = GqlQueryParser.new
    Benchmark.bm(40) do |x|
      x.report("parse") do
        1000.times { parser.parse("SUM(PRODUCT(1.0,BILLIONS),1234)") }
      end
    end
  end

  desc "Executing" 
  task :default => :environment do
    GC.disable
    Current.scenario.country = 'nl'
    gql = Current.gql
    gql.query('Q(cost_electricity_production)')
    queries = [
      "Q(primary_demand_of_final_demand)",
      "Q(co2_emission_total)",
      "Q(ambient_heat_use)",
      "Q(final_electricity_sustainable)",
      "Q(final_sustainable_demand)"
    ]
    Benchmark.bm(40) do |b|
      b.report("all") do
        queries.each do |key|      
          10.times {gql.query(key)}
        end
      end
    end
  end

  desc "Executing" 
  task :gquery => :environment do
    GC::Profiler.enable
    GC.disable
    Current.scenario.country = 'nl'
    gql = Current.gql
    gquery = gql.query_interface
    gquery.graph = gql.future

    Benchmark.bm(40) do |b|
      queries = [
        "V(G(heat_production),G(decentral_production); cost_om_per_mj)",
        "V(G(heat_production),G(decentral_production); fuel_cost_raw_material_per_mje)",
        "V(G(heat_production),G(decentral_production); cost_fuel_other_per_mj)",
        "V(G(heat_production),G(decentral_production); finance_and_capital_cost)",
        "V(G(heat_production),G(decentral_production); cost_co2_per_mj_output)",
        "Q(co2_emission_industry_without_electricity)",
        "Q(cost_heat_production)",
        "Q(cost_electricity_production)",
        "Q(cost_transport_fuels)",
        "Q(cost_energy_sector_fuels)",
        "Q(cost_non_energetic_fuels)",
        "Q(annual_netwerk_cost)"
      ]
      queries.each do |query|
        b.report(query) do
          10.times { gquery.query(query) }
        end
      end
      b.report("SUM(100)") do
        10.times { gquery.query("SUM(100)") }
      end
      b.report("V(large_chp_industry_energetic;demand)") do
        10.times { gquery.query("V(large_chp_industry_energetic;demand)") }
      end
      b.report("V(small_chp_industry_energetic;demand)") do
        10.times { gquery.query("V(small_chp_industry_energetic;demand)") }
      end
      b.report("V(biomass_chp_industry_energetic;demand)") do
        10.times { gquery.query("V(biomass_chp_industry_energetic;demand)") }
      end
      b.report("V(2;demand)") do
        10.times { gquery.query("V(small_chp_industry_energetic,small_chp_industry_energetic,small_chp_industry_energetic,small_chp_industry_energetic,small_chp_industry_energetic,small_chp_industry_energetic,small_chp_industry_energetic,large_chp_industry_energetic;demand)") }
      end
      
      b.report("V(demand)+V(demand)") do
        10.times { gquery.query("SUM(V(large_chp_industry_energetic;demand),V(large_chp_industry_energetic;demand))") }
      end
      b.report("V(demand)") do
        10.times { gquery.query("SUM(V(large_chp_industry_energetic;demand*demand))") }
      end
    end

    GC::Profiler.report

  end


  desc "Selecting converters by keys"
  task :graph_api => :environment do
    Current.scenario.country = 'nl'
    gql = Current.gql
    converter_keys = gql.present.converters.map(&:full_key)
    group_keys = gql.present.groups.map(&:key).uniq
    sector_keys = gql.present.converters.map(&:sector_key).uniq.compact
    gquery = gql.query_interface
    gquery.graph = gql.future

    Benchmark.bm(40) do |x|
      x.report("#converters #{converter_keys.length} keys") do
        converter_keys.each do |key|
          gquery.converters(key)
        end
      end
      x.report("#group_converters") do
        group_keys.each do |key|
          gquery.group_converters(key)
        end
      end
      x.report("#sector_converters") do
        sector_keys.each do |key|
          gquery.sector_converters(key)
        end
      end
    end
  end

  task :constraints => :environment do
    gql = Current.gql
    Benchmark.bm(20) do |x|
      Constraint.all.each do |constraint|
        x.report(constraint.key.to_s) { 10.times do gql.query(constraint.query); end }
      end
    end
    Benchmark.bm(20) do |x|
      x.report("grid_investment_needed") { 10.times do gql.query("future:Q(grid_investment_needed)"); end }
    end
  end

#  TODO sebi please decide if we need this task and, if so, what to do about version_or_latest
#  desc 'Performance: Calculation of Kernel. rake p:calc version=v77'
#  task :gql => :environment do
#    graph = Graph.version_or_latest(ENV['version'])
#    graph.present
#    graph.future
#
#    Benchmark.bm(10) do |x|
#      x.report("GQL (1x)")   {
#        gql = graph.gql
#      }
#    end
#  end
end