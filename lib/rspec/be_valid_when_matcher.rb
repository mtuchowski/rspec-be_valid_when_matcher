# encoding: UTF-8
require 'rspec'

module RSpec
  # Container module for be_valid_when matcher definition and implementation.
  module BeValidWhenMatcher
    # Implements be_valid_when matcher behavior.
    # @api
    # @private
    class BeValidWhen

      def initialize(field)
        @field     = field
        @value_set = false
        @value     = nil
        @model     = nil
      end

      def matches?(model)
        @model = model
      end

      def does_not_match?(model)
        @model = model
      end

      def failure_message
        "expected #{@model.inspect} to be valid when #{format_message}"
      end

      def failure_message_when_negated
        "expected #{@model.inspect} not to be valid when #{format_message}"
      end

      def description
        "be valid when #{format_message}"
      end

      def diffable?
        false
      end

      def supports_block_expectations?
        false
      end

      def is(value)
        set_value(value)
        self
      end

      private

      def set_value(value)
        @value_set = true
        @value = value
      end

      def format_message
        "##{@field} is #{@value.inspect}"
      end

    end

    # Model validity assertion.
    def be_valid_when(*args)
      if args.size < 1 || args.size > 2
        raise ArgumentError, "wrong number of arguments (#{args.size} insted of 1 or 2)"
      end

      field_name = args.shift

      if ! field_name.instance_of? Symbol
        raise ArgumentError, "field name should be symbol (#{field_name.inspect})"
      end

      BeValidWhen.new(field_name).is(*args)
    end
  end
end
