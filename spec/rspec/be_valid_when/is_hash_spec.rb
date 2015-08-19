require 'active_model'

# @private
class FakeModel
  include ActiveModel::Validations

  attr_accessor :hash_field
  attr_accessor :not_hash_field

  validate :hash_field_should_be_hash,
           :hash_field_cannot_be_empty,
           :not_hash_field_cannot_be_hash

  private

  def hash_field_should_be_hash
    errors.add(:hash_field, 'should be hash') unless hash_field.is_a? Hash
  end

  def hash_field_cannot_be_empty
    errors.add(:hash_field, "can't be empty") if !hash_field.nil? && hash_field.keys.length == 0
  end

  def not_hash_field_cannot_be_hash
    errors.add(:not_hash_field, "can't be hash") if not_hash_field.is_a? Hash
  end
end

describe 'be_valid_when#is_hash' do
  let(:model) { FakeModel.new }

  context 'with no arguments' do
    let(:description) { /^be valid when #hash_field is a hash \(\{:value=>42\}\)$/ }

    let(:passing_matcher) { be_valid_when(:hash_field).is_hash }
    let(:failing_matcher) { be_valid_when(:not_hash_field).is_hash }

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
    let(:description) { /^be valid when #hash_field is a hash \({:a=>1\}\)$/ }

    let(:passing_matcher) { be_valid_when(:hash_field).is_hash({ a: 1 }) }
    let(:failing_matcher) { be_valid_when(:hash_field).is_hash({}) }

    it 'has the correct description' do
      expect(passing_matcher.description).to match description
    end

    it 'returns proper result' do
      expect(passing_matcher.matches? model).to eq true
      expect(passing_matcher.does_not_match? model).to eq false
      expect(failing_matcher.matches? model).to eq false
      expect(failing_matcher.does_not_match? model).to eq true
    end

    it 'should fail if passed non hash' do
      expect { be_valid_when(:hash_field).is_hash 42 }.to raise_error ArgumentError
      expect { be_valid_when(:hash_field).is_hash 42**42 }.to raise_error ArgumentError
      expect { be_valid_when(:hash_field).is_hash 3.14 }.to raise_error ArgumentError
      expect { be_valid_when(:hash_field).is_hash 42.to_c }.to raise_error ArgumentError
      expect { be_valid_when(:hash_field).is_hash 42.to_r }.to raise_error ArgumentError
      expect { be_valid_when(:hash_field).is_hash 'value' }.to raise_error ArgumentError
      expect { be_valid_when(:hash_field).is_hash '42' }.to raise_error ArgumentError
      expect { be_valid_when(:hash_field).is_hash(/^value$/) }.to raise_error ArgumentError
      expect { be_valid_when(:hash_field).is_hash [1, 2] }.to raise_error ArgumentError
      expect { be_valid_when(:hash_field).is_hash :value }.to raise_error ArgumentError
    end
  end
end
