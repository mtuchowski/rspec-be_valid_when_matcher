require 'active_model'

# @private
class FakeModel
  include ActiveModel::Validations

  attr_accessor :bignum_field
  attr_accessor :not_bignum_field

  validates_numericality_of :bignum_field, greater_than: 30129469486639681537
  validates_length_of :not_bignum_field, minimum: 31
end

describe 'be_valid_when#is_bignum' do
  let(:model) { FakeModel.new }

  context 'with no arguments' do
    let(:description) { /^be valid when #bignum_field is a bignum \(1265437718438866624512\)$/ }

    let(:passing_matcher) { be_valid_when(:bignum_field).is_bignum }
    let(:failing_matcher) { be_valid_when(:not_bignum_field).is_bignum }

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
    let(:description) { /^be valid when #bignum_field is a bignum \(2232232135326160725639168\)$/ }

    let(:passing_matcher) { be_valid_when(:bignum_field).is_bignum 2232232135326160725639168 }
    let(:failing_matcher) { be_valid_when(:bignum_field).is_bignum 30129469486639681536 }

    it 'has the correct description' do
      expect(passing_matcher.description).to match description
    end

    it 'returns proper result' do
      expect(passing_matcher.matches? model).to eq true
      expect(passing_matcher.does_not_match? model).to eq false
      expect(failing_matcher.matches? model).to eq false
      expect(failing_matcher.does_not_match? model).to eq true
    end

    it 'should fail if passed non bignum' do
      expect { be_valid_when(:bignum_field).is_bignum 'value' }.to raise_error ArgumentError
      expect { be_valid_when(:bignum_field).is_bignum '42' }.to raise_error ArgumentError
      expect { be_valid_when(:bignum_field).is_bignum 42 }.to raise_error ArgumentError
      expect { be_valid_when(:bignum_field).is_bignum 3.14 }.to raise_error ArgumentError
      expect { be_valid_when(:bignum_field).is_bignum :value }.to raise_error ArgumentError
    end
  end
end
