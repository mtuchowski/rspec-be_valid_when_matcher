RSpec.shared_examples 'returns proper results' do
  it 'returns proper result' do
    expect(passing_matcher.matches? model).to eq true
    expect(passing_matcher.does_not_match? model).to eq false
    expect(failing_matcher.matches? model).to eq false
    expect(failing_matcher.does_not_match? model).to eq true
  end
end
