require 'active_model'

# @private
class FakeModel
  include ActiveModel::Validations

  attr_accessor :array_field
  attr_accessor :not_array_field

  validate :array_field_should_be_array,
           :array_field_cannot_be_empty,
           :not_array_field_cannot_be_array

  private

  def array_field_should_be_array
    errors.add(:array_field, 'should be array') unless array_field.is_a? Array
  end

  def array_field_cannot_be_empty
    errors.add(:array_field, "can't be empty") if !array_field.nil? && array_field.length == 0
  end

  def not_array_field_cannot_be_array
    errors.add(:not_array_field, "can't be array") if not_array_field.is_a? Array
  end
end

describe 'be_valid_when#is_array' do
  let(:model) { FakeModel.new }

  context 'with no arguments' do
    let(:description) { /^be valid when #array_field is a array \(\[42\]\)$/ }

    let(:passing_matcher) { be_valid_when(:array_field).is_array }
    let(:failing_matcher) { be_valid_when(:not_array_field).is_array }

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
    let(:description) { /^be valid when #array_field is a array \(\[1, 2\]\)$/ }

    let(:passing_matcher) { be_valid_when(:array_field).is_array [1, 2] }
    let(:failing_matcher) { be_valid_when(:array_field).is_array [] }

    it 'has the correct description' do
      expect(passing_matcher.description).to match description
    end

    it 'returns proper result' do
      expect(passing_matcher.matches? model).to eq true
      expect(passing_matcher.does_not_match? model).to eq false
      expect(failing_matcher.matches? model).to eq false
      expect(failing_matcher.does_not_match? model).to eq true
    end

    it 'should fail if passed non array' do
      expect { be_valid_when(:array_field).is_array 42 }.to raise_error ArgumentError
      expect { be_valid_when(:array_field).is_array 42**42 }.to raise_error ArgumentError
      expect { be_valid_when(:array_field).is_array 3.14 }.to raise_error ArgumentError
      expect { be_valid_when(:array_field).is_array 42.to_c }.to raise_error ArgumentError
      expect { be_valid_when(:array_field).is_array 42.to_r }.to raise_error ArgumentError
      expect { be_valid_when(:array_field).is_array 'value' }.to raise_error ArgumentError
      expect { be_valid_when(:array_field).is_array '42' }.to raise_error ArgumentError
      expect { be_valid_when(:array_field).is_array(/^value$/) }.to raise_error ArgumentError
      expect { be_valid_when(:array_field).is_array({}) }.to raise_error ArgumentError
      expect { be_valid_when(:array_field).is_array :value }.to raise_error ArgumentError
    end
  end
end
