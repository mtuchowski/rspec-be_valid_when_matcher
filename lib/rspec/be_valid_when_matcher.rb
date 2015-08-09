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
        unless field.instance_of? Symbol
          fail ArgumentError, "field name should be symbol (#{field.inspect})"
        end

        @field     = field
        @value_set = false
        @value     = nil
        @model     = nil
      end

      def matches?(model)
        assert_value_existence
        @model = model
      end

      def does_not_match?(model)
        assert_value_existence
        @model = model
      end

      def failure_message
        assert_value_existence
        assert_model_existance
        "expected #{@model.inspect} to be valid when #{format_message}"
      end

      def failure_message_when_negated
        assert_value_existence
        assert_model_existance
        "expected #{@model.inspect} not to be valid when #{format_message}"
      end

      def description
        assert_value_existence
        "be valid when #{format_message}"
      end

      def diffable?
        false
      end

      def supports_block_expectations?
        false
      end

      def is(value)
        value(value)
        self
      end

      private

      def value(value)
        @value_set = true
        @value = value
      end

      def assert_value_existence
        fail ArgumentError, 'missing value' unless @value_set
      end

      def assert_model_existance
        fail ArgumentError, 'missing model' if @model == nil
      end

      def format_message
        "##{@field} is #{@value.inspect}"
      end
    end

    # Model validity assertion.
    def be_valid_when(*args)
      number_of_arguments = args.size
      field_name = args.shift

      if number_of_arguments == 1
        BeValidWhen.new field_name
      elsif number_of_arguments == 2
        BeValidWhen.new(field_name).is(*args)
      else
        fail ArgumentError, "wrong number of arguments (#{number_of_arguments} insted of 1 or 2)"
      end
    end
  end
end
