require 'active_model'

# @private
class FakeModel
  include ActiveModel::Validations

  attr_accessor :nil_field
  attr_accessor :not_nil_field

  validates_absence_of :nil_field
  validates_presence_of :not_nil_field
end

describe 'be_valid_when#is_not_present' do
  let(:model) { FakeModel.new }

  let(:passing_matcher) { be_valid_when(:nil_field).is_not_present }
  let(:failing_matcher) { be_valid_when(:not_nil_field).is_not_present }

  let(:description) { /^be valid when #nil_field is not present \(nil\)$/ }

  it 'has the correct description' do
    expect(passing_matcher.description).to match description
  end

  it 'returns proper result' do
    expect(passing_matcher.matches? model).to eq true
    expect(passing_matcher.does_not_match? model).to eq false
    expect(failing_matcher.matches? model).to eq false
    expect(failing_matcher.does_not_match? model).to eq true
  end

  it 'does not accept any arguments' do
    expect { be_valid_when(:field).is_not_present 'value' }.to raise_error ArgumentError
  end
end
