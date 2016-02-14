require 'active_model'

# @private
class FakeModel
  include ActiveModel::Validations

  attr_accessor :field

  validates_presence_of :field
end

RSpec.shared_examples 'sets the field value' do
  it 'sets the field value' do
    expect { subject.matches? model }.not_to raise_error
    expect { subject.does_not_match? model }.not_to raise_error

    expect(subject.matches?(model)).to eq true
    expect(subject.does_not_match?(model)).to eq false

    expect { subject.description }.not_to raise_error
  end
end

describe 'be_valid_when#is' do
  let(:model) { FakeModel.new }

  it 'should fail if no arguments given' do
    expect { be_valid_when(:field).is }.to raise_error ArgumentError
  end

  context 'when given one argument' do
    subject { be_valid_when(:field).is('value') }

    include_examples 'sets the field value'
  end

  context 'when given two arguments' do
    subject { be_valid_when(:field).is('value', 'some text') }

    let(:description_regex) { /^be valid when #field is some text \("value"\)$/ }
    let(:message_regex) do
      /^expected #<.*> to be valid when #field is some text \("value"\)$/
    end
    let(:negated_message_regex) do
      /^expected #<.*> not to be valid when #field is some text \("value"\)$/
    end

    include_examples 'sets the field value'

    it 'sets the custom message with second argument' do
      subject.matches? model

      expect(subject.description).to match description_regex
      expect(subject.failure_message).to match message_regex
      expect(subject.failure_message_when_negated).to match negated_message_regex
    end
  end

  it 'should fail if more that two arguments given' do
    expect { be_valid_when(:field).is('one', 'two', 'three') }.to raise_error ArgumentError
  end
end
