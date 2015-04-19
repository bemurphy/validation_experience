module ValidationExperience
  module Controller
    extend ActiveSupport::Concern

    class_methods do
      def track_validation_experience(options = {})
        around_action :_track_validation_experience, options
      end
    end

    private

    def _track_validation_experience
      track = ValidationExperience::Track.instance

      begin
        track.start(request)
        yield
      ensure
        track.finish
      end
    end
  end
end
