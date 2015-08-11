require 'active_model'

# @private
class FakeModel
  include ActiveModel::Validations

  attr_accessor :field
  attr_accessor :other_field

  validates :field, presence: true
  validates :other_field, presence: true
end

describe 'be_valid_when' do
  # Declarations

  let(:model) { FakeModel.new }

  # General specs

  context 'matcher' do
    subject { be_valid_when :field }

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
      expect { be_valid_when }.to raise_error ArgumentError
    end

    it 'is expected to bo a symbol' do
      expect { be_valid_when 42 }.to raise_error ArgumentError
      expect { be_valid_when :field }.not_to raise_error
    end

    context 'when is the only argument provided' do
      subject { be_valid_when :field }

      it 'should fail on #matches?' do
        expect { subject.matches? model }.to raise_error ArgumentError
      end

      it 'should fail on #does_not_match?' do
        expect { subject.does_not_match? model }.to raise_error ArgumentError
      end

      it 'should fail on #failure_message' do
        expect { subject.failure_message }.to raise_error ArgumentError
      end

      it 'should fail on #failure_message_when_negated' do
        expect { subject.failure_message_when_negated }.to raise_error ArgumentError
      end

      it 'should fail on #description' do
        expect { subject.description }.to raise_error ArgumentError
      end
    end
  end

  context 'field value argument' do
    it 'can be specified when declating matcher' do
      expect { be_valid_when :field, 'value' }.not_to raise_error
    end

    context 'if provided' do
      subject { be_valid_when :field, 'value' }

      it 'should not fail on #matches?' do
        expect { subject.matches? model }.not_to raise_error
      end

      it 'should not fail on #does_not_match?' do
        expect { subject.does_not_match? model }.not_to raise_error
      end
    end
  end

  context 'custom message argument' do
    it 'can be specified when declating matcher' do
      expect { be_valid_when :field, 'value', 'some text' }.not_to raise_error
    end

    context 'if provided' do
      subject { be_valid_when :field, 'value', 'some text' }

      it 'should not fail on #matches?' do
        expect { subject.matches? model }.not_to raise_error
      end

      it 'should not fail on #does_not_match?' do
        expect { subject.does_not_match? model }.not_to raise_error
      end
    end
  end

  it 'should not accept more arguments than field symbol, field value and custom message' do
    expect { be_valid_when :field, 'value', 'some text', 'other arg' }.to raise_error ArgumentError
  end

  # General matching interface specs

  context 'if not provided with model to match' do
    subject { be_valid_when :field, 'value' }

    it 'should fail on #matches?' do
      expect { subject.matches? }.to raise_error ArgumentError
    end

    it 'should fail on #does_not_match?' do
      expect { subject.does_not_match? }.to raise_error ArgumentError
    end

    it 'should fail on #failure_message' do
      expect { subject.failure_message }.to raise_error ArgumentError
    end

    it 'should fail on #failure_message_when_negated' do
      expect { subject.failure_message_when_negated }.to raise_error ArgumentError
    end
  end

  context '#is method' do
    it 'should fail if no arguments given' do
      expect { be_valid_when(:field).is }.to raise_error ArgumentError
    end

    context 'when given one argument' do
      subject { be_valid_when(:field).is('value') }

      it 'sets the field value' do
        expect { subject.matches? model }.not_to raise_error
        expect { subject.does_not_match? model }.not_to raise_error
        expect { subject.description }.not_to raise_error
      end
    end

    context 'when given two arguments' do
      subject { be_valid_when(:field).is('value', 'some text') }

      it 'sets the custom message with first argument' do
        skip 'tested under failure message and description specs'
      end

      it 'sets the field value with the second argument' do
        expect { subject.matches? model }.not_to raise_error
        expect { subject.does_not_match? model }.not_to raise_error
        expect { subject.description }.not_to raise_error
      end
    end

    it 'should fail if more that two arguments given' do
      expect { be_valid_when(:field).is('one', 'two', 'three') }.to raise_error ArgumentError
    end
  end

  context 'when asserting validity of model' do
    subject { be_valid_when :field }

    context 'using #matches?' do
      it 'is setting the proper field using the provided value' do
        model.field = nil
        subject.is('value').matches? model
        expect(model.field).to eq 'value'
      end

      it 'returns proper result' do
        expect(subject.is('value').matches? model).to eq true
        expect(subject.is(nil).matches? model).to eq false
      end
    end

    context 'using #does_not_match?' do
      it 'is setting the proper field using the provided value' do
        model.field = nil
        subject.is('value').does_not_match? model
        expect(model.field).to eq 'value'
      end

      it 'returns proper result' do
        expect(subject.is('value').does_not_match? model).to eq false
        expect(subject.is(nil).does_not_match? model).to eq true
      end
    end
  end

  # Message methods specs

  context 'failure message' do
    context 'without custom message' do
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

    context 'with custom message' do
      subject { be_valid_when(:field).is('value', 'some text') }

      let(:message_regex) { /^expected #<.*> to be valid when #field is some text \("value"\)$/ }

      it 'provides subject model, field name and field value' do
        subject.matches?(model)
        expect(subject.failure_message).to match message_regex
      end

      context 'when negated' do
        let(:negated_message_regex) do
          /^expected #<.*> not to be valid when #field is some text \("value"\)$/
        end

        it 'provides subject model, field name and field value' do
          subject.does_not_match?(model)
          expect(subject.failure_message_when_negated).to match negated_message_regex
        end
      end
    end
  end

  context 'description' do
    context 'without custom message' do
      subject { be_valid_when :field, 'value' }

      let(:description_regex) { /^be valid when #field is "value"$/ }

      it 'provides field name and field value' do
        expect(subject.description).to match description_regex
      end
    end

    context 'with custom message' do
      subject { be_valid_when(:field).is('value', 'some text') }

      let(:description_regex) { /^be valid when #field is some text \("value"\)$/ }

      it 'provides field name and field value' do
        expect(subject.description).to match description_regex
      end
    end
  end
end
