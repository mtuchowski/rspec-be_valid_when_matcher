require 'active_model'
require 'bigdecimal'

# @private
class FakeModel
  include ActiveModel::Validations

  attr_accessor :bigdecimal_field
  attr_accessor :not_bigdec_field

  validates_numericality_of :bigdecimal_field, greater_than: 40
  validate :not_bigdec_field_cannot_be_bigdecimal

  private

  def not_bigdec_field_cannot_be_bigdecimal
    errors.add(:not_bigdec_field, "can't be bigdecimal") if not_bigdec_field.is_a? BigDecimal
  end
end

describe 'be_valid_when#is_bigdecimal' do
  let(:model) { FakeModel.new }

  context 'with no arguments' do
    let(:description) { /^be valid when #bigdecimal_field is a bigdecimal \(0.42E2\)$/ }

    let(:passing_matcher) { be_valid_when(:bigdecimal_field).is_bigdecimal }
    let(:failing_matcher) { be_valid_when(:not_bigdec_field).is_bigdecimal }

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
    let(:description) { /^be valid when #bigdecimal_field is a bigdecimal \(0.5E2\)$/ }

    let(:passing_matcher) { be_valid_when(:bigdecimal_field).is_bigdecimal BigDecimal.new('50') }
    let(:failing_matcher) { be_valid_when(:bigdecimal_field).is_bigdecimal BigDecimal.new('30') }

    it 'has the correct description' do
      expect(passing_matcher.description).to match description
    end

    it 'returns proper result' do
      expect(passing_matcher.matches? model).to eq true
      expect(passing_matcher.does_not_match? model).to eq false
      expect(failing_matcher.matches? model).to eq false
      expect(failing_matcher.does_not_match? model).to eq true
    end

    it 'should fail if passed non bigdecimal' do
      expect { be_valid_when(:bigdecimal_field).is_bigdecimal 42 }.to raise_error ArgumentError
      expect { be_valid_when(:bigdecimal_field).is_bigdecimal 42**42 }.to raise_error ArgumentError
      expect { be_valid_when(:bigdecimal_field).is_bigdecimal 3.14 }.to raise_error ArgumentError
      expect do
        be_valid_when(:bigdecimal_field).is_bigdecimal 42.to_c
      end.to raise_error ArgumentError
      expect do
        be_valid_when(:bigdecimal_field).is_bigdecimal 42.to_r
      end.to raise_error ArgumentError
      expect do
        be_valid_when(:bigdecimal_field).is_bigdecimal 'value'
      end.to raise_error ArgumentError
      expect { be_valid_when(:bigdecimal_field).is_bigdecimal '42' }.to raise_error ArgumentError
      expect do
        be_valid_when(:bigdecimal_field).is_bigdecimal(/^value$/)
      end.to raise_error ArgumentError
      expect { be_valid_when(:bigdecimal_field).is_bigdecimal [1, 2] }.to raise_error ArgumentError
      expect { be_valid_when(:bigdecimal_field).is_bigdecimal({}) }.to raise_error ArgumentError
      expect { be_valid_when(:bigdecimal_field).is_bigdecimal :value }.to raise_error ArgumentError
    end
  end
end
