# encoding: UTF-8
require 'rspec'

# RSpec's top level namespace.
module RSpec
  # Container module for be_valid_when matcher definition and implementation.
  module BeValidWhenMatcher
    # rubocop:disable Style/PredicateName

    # Provides the implementation for `be_valid_when` matcher.
    # Not intended to be instantiated directly.
    # @api private
    class BeValidWhen
      # Returns a new instance of matcher.
      # @param field (Symbol) field name to use.
      # @raise ArgumentError if field name is not a symbol.
      def initialize(field)
        unless field.instance_of? Symbol
          fail ArgumentError, "field name should be symbol (#{field.inspect})"
        end

        @field     = field
        @value_set = false
        @value     = nil
        @model     = nil
      end

      # Passes if given `model` instance is valid.
      #
      # More specifically if it doesn't have any
      # {http://api.rubyonrails.org/classes/ActiveModel/Validations.html#method-i-errors `errors`}
      # on specified `field` after setting it's `value` and validating it. Does not take into
      # account other fields and the validity of the whole object.
      # @api private
      # @param model [Object] an Object implementing `ActiveModel::Validations`.
      # @return [Boolean] `true` if there are no errors on `field`, `false` otherwise.
      def matches?(model)
        setup_model model
        @model.errors[@field].empty?
      end

      # Passes if given `model` instance is invalid.
      #
      # More specifically if it does have
      # {http://api.rubyonrails.org/classes/ActiveModel/Validations.html#method-i-errors `errors`}
      # on specified `field` after setting it's `value` and validating it. Does not take into
      # account other fields.
      # @api private
      # @param model [Object] an Object implementing `ActiveModel::Validations`.
      # @return [Boolean] `true` if there are errors on `field`, `false` otherwise.
      def does_not_match?(model)
        setup_model model
        !@model.errors[@field].empty?
      end

      # Called when {#matches?} returns false.
      # @api private
      # @return [String] explaining what was expected.
      def failure_message
        assert_value_existence
        assert_model_existance

        "expected #{@model.inspect} to be valid when #{format_message}"
      end

      # Called when {#does_not_match?} returns false.
      # @api private
      # @return [String] explaining what was expected.
      def failure_message_when_negated
        assert_value_existence
        assert_model_existance

        "expected #{@model.inspect} not to be valid when #{format_message}"
      end

      # Used to generate the example's doc string in one-liner syntax.
      # @api private
      # @return [String] short description of what is expected.
      def description
        assert_value_existence

        "be valid when #{format_message}"
      end

      # Indicates that this matcher doesn't provide actual and expected attributes.
      # @api private
      # @return [FalseClass]
      def diffable?
        false
      end

      # Indicates that this matcher cannot be used in a block expectation expression.
      # @api private
      # @return [FalseClass]
      def supports_block_expectations?
        false
      end

      # Used to set field `value` and optional custom failure `message`.
      # @overload is(value)
      #   Sets the field `value`.
      #   @param value [Any] field `value` to use in matching.
      # @overload is(value, message)
      #   Sets the field `value` and custom failure `message`.
      #   @param value [Any] field `value` to use in matching.
      #   @param message [String] a `message` used for {#failure_message},
      #   {#failure_message_when_negated} and {#description}.
      # @return [self]
      def is(*args)
        number_of_arguments = args.size

        if number_of_arguments > 2 || number_of_arguments == 0
          fail ArgumentError, "wrong number of arguments (#{number_of_arguments} insted of 1 or 2)"
        else
          self.value = args.shift
          @message = args.first
        end

        self
      end

      # Used to setup matcher for checking `nil` `value`.
      def is_not_present
        is(nil, 'not present')
      end

      # Used to setup matcher for checking for numeric values.
      def is_number(number = 42)
        fail ArgumentError, 'should be number' unless number.is_a? Numeric

        is(number, 'number')
      end

      # Used to setup matcher for checking for fixnum values.
      def is_fixnum(number = 42)
        fail ArgumentError, 'should be a fixnum' unless number.is_a? Fixnum

        is(number, 'a fixnum')
      end

      # Used to setup matcher for checking for bignum values.
      def is_bignum(number = 42**13)
        fail ArgumentError, 'should be a bignum' unless number.is_a? Bignum

        is(number, 'a bignum')
      end

      private

      attr_writer :message

      def value=(value)
        @value = value
        @value_set = true
      end

      def assert_value_existence
        fail ArgumentError, 'missing value' unless @value_set
      end

      def assert_model_existance
        fail ArgumentError, 'missing model' if @model.nil?
      end

      def setup_model(model)
        assert_value_existence

        @model = model
        @model.send "#{@field}=", @value
        @model.validate
      end

      def format_message
        value = @value.inspect
        message = @message.nil? ? "is #{value}" : "is #{@message} (#{value})"
        "##{@field} #{message}"
      end
    end

    # Model validity assertion.
    def be_valid_when(*args)
      number_of_arguments = args.size
      field_name = args.shift

      if number_of_arguments == 1
        BeValidWhen.new(field_name)
      else
        BeValidWhen.new(field_name).is(*args)
      end
    end
  end
end
