require "validation_experience/version"

require "validation_experience/attribute_error"
require "validation_experience/context"
require "validation_experience/controller"
require "validation_experience/model"
require "validation_experience/track"

module ValidationExperience
  class LogReport
    def self.call(data)
      Rails.logger.info("data = #{data}")
    end
  end

  def self.report=(report)
    Track.report = report
  end
end
