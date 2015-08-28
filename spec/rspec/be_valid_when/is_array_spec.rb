describe 'be_valid_when#is_array' do
  context 'with one argument' do
    it 'should fail if passed non array' do
      expect { be_valid_when(:array_field).is_array 42 }.to raise_error ArgumentError
      expect { be_valid_when(:array_field).is_array 42**42 }.to raise_error ArgumentError
      expect { be_valid_when(:array_field).is_array 3.14 }.to raise_error ArgumentError
      expect { be_valid_when(:array_field).is_array 42.to_c }.to raise_error ArgumentError
      expect { be_valid_when(:array_field).is_array 42.to_r }.to raise_error ArgumentError
      expect { be_valid_when(:array_field).is_array 'value' }.to raise_error ArgumentError
      expect { be_valid_when(:array_field).is_array '42' }.to raise_error ArgumentError
      expect { be_valid_when(:array_field).is_array(/^value$/) }.to raise_error ArgumentError
      expect { be_valid_when(:array_field).is_array({}) }.to raise_error ArgumentError
      expect { be_valid_when(:array_field).is_array :value }.to raise_error ArgumentError
    end
  end
end
