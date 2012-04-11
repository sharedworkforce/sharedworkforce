module SharedWorkforce
  module Task

    def self.included(base)
      base.extend(ClassMethods)
      base.default_attributes(
        :title,
        :answer_type,
        :instruction,
        :responses_required,
        :replace,
        :answer_options,
        :image_url,
        :image_crop_ratio,
        :text,
        :on_success,
        :on_failure,
        :on_complete
      )
    end

    module ClassMethods
      
      def default_attributes(*args)
        if args.count > 0
          args.each do |name|
           class_eval %(
              class << self
                def #{name}(value)
                  set_default_attribute(:#{name}, value)
                end
              end

              attr_accessor :#{name}
            )
          end
        else
          @default_attributes || {}
        end
      end

      def set_default_attribute(name, value)
        @default_attributes ||= {}
        @default_attributes[name] = value
      end

      def get_default_attribute(name)
        @default_attributes ||= {}
        @default_attributes[name]
      end

      def create(*args)
        task = new(*args)
        task.request
        task
      end

      def cancel(*args)
        task = new(*args)
        task.cancel
        task
      end

    end # ends ClassMethods

    attr_reader :attributes

    def initialize_default_attributes
      self.class.default_attributes.each do |name, value|
        instance_variable_set("@#{name}", value)
      end
    end

    def initialize(resource_or_result=nil, attributes=nil)
      initialize_default_attributes
      if resource_or_result.is_a?(TaskResult)
        @result = resource_or_result
        process_result(@result)
      elsif resource_or_result
        unless resource_or_result.respond_to?(:id) && resource_or_result.class.respond_to?(:find)
          raise ArgumentError, "The resource you pass to new should respond to #id and it's class should respond to .find (or be an instance of ActiveRecord::Base) so it can be reloaded."
        end 
        @resource = resource_or_result
        initialize_attributes(attributes)
      end
      
      setup(resource) if respond_to?(:setup)
    end

    def process_result(result)
      initialize_attributes(result.callback_params)
      success!(result)
      complete!(result)
    end

    def success!(result)
      send(@on_success.to_sym, resource, result.responses) if @on_success
    end

    def complete!(result)
      send(@on_complete.to_sym, resource, result.responses) if @on_complete
    end

    def fail!(result)
      send(@on_failure.to_sym, resource, result.responses) if @on_failure
    end

    def resource
      @resource ||= find_resource
    end

    def request(options = {})
      task_request = remote_request(self, options)
      task_request.create
    end
    
    def cancel(options = {})
      task_request = remote_request(self, options)
      task_request.cancel
    end
  
    def to_hash
      {
        :title => title,
        :instruction => instruction,
        :image_url => image_url,
        :answer_options => answer_options,
        :responses_required => responses_required,
        :answer_type => answer_type.to_s,
        :callback_url => callback_url,
        :replace => replace,
        :text => text,
        :callback_params => attributes
      }.reject {|k,v| v.nil? }
    end

  private

    def find_resource
      if @result && @result.callback_params[:_task] && resource_params = @result.callback_params[:_task][:resource]
        resource_params[:class_name].constantize.find(resource_params[:id])
      end
    end
    
    def callback_url
      SharedWorkforce.configuration.callback_url
    end
    
    def remote_request(*args)
      SharedWorkforce.configuration.request_class.new(*args)
    end

    def initialize_attributes(attributes)
      @attributes = if attributes
        attributes.with_indifferent_access
      else
        {}
      end

      @attributes[:_task] = {:class_name => self.class.name}
      @attributes[:_task][:resource] = {:class_name => @resource.class.name, :id => @resource.id} if @resource
    end

  end
end