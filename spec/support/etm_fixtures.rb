# TODO: Get rid of this - PZ Wed 11 May 2011 09:56:29 CEST

module EtmFixtures

  def load_gql_fixture ; Marshal.load(File.read(File.join(Rails.root, "spec/fixtures/gql.dump"))) ; end

  # load consistent set of queries (including those in policy_goals and constraints)
  require 'active_record/fixtures'
  def load_fixtures
    fixtures_path = "spec/fixtures"
    Dir[Rails.root.join(fixtures_path, "*.{yml,csv}").to_s].each do |file|
      Fixtures.create_fixtures(fixtures_path, File.basename(file, '.*'))
    end
  end
end