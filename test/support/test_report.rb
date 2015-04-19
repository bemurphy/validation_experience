module ValidationExperience
  class TestReport
    def self.reported
      @reported || []
    end

    def self.call(data)
      @reported ||= []
      @reported << data
    end

    def self.reset
      @reported = nil
    end
  end
end
