RSpec.shared_examples 'has correct description' do
  it 'has the correct description' do
    expect(matcher.description).to match description
  end
end
