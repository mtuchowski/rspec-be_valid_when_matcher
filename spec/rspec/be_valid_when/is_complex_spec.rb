require 'active_model'

# @private
class FakeModel
  include ActiveModel::Validations

  attr_accessor :complex_field
  attr_accessor :not_complex_field

  validates_numericality_of :complex_field, greater_than: 41
  validate :not_complex_field_cannot_be_complex

  private

  def not_complex_field_cannot_be_complex
    errors.add(:not_complex_field, "can't be complex") if not_complex_field.is_a? Complex
  end
end

describe 'be_valid_when#is_complex' do
  let(:model) { FakeModel.new }

  context 'with no arguments' do
    let(:description) { /^be valid when #complex_field is a complex \(42\+0i\)$/ }

    let(:passing_matcher) { be_valid_when(:complex_field).is_complex }
    let(:failing_matcher) { be_valid_when(:not_complex_field).is_complex }

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
    let(:description) { /^be valid when #complex_field is a complex \(50\+0i\)$/ }

    let(:passing_matcher) { be_valid_when(:complex_field).is_complex 50.to_c }
    let(:failing_matcher) { be_valid_when(:complex_field).is_complex 40.to_c }

    it 'has the correct description' do
      expect(passing_matcher.description).to match description
    end

    it 'returns proper result' do
      expect(passing_matcher.matches? model).to eq true
      expect(passing_matcher.does_not_match? model).to eq false
      expect(failing_matcher.matches? model).to eq false
      expect(failing_matcher.does_not_match? model).to eq true
    end

    it 'should fail if passed non complex' do
      expect { be_valid_when(:complex_field).is_complex 'value' }.to raise_error ArgumentError
      expect { be_valid_when(:complex_field).is_complex '42' }.to raise_error ArgumentError
      expect { be_valid_when(:complex_field).is_complex 42 }.to raise_error ArgumentError
      expect { be_valid_when(:complex_field).is_complex 42**42 }.to raise_error ArgumentError
      expect { be_valid_when(:complex_field).is_complex 3.14 }.to raise_error ArgumentError
      expect { be_valid_when(:complex_field).is_complex :value }.to raise_error ArgumentError
    end
  end
end
