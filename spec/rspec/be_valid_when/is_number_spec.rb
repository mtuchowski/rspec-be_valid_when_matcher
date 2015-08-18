require 'active_model'

# @private
class FakeModel
  include ActiveModel::Validations

  attr_accessor :number_field
  attr_accessor :not_number_field

  validates_numericality_of :number_field, greater_than: 40
  validates_length_of :not_number_field, minimum: 31
end

describe 'be_valid_when#is_number' do
  let(:model) { FakeModel.new }

  context 'with no arguments' do
    let(:description) { /^be valid when #number_field is a number \(42\)$/ }

    let(:passing_matcher) { be_valid_when(:number_field).is_number }
    let(:failing_matcher) { be_valid_when(:not_number_field).is_number }

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
    let(:description) { /^be valid when #number_field is a number \(50\)$/ }

    let(:passing_matcher) { be_valid_when(:number_field).is_number 50 }
    let(:failing_matcher) { be_valid_when(:number_field).is_number 30 }

    it 'has the correct description' do
      expect(passing_matcher.description).to match description
    end

    it 'returns proper result' do
      expect(passing_matcher.matches? model).to eq true
      expect(passing_matcher.does_not_match? model).to eq false
      expect(failing_matcher.matches? model).to eq false
      expect(failing_matcher.does_not_match? model).to eq true
    end

    it 'should fail if passed non number' do
      expect { be_valid_when(:number_field).is_number 'value' }.to raise_error ArgumentError
      expect { be_valid_when(:number_field).is_number '42' }.to raise_error ArgumentError
      expect { be_valid_when(:number_field).is_number(/^value$/) }.to raise_error ArgumentError
      expect { be_valid_when(:number_field).is_number [1, 2] }.to raise_error ArgumentError
      expect { be_valid_when(:number_field).is_number({}) }.to raise_error ArgumentError
      expect { be_valid_when(:number_field).is_number :value }.to raise_error ArgumentError
    end
  end
end
