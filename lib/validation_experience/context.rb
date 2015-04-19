module ValidationExperience
  class Context
    attr_reader :request
    private :request

    def initialize(request)
      @request = request
    end

    def models
      @models ||= Set.new
    end

    def to_h
      {
        :referrer   => request.referrer,
        :controller => request.params[:controller],
        :action     => request.params[:action],
        :models     => models.map {|m| format_model(m) }
      }
    end

    def format_model(model)
      {
        :id     => model.id,
        :name   => model.class.model_name.to_s,
        :errors => model.errors.map do |name, message|
          AttributeError.new(name, message, model[name]).to_h
        end,
        :valid => model.errors.empty?
      }
    end
  end
end
