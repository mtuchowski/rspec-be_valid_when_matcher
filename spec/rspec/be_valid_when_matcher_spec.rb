require 'active_model'

# @private
class FakeModel
  include ActiveModel::Validations
  attr_accessor :field
  validates_presence_of :field
end

describe 'be_valid_when' do
  # Declarations

  let(:matcher) { be_valid_when :field, 'value' }
  let(:model)   { FakeModel.new }

  # General specs

  context 'matcher' do
    subject { matcher }

    it 'is expected to be of proper type' do
      expect(subject).to be_an_instance_of RSpec::BeValidWhenMatcher::BeValidWhen
    end

    it { is_expected.to respond_to :matches? }
    it { is_expected.to respond_to :does_not_match? }
    it { is_expected.to respond_to :failure_message }
    it { is_expected.to respond_to :failure_message_when_negated }
    it { is_expected.to respond_to :description }
    it { is_expected.to respond_to :diffable? }
    it { is_expected.to respond_to :supports_block_expectations? }

    it 'does not support diffing' do
      expect(subject.diffable?).to eq false
    end

    it 'does not support block expectations' do
      expect(subject.supports_block_expectations?).to eq false
    end
  end

  # Matcher arguments specs

  context 'field name argument' do
    it 'is expected to be provided' do
      expect { be_valid_when }.to raise_error(ArgumentError)
    end

    it 'is expected to bo a symbol' do
      expect { be_valid_when 42 }.to raise_error(ArgumentError)
    end
  end

  context 'field value argument' do
    it 'can be specified when declating matcher' do
      expect { be_valid_when :field, 'value' }.not_to raise_error
    end
  end

  it 'should not accept more arguments than field symbol and field value' do
    expect { be_valid_when :field, 'value', 'next value' }.to raise_error ArgumentError
  end

  # General matching interface specs

  context 'if not provided with model to match' do
    it 'should fail on #matches?' do
      expect { matcher.matches? }.to raise_error(ArgumentError)
    end

    it 'should fail on #does_not_match?' do
      expect { matcher.does_not_match? }.to raise_error(ArgumentError)
    end
  end

  context 'if only field symbol given' do
    subject { be_valid_when :field }

    it 'should fail on #matches?' do
      expect { subject.matches? model }.to raise_error(ArgumentError)
    end

    it 'should fail on #does_not_match?' do
      expect { subject.does_not_match? model }.to raise_error(ArgumentError)
    end
  end

  context 'if given field value on matcher declaration' do
    subject { be_valid_when :field, 'value' }

    it 'should not fail on #matches?' do
       expect { subject.matches? model }.not_to raise_error
    end

    it 'should not fail on #does_not_match?' do
       expect { subject.does_not_match? model }.not_to raise_error
    end
  end

  # Message methods specs

  context 'failure message' do
    subject { be_valid_when :field, 'value' }

    let(:message_regex) { /^expected #<.*> to be valid when #field is "value"$/ }

    it 'provides subject model, field name and field value' do
      subject.matches?(model)
      expect(subject.failure_message).to match message_regex
    end

    context 'when negated' do
      let(:negated_message_regex) { /^expected #<.*> not to be valid when #field is "value"$/ }

      it 'provides subject model, field name and field value' do
        subject.does_not_match?(model)
        expect(subject.failure_message_when_negated).to match negated_message_regex
      end
    end
  end

  context 'description' do
    let(:description_regex) { /^be valid when #field is "value"$/ }

    it 'provides field name and field value' do
      expect(matcher.description).to match description_regex
    end
  end

end
