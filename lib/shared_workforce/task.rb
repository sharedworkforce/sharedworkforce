require 'active_support/inflector'
module SharedWorkforce
  module Task

    def self.find(name)
      "#{name.gsub(' ', '_').classify}Task".constantize
    end

    def self.included(base)
      base.extend(ClassMethods)
      base.default_attributes(
        :title,
        :answer_type,
        :instruction,
        :responses_required,
        :replace,
        :answer_options,
        :image_url
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

      def on_complete(value)
        @on_complete = value
      end

      def on_success(value)
        @on_success = value
      end

      def on_failure(value)
        @on_failure = value
      end

      def success!(results)
        new.send(@on_success.to_sym, results) if @on_success
      end

      def complete!(results)
        new.send(@on_complete.to_sym, results) if @on_complete
      end

      def fail!(results)
        new.send(@on_failure.to_sym, results) if @on_failure
      end
    end # ends ClassMethods

    def initialize_default_attributes
      self.class.default_attributes.each do |name, value|
        instance_variable_set("@#{name}", value)
      end
    end

    def initialize(params=nil)
      initialize_default_attributes
      if params
        params.each do |k,v|
          if self.respond_to?("#{k.to_sym}=")
            self.send("#{k.to_sym}=", v)
          else
            raise "Unknown attribute #{k}"
          end
        end
      end
    end

    def request(options)
      task_request = remote_request(self, options)
      task_request.create
    end
    
    def cancel(options)
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
        :replace => replace
      }
    end
   
  private
    
    def callback_url
      SharedWorkforce.configuration.callback_url
    end
    
    def remote_request(*args)
      SharedWorkforce.configuration.request_class.new(*args)
    end
  end
end