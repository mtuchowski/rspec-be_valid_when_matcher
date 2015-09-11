require 'active_model'
require 'support/has_correct_description'
require 'support/returns_proper_results'

# @private
class FakeModelFoo
  include ActiveModel::Validations

  [Numeric, Integer, Fixnum, Bignum, Float, Complex, Rational, BigDecimal,
   String, Regexp, Array, Hash, Symbol, TrueClass, FalseClass].each do |type|
    type_name      = type.name.downcase
    field_name     = "#{type_name}_field"
    not_field_name = "not_#{field_name}"

    # Accessors
    send(:attr_accessor, field_name)
    send(:attr_accessor, not_field_name)

    # Validator for not_field_name attribute
    validator_name = "#{not_field_name}_cannot_be_#{type_name}"

    define_method validator_name do
      errors.add(not_field_name.to_sym, "can't be #{type_name}") if
        send(not_field_name).is_a? type
    end

    send(:validate, validator_name)
  end

  %w(numeric integer fixnum complex rational bigdecimal).each do |type_name|
    send(:validates_numericality_of, "#{type_name}_field".to_sym, greater_than: 41)
  end

  validates_numericality_of :float_field, greater_than: 3.0
  validates_numericality_of :bignum_field, greater_than: 30129469486639681537
  validates_length_of :string_field, minimum: 4
  validate :regexp_field_cannot_be_empty
  validate :array_field_cannot_be_empty
  validate :hash_field_cannot_be_empty
  validate :symbol_field_cannot_be_short
  validate :trueclass_field_cannot_be_false
  validate :falseclass_field_cannot_be_true

  def regexp_field_cannot_be_empty
    errors.add(:regexp_field, "can't be empty") if regexp_field.inspect.length < 3
  end

  def array_field_cannot_be_empty
    errors.add(:array_field, "can't be empty") if !array_field.nil? && array_field.length == 0
  end

  def hash_field_cannot_be_empty
    errors.add(:hash_field, "can't be empty") if !hash_field.nil? && hash_field.keys.length == 0
  end

  def symbol_field_cannot_be_short
    errors.add(:symbol_field, "can't be short") if !symbol_field.nil? && symbol_field.length < 2
  end

  def trueclass_field_cannot_be_false
    errors.add(:trueclass_field, "can't be false") if trueclass_field == false
  end

  def falseclass_field_cannot_be_true
    errors.add(:falseclass_field, "can't be true") if falseclass_field == true
  end
end

