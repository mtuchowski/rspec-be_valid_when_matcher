require 'active_model'
require 'support/has_correct_description'
require 'support/returns_proper_results'
require 'support/takes_no_arguments'

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

  include_examples 'returns proper results'

  include_examples 'has correct description' do
    let(:matcher) { passing_matcher }
    let(:description) { /^be valid when #nil_field is not present \(nil\)$/ }
  end

  include_examples 'takes no arguments', :field, :is_not_present
end
