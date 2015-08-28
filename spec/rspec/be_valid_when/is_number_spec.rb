describe 'be_valid_when#is_number' do
  context 'with one argument' do
    it 'should fail if passed non number' do
      expect { be_valid_when(:number_field).is_number 'value' }.to raise_error ArgumentError
      expect { be_valid_when(:number_field).is_number '42' }.to raise_error ArgumentError
      expect { be_valid_when(:number_field).is_number(/^value$/) }.to raise_error ArgumentError
      expect { be_valid_when(:number_field).is_number [1, 2] }.to raise_error ArgumentError
      expect { be_valid_when(:number_field).is_number({}) }.to raise_error ArgumentError
      expect { be_valid_when(:number_field).is_number :value }.to raise_error ArgumentError
    end
  end
end