describe 'be_valid_when' do
  let(:model) { FakeModelFoo.new }

  def invalid_values_for(type_name)
    { integer: 42, bignum: 42**42, float: 3.14, complex: 42.to_c, rational: 42.to_r,
      bigdecimal: BigDecimal.new('42'), string: 'value', regexp: /^value$/, array: [1, 2],
      hash: {}, symbol: :value
    }.reject do |key|
      if type_name.is_a? Symbol
        key == type_name
      else
        type_name.include? key
      end
    end
  end

  {
    numeric: {
      argument: { passing: 50, failing: 40 },
      description: {
        no_arguments: /^be valid when #numeric_field is a numeric \(42\)$/,
        one_argument: /^be valid when #numeric_field is a numeric \(50\)$/
      },
      treat_as: [:integer, :bignum, :float, :complex, :rational, :bigdecimal]
    },
    integer: {
      argument: { passing: 50, failing: 40 },
      description: {
        no_arguments: /^be valid when #integer_field is a integer \(42\)$/,
        one_argument: /^be valid when #integer_field is a integer \(50\)$/
      },
      treat_as: [:integer, :bignum]
    },
    fixnum: {
      argument: { passing: 50, failing: 40 },
      description: {
        no_arguments: /^be valid when #fixnum_field is a fixnum \(42\)$/,
        one_argument: /^be valid when #fixnum_field is a fixnum \(50\)$/
      },
      treat_as: :integer
    },
    bignum: {
      argument: { passing: 2232232135326160725639168, failing: 30129469486639681536 },
      description: {
        no_arguments: /^be valid when #bignum_field is a bignum \(1265437718438866624512\)$/,
        one_argument: /^be valid when #bignum_field is a bignum \(2232232135326160725639168\)$/
      }
    },
    float: {
      argument: { passing: 4.2, failing: 2.4 },
      description: {
        no_arguments: /^be valid when #float_field is a float \(3.141592653589793\)$/,
        one_argument: /^be valid when #float_field is a float \(4.2\)$/
      }
    },
    complex: {
      argument: { passing: 50.to_c, failing: 40.to_c },
      description: {
        no_arguments: /^be valid when #complex_field is a complex \(42\+0i\)$/,
        one_argument: /^be valid when #complex_field is a complex \(50\+0i\)$/
      }
    },
    rational: {
      argument: { passing: 50.to_r, failing: 40.to_r },
      description: {
        no_arguments: %r{^be valid when #rational_field is a rational \(42/1\)$},
        one_argument: %r{^be valid when #rational_field is a rational \(50/1\)$}
      }
    },
    bigdecimal: {
      argument: { passing: BigDecimal.new('50'), failing: BigDecimal.new('40') },
      description: {
        no_arguments: /^be valid when #bigdecimal_field is a bigdecimal \(0.42E2\)$/,
        one_argument: /^be valid when #bigdecimal_field is a bigdecimal \(0.5E2\)$/
      }
    },
    string: {
      argument: { passing: 'some string', failing: 'a' },
      description: {
        no_arguments: /^be valid when #string_field is a string \("value"\)$/,
        one_argument: /^be valid when #string_field is a string \("some string"\)$/
      }
    },
    regexp: {
      argument: { passing: /some regexp/, failing: // },
      description: {
        no_arguments: %r{^be valid when #regexp_field is a regexp \(/\^value\$/\)$},
        one_argument: %r{^be valid when #regexp_field is a regexp \(/some regexp/\)$}
      }
    },
    array: {
      argument: { passing: [1, 2], failing: [] },
      description: {
        no_arguments: /^be valid when #array_field is a array \(\[42\]\)$/,
        one_argument: /^be valid when #array_field is a array \(\[1, 2\]\)$/
      }
    },
    hash: {
      argument: { passing: { a: 1 }, failing: {} },
      description: {
        no_arguments: /^be valid when #hash_field is a hash \(\{:value=>42\}\)$/,
        one_argument: /^be valid when #hash_field is a hash \({:a=>1\}\)$/
      }
    },
    symbol: {
      argument: { passing: :some_symbol, failing: :a },
      description: {
        no_arguments: /^be valid when #symbol_field is a symbol \(:value\)$/,
        one_argument: /^be valid when #symbol_field is a symbol \(:some_symbol\)$/
      }
    }
  }.each do |name, props|
    method_name    = "is_#{name}".to_sym
    field_name     = "#{name}_field".to_sym
    not_field_name = "not_#{field_name}".to_sym

    context "#is_#{name}" do
      context 'with no arguments' do
        let(:passing_matcher) { be_valid_when(field_name).send(method_name) }
        let(:failing_matcher) { be_valid_when(not_field_name).send(method_name) }

        include_examples 'returns proper results'

        include_examples 'has correct description' do
          let(:matcher) { passing_matcher }
          let(:description) { props[:description][:no_arguments] }
        end
      end

      context 'with one argument' do
        let(:passing_matcher) do
          be_valid_when(field_name).send(method_name, props[:argument][:passing])
        end
        let(:failing_matcher) do
          be_valid_when(field_name).send(method_name, props[:argument][:failing])
        end

        include_examples 'returns proper results'

        include_examples 'has correct description' do
          let(:matcher) { passing_matcher }
          let(:description) { props[:description][:one_argument] }
        end

        it "should fail if passed non #{name}" do
          invalid_values_for(props[:treat_as] ? props[:treat_as] : name.to_sym).each do |_, value|
            expect do
              be_valid_when(field_name).send(method_name, value)
            end.to raise_error ArgumentError
          end
        end
      end
    end
  end

  context '#is_true' do
    let(:passing_matcher) { be_valid_when(:trueclass_field).is_true }
    let(:failing_matcher) { be_valid_when(:not_trueclass_field).is_true }

    include_examples 'returns proper results'

    include_examples 'has correct description' do
      let(:matcher) { passing_matcher }
      let(:description) { /^be valid when #trueclass_field is true \(true\)$/ }
    end
  end

  context '#is_false' do
    let(:passing_matcher) { be_valid_when(:falseclass_field).is_false }
    let(:failing_matcher) { be_valid_when(:not_falseclass_field).is_false }

    include_examples 'returns proper results'

    include_examples 'has correct description' do
      let(:matcher) { passing_matcher }
      let(:description) { /^be valid when #falseclass_field is false \(false\)$/ }
    end
  end
end
