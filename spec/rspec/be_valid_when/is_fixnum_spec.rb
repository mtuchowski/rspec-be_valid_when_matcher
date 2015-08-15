require 'active_model'

# @private
class FakeModel
  include ActiveModel::Validations

  attr_accessor :fixnum_field
  attr_accessor :not_fixnum_field

  validates_numericality_of :fixnum_field, greater_than: 40
  validates_length_of :not_fixnum_field, minimum: 31

  validate :fixnum_field_should_be_a_fixnum

  private

  def fixnum_field_should_be_a_fixnum
    return unless fixnum_field.present? && !(fixnum_field.is_a? Fixnum)

    errors.add(:expiration_date, 'must be a Fixnum')
  end
end

describe 'be_valid_when#is_fixnum' do
  let(:model) { FakeModel.new }

  context 'with no arguments' do
    let(:description) { /^be valid when #fixnum_field is a fixnum \(42\)$/ }

    let(:passing_matcher) { be_valid_when(:fixnum_field).is_fixnum }
    let(:failing_matcher) { be_valid_when(:not_fixnum_field).is_fixnum }

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
    let(:description) { /^be valid when #fixnum_field is a fixnum \(50\)$/ }

    let(:passing_matcher) { be_valid_when(:fixnum_field).is_fixnum 50 }
    let(:failing_matcher) { be_valid_when(:fixnum_field).is_fixnum 30 }

    it 'has the correct description' do
      expect(passing_matcher.description).to match description
    end

    it 'returns proper result' do
      expect(passing_matcher.matches? model).to eq true
      expect(passing_matcher.does_not_match? model).to eq false
      expect(failing_matcher.matches? model).to eq false
      expect(failing_matcher.does_not_match? model).to eq true
    end

    it 'should fail if passed non fixnum' do
      expect { be_valid_when(:fixnum_field).is_fixnum 'value' }.to raise_error ArgumentError
      expect { be_valid_when(:fixnum_field).is_fixnum '42' }.to raise_error ArgumentError
      expect { be_valid_when(:fixnum_field).is_fixnum 3.14 }.to raise_error ArgumentError
      expect { be_valid_when(:fixnum_field).is_fixnum :value }.to raise_error ArgumentError
    end
  end
end
