module ValidationExperience
  module Model
    extend ActiveSupport::Concern

    included do
      after_validation { ValidationExperience::Track.instance << self }
    end
  end
end
