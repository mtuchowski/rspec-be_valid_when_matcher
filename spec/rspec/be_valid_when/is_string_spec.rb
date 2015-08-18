require 'active_model'

# @private
class FakeModel
  include ActiveModel::Validations

  attr_accessor :string_field
  attr_accessor :not_string_field

  validates_length_of :string_field, minimum: 4
  validate :not_string_field_cannot_be_string

  private

  def not_string_field_cannot_be_string
    errors.add(:not_string_field, "can't be string") if not_string_field.is_a? String
  end
end

describe 'be_valid_when#is_string' do
  let(:model) { FakeModel.new }

  context 'with no arguments' do
    let(:description) { /^be valid when #string_field is a string \("value"\)$/ }

    let(:passing_matcher) { be_valid_when(:string_field).is_string }
    let(:failing_matcher) { be_valid_when(:not_string_field).is_string }

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
    let(:description) { /^be valid when #string_field is a string \("some string"\)$/ }

    let(:passing_matcher) { be_valid_when(:string_field).is_string 'some string' }
    let(:failing_matcher) { be_valid_when(:string_field).is_string 'a' }

    it 'has the correct description' do
      expect(passing_matcher.description).to match description
    end

    it 'returns proper result' do
      expect(passing_matcher.matches? model).to eq true
      expect(passing_matcher.does_not_match? model).to eq false
      expect(failing_matcher.matches? model).to eq false
      expect(failing_matcher.does_not_match? model).to eq true
    end

    it 'should fail if passed non string' do
      expect { be_valid_when(:string_field).is_string 42 }.to raise_error ArgumentError
      expect { be_valid_when(:string_field).is_string 42**42 }.to raise_error ArgumentError
      expect { be_valid_when(:string_field).is_string 3.14 }.to raise_error ArgumentError
      expect { be_valid_when(:string_field).is_string 42.to_c }.to raise_error ArgumentError
      expect { be_valid_when(:string_field).is_string 42.to_r }.to raise_error ArgumentError
      expect { be_valid_when(:string_field).is_string(/^value$/) }.to raise_error ArgumentError
      expect { be_valid_when(:string_field).is_string [1, 2] }.to raise_error ArgumentError
      expect { be_valid_when(:string_field).is_string({}) }.to raise_error ArgumentError
      expect { be_valid_when(:string_field).is_string :value }.to raise_error ArgumentError
    end
  end
end
