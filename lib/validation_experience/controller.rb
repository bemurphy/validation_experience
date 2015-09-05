module ValidationExperience
  module Controller
    extend ActiveSupport::Concern

    module ClassMethods
      def track_validation_experience(options = {})
        around_action :_track_validation_experience, options
      end
    end

    private

    def _track_validation_experience
      track = ValidationExperience::Track.instance

      begin
        track.start(request, validation_experience_user)
        yield
      ensure
        track.finish
      end
    end

    def validation_experience_user
      current_user if respond_to?(:current_user, true)
    end
  end
end
