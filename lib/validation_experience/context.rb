module ValidationExperience
  class Context
    def initialize(request, user = nil)
      @request = request
      @user    = user
    end

    def models
      @models ||= Set.new
    end

    def to_h
      {
        :referrer   => request.referrer,
        :controller => request.params[:controller],
        :action     => request.params[:action],
        :models     => models.map { |m| format_model(m) }
      }.tap do |h|
        insert_user(h)
        any_invalid(h)
      end
    end

    private

    attr_reader :request, :user

    def format_model(model)
      {
        :id     => model.id,
        :name   => model.class.model_name.to_s,
        :errors => model.errors.map { |name, msg| format_error(name, msg, model) },
        :valid  => model.errors.empty?
      }
    end

    def format_error(name, message, model)
      AttributeError.new(name, message, model[name]).to_h
    end

    def insert_user(h)
      if user
        h[:user] = {
          :id => user.id,
          :type => user.class.name
        }
      end

      h
    end

    def any_invalid(h)
      h[:any_invalid] = h[:models].any? { |m| m[:valid] == false }
    end
  end
end
