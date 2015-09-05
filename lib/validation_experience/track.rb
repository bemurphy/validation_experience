module ValidationExperience
  class Track
    include Singleton

    attr_writer :report

    def self.report=(value)
      instance.report = value
    end

    def start(request, user = nil)
      self.context = nil

      unless request.get?
        self.context = Context.new(request, user)
      end
    end

    def <<(model)
      context.models << model if context
    end

    def finish
      if context && !context.models.empty?
        report.call(context.to_h)
      end
    end

    def report
      @report ||= LogReport
    end

    def format_errors(errors)
      errors
    end

    private

    def context=(value)
      Thread.current[:validation_experience_context] = value
    end

    def context
      Thread.current[:validation_experience_context]
    end
  end
end
