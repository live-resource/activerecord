require "live_resource/dependency"
require "active_record"

module LiveResource
  module ActiveRecord

    class Dependency < LiveResource::Dependency
      DEFAULT_EVENTS = [:after_commit]

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
        # Declare variables in method scope so they're preserved in the block
        dependency          = self
        subscribed_events   = @events
        target              = @model_class
        class_name          = "Observer_#{@resource.name}_dependency_on_#{@model_class}_for_#{@events.join('_')}"

        # Construct a new observer class
        dependency_observer = Class.new(::ActiveRecord::Observer) do
          observe target

          # Give it a class name otherwise ActiveRecord will explode
          @_class_name = class_name
          class << self
            def name
              @_class_name
            end
          end

          # Create callback methods on the observer class for each subscribed event
          subscribed_events.each do |event_name|
            define_method(event_name) do |*args|
              dependency.invoke(args[0], event_name)
            end
          end
        end

        # Instantiating the observer class will make it hook itself up
        dependency_observer.send :new
      end
    end

  end
end