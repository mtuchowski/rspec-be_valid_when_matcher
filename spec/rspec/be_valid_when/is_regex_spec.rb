require 'active_model'

# @private
class FakeModel
  include ActiveModel::Validations

  attr_accessor :regexp_field
  attr_accessor :not_regexp_field

  validate :regexp_field_should_be_regexp,
           :regexp_field_cannot_be_empty,
           :not_regexp_field_cannot_be_regexp

  private

  def regexp_field_should_be_regexp
    errors.add(:regexp_field, 'should be regexp') unless regexp_field.is_a? Regexp
  end

  def regexp_field_cannot_be_empty
    errors.add(:regexp_field, "can't be empty") if regexp_field.inspect.length < 3
  end

  def not_regexp_field_cannot_be_regexp
    errors.add(:not_regexp_field, "can't be regexp") if not_regexp_field.is_a? Regexp
  end
end

describe 'be_valid_when#is_regexp' do
  let(:model) { FakeModel.new }

  context 'with no arguments' do
    let(:description) { %r{^be valid when #regexp_field is a regexp \(/\^value\$/\)$} }

    let(:passing_matcher) { be_valid_when(:regexp_field).is_regexp }
    let(:failing_matcher) { be_valid_when(:not_regexp_field).is_regexp }

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
    let(:description) { %r{^be valid when #regexp_field is a regexp \(/some regexp/\)$} }

    let(:passing_matcher) { be_valid_when(:regexp_field).is_regexp(/some regexp/) }
    let(:failing_matcher) { be_valid_when(:regexp_field).is_regexp(//) }

    it 'has the correct description' do
      expect(passing_matcher.description).to match description
    end

    it 'returns proper result' do
      expect(passing_matcher.matches? model).to eq true
      expect(passing_matcher.does_not_match? model).to eq false
      expect(failing_matcher.matches? model).to eq false
      expect(failing_matcher.does_not_match? model).to eq true
    end

    it 'should fail if passed non regexp' do
      expect { be_valid_when(:regexp_field).is_regexp 42 }.to raise_error ArgumentError
      expect { be_valid_when(:regexp_field).is_regexp 42**42 }.to raise_error ArgumentError
      expect { be_valid_when(:regexp_field).is_regexp 3.14 }.to raise_error ArgumentError
      expect { be_valid_when(:regexp_field).is_regexp 42.to_c }.to raise_error ArgumentError
      expect { be_valid_when(:regexp_field).is_regexp 42.to_r }.to raise_error ArgumentError
      expect { be_valid_when(:regexp_field).is_regexp 'value' }.to raise_error ArgumentError
      expect { be_valid_when(:regexp_field).is_regexp '42' }.to raise_error ArgumentError
      expect { be_valid_when(:regexp_field).is_regexp [1, 2] }.to raise_error ArgumentError
      expect { be_valid_when(:regexp_field).is_regexp({}) }.to raise_error ArgumentError
      expect { be_valid_when(:regexp_field).is_regexp :value }.to raise_error ArgumentError
    end
  end
end
