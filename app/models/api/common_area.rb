module Api
  # Contains custom methods for Area and ScaledArea.
  module CommonArea
    # Public: Returns a hash of attributes associated with the area. Includes
    # the ETModel-only "is_local_scenario" and "is_national_scenario".
    def attributes(*)
      data = super

      data['is_local_scenario']    = is_local_scenario
      data['is_national_scenario'] = is_national_scenario

      data
    end

    def is_national_scenario
      true
    end

    def is_local_scenario
      ! is_national_scenario
    end
  end
end
