module ValidationExperience
  class AttributeError
    attr_reader :name, :message, :value

    def initialize(name, message, value)
      @name      = name.to_s
      @message   = message
      self.value = value
    end

    def value=(value)
      if filtered_name?
        @value = "[FILTERED]"
      else
        @value = value
      end
    end

    def to_h
      { name: name, message: message, value: value }
    end

    private

    def filtered_name?
      Rails.configuration.filter_parameters.any? do |filtered|
        name.to_s.include?(filtered.to_s)
      end
    end
  end
end
