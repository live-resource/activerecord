require "live_resource/dependency"
require "active_record"

module LiveResource
  module ActiveRecord

    class Dependency < LiveResource::Dependency
      DEFAULT_EVENTS = [:after_destroy, :after_save]

      def self.accepts_target?(target)
        !!(target < ::ActiveRecord::Base) # The < operator returns nil instead of false
      end

      attr_reader :resource, :model_class

      def initialize(resource, model_class, proc, *events)
        @model_class = model_class

        if !events.empty?
          @events = events
        else
          @events = DEFAULT_EVENTS
        end

        super(resource, model_class, proc)
      end

      def watch
        @events.each { |event| observe event }
      end

      def observe(event)
        dependency = self
        model_class.class_eval do
          send(event, dependency)
        end
      end

      ::ActiveRecord::Callbacks::CALLBACKS.each do |callback|
        event = callback
        define_method(callback) { |record| invoke(record, event) }
      end
    end

  end
end