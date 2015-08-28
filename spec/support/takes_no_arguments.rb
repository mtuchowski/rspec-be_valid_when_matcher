RSpec.shared_examples 'takes no arguments' do |field, matcher_name|
  it 'does not accept any arguments' do
    expect { be_valid_when(field).send(matcher_name, nil) }.to raise_error ArgumentError
    expect { be_valid_when(field).send(matcher_name, 'string') }.to raise_error ArgumentError
    expect { be_valid_when(field).send(matcher_name, 42) }.to raise_error ArgumentError
  end
end
