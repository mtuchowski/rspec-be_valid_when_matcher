# encoding: UTF-8
require 'rspec'
require 'bigdecimal'

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

      # Generate #is_*(type) methods.
      { numeric:    { value: 42, type: Numeric },
        integer:    { value: 42, type: Integer },
        fixnum:     { value: 42, type: Fixnum },
        bignum:     { value: 42**13, type: Bignum },
        float:      { value: Math::PI, type: Float },
        complex:    { value: 42.to_c, type: Complex },
        rational:   { value: 42.to_r, type: Rational },
        bigdecimal: { value: BigDecimal.new('42'), type: BigDecimal },
        string:     { value: 'value', type: String },
        regexp:     { value: /^value$/, type: Regexp },
        array:      { value: [42], type: Array },
        hash:       { value: { value: 42 }, type: Hash },
        symbol:     { value: :value, type: Symbol } }.each do |name, properties|
        define_method "is_#{name}" do |value = properties[:value]|
          fail ArgumentError, "should be #{name}" unless value.is_a? properties[:type]

          is(value, "a #{name}")
        end
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
        value = value_to_string
        message = @message.nil? ? "is #{value}" : "is #{@message} (#{value})"
        "##{@field} #{message}"
      end

      def value_to_string
        if [Complex, Rational, BigDecimal].any? { |type| @value.is_a? type }
          @value.to_s
        else
          @value.inspect
        end
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
