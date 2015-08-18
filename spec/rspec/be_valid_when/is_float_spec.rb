require 'active_model'

# @private
class FakeModel
  include ActiveModel::Validations

  attr_accessor :float_field
  attr_accessor :not_float_field

  validates_numericality_of :float_field, greater_than: 3.0
  validate :not_float_field_cannot_be_float

  private

  def not_float_field_cannot_be_float
    errors.add(:not_float_field, "can't be float") if not_float_field.is_a? Float
  end
end

describe 'be_valid_when#is_float' do
  let(:model) { FakeModel.new }

  context 'with no arguments' do
    let(:description) { /^be valid when #float_field is a float \(3.141592653589793\)$/ }

    let(:passing_matcher) { be_valid_when(:float_field).is_float }
    let(:failing_matcher) { be_valid_when(:not_float_field).is_float }

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
    let(:description) { /^be valid when #float_field is a float \(4.2\)$/ }

    let(:passing_matcher) { be_valid_when(:float_field).is_float 4.2 }
    let(:failing_matcher) { be_valid_when(:float_field).is_float 2.4 }

    it 'has the correct description' do
      expect(passing_matcher.description).to match description
    end

    it 'returns proper result' do
      expect(passing_matcher.matches? model).to eq true
      expect(passing_matcher.does_not_match? model).to eq false
      expect(failing_matcher.matches? model).to eq false
      expect(failing_matcher.does_not_match? model).to eq true
    end

    it 'should fail if passed non float' do
      expect { be_valid_when(:float_field).is_float 42 }.to raise_error ArgumentError
      expect { be_valid_when(:float_field).is_float 42**42 }.to raise_error ArgumentError
      expect { be_valid_when(:float_field).is_float 42.to_c }.to raise_error ArgumentError
      expect { be_valid_when(:float_field).is_float 42.to_r }.to raise_error ArgumentError
      expect { be_valid_when(:float_field).is_float BigDecimal.new }.to raise_error ArgumentError
      expect { be_valid_when(:float_field).is_float 'value' }.to raise_error ArgumentError
      expect { be_valid_when(:float_field).is_float '42' }.to raise_error ArgumentError
      expect { be_valid_when(:float_field).is_float(/^value$/) }.to raise_error ArgumentError
      expect { be_valid_when(:float_field).is_float [1, 2] }.to raise_error ArgumentError
      expect { be_valid_when(:float_field).is_float({}) }.to raise_error ArgumentError
      expect { be_valid_when(:float_field).is_float :value }.to raise_error ArgumentError
    end
  end
end
