require 'active_model'

# @private
class FakeModel
  include ActiveModel::Validations

  attr_accessor :rational_field
  attr_accessor :not_rational_field

  validates_numericality_of :rational_field, greater_than: 40
  validate :not_rational_field_cannot_be_rational

  private

  def not_rational_field_cannot_be_rational
    errors.add(:not_rational_field, "can't be rational") if not_rational_field.is_a? Rational
  end
end

describe 'be_valid_when#is_rational' do
  let(:model) { FakeModel.new }

  context 'with no arguments' do
    let(:description) { %r{^be valid when #rational_field is a rational \(42/1\)$} }

    let(:passing_matcher) { be_valid_when(:rational_field).is_rational }
    let(:failing_matcher) { be_valid_when(:not_rational_field).is_rational }

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
    let(:description) { %r{^be valid when #rational_field is a rational \(50/1\)$} }

    let(:passing_matcher) { be_valid_when(:rational_field).is_rational 50.to_r }
    let(:failing_matcher) { be_valid_when(:rational_field).is_rational 30.to_r }

    it 'has the correct description' do
      expect(passing_matcher.description).to match description
    end

    it 'returns proper result' do
      expect(passing_matcher.matches? model).to eq true
      expect(passing_matcher.does_not_match? model).to eq false
      expect(failing_matcher.matches? model).to eq false
      expect(failing_matcher.does_not_match? model).to eq true
    end

    it 'should fail if passed non rational' do
      expect { be_valid_when(:rational_field).is_rational 'value' }.to raise_error ArgumentError
      expect { be_valid_when(:rational_field).is_rational '42' }.to raise_error ArgumentError
      expect { be_valid_when(:rational_field).is_rational 3.14 }.to raise_error ArgumentError
      expect { be_valid_when(:rational_field).is_rational 42**42 }.to raise_error ArgumentError
      expect { be_valid_when(:rational_field).is_rational 42.to_c }.to raise_error ArgumentError
      expect { be_valid_when(:rational_field).is_rational :value }.to raise_error ArgumentError
    end
  end
end
