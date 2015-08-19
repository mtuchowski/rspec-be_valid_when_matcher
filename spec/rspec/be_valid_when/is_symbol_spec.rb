require 'active_model'

# @private
class FakeModel
  include ActiveModel::Validations

  attr_accessor :symbol_field
  attr_accessor :not_symbol_field

  validate :symbol_field_should_be_symbol,
           :symbol_field_cannot_be_short,
           :not_symbol_field_cannot_be_symbol

  private

  def symbol_field_should_be_symbol
    errors.add(:symbol_field, 'should be symbol') unless symbol_field.is_a? Symbol
  end

  def symbol_field_cannot_be_short
    errors.add(:symbol_field, "can't be short") if !symbol_field.nil? && symbol_field.length < 2
  end

  def not_symbol_field_cannot_be_symbol
    errors.add(:not_symbol_field, "can't be symbol") if not_symbol_field.is_a? Symbol
  end
end

describe 'be_valid_when#is_symbol' do
  let(:model) { FakeModel.new }

  context 'with no arguments' do
    let(:description) { /^be valid when #symbol_field is a symbol \(:value\)$/ }

    let(:passing_matcher) { be_valid_when(:symbol_field).is_symbol }
    let(:failing_matcher) { be_valid_when(:not_symbol_field).is_symbol }

    it 'has the correct description' do
      expect(passing_matcher.description).to match description
    end

    it 'returns proper result' do
      expect(passing_matcher.matches? model).to eq true
      expect(passing_matcher.does_not_match? model).to eq false
      expect(failing_matcher.matches? model).to eq false
      expect(failing_matcher.does_not_match? model).to eq true
    end
  end

  context 'with one argument' do
    let(:description) { /^be valid when #symbol_field is a symbol \(:some_symbol\)$/ }

    let(:passing_matcher) { be_valid_when(:symbol_field).is_symbol :some_symbol }
    let(:failing_matcher) { be_valid_when(:symbol_field).is_symbol :a }

    it 'has the correct description' do
      expect(passing_matcher.description).to match description
    end

    it 'returns proper result' do
      expect(passing_matcher.matches? model).to eq true
      expect(passing_matcher.does_not_match? model).to eq false
      expect(failing_matcher.matches? model).to eq false
      expect(failing_matcher.does_not_match? model).to eq true
    end

    it 'should fail if passed non symbol' do
      expect { be_valid_when(:symbol_field).is_symbol 42 }.to raise_error ArgumentError
      expect { be_valid_when(:symbol_field).is_symbol 42**42 }.to raise_error ArgumentError
      expect { be_valid_when(:symbol_field).is_symbol 3.14 }.to raise_error ArgumentError
      expect { be_valid_when(:symbol_field).is_symbol 42.to_c }.to raise_error ArgumentError
      expect { be_valid_when(:symbol_field).is_symbol 42.to_r }.to raise_error ArgumentError
      expect { be_valid_when(:symbol_field).is_symbol 'value' }.to raise_error ArgumentError
      expect { be_valid_when(:symbol_field).is_symbol '42' }.to raise_error ArgumentError
      expect { be_valid_when(:symbol_field).is_symbol(/^value$/) }.to raise_error ArgumentError
      expect { be_valid_when(:symbol_field).is_symbol [1, 2] }.to raise_error ArgumentError
      expect { be_valid_when(:symbol_field).is_symbol({}) }.to raise_error ArgumentError
    end
  end
end
