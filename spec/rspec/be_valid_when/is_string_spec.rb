describe 'be_valid_when#is_string' do
  context 'with one argument' do
    it 'should fail if passed non string' do
      expect { be_valid_when(:string_field).is_string 42 }.to raise_error ArgumentError
      expect { be_valid_when(:string_field).is_string 42**42 }.to raise_error ArgumentError
      expect { be_valid_when(:string_field).is_string 3.14 }.to raise_error ArgumentError
      expect { be_valid_when(:string_field).is_string 42.to_c }.to raise_error ArgumentError
      expect { be_valid_when(:string_field).is_string 42.to_r }.to raise_error ArgumentError
      expect { be_valid_when(:string_field).is_string(/^value$/) }.to raise_error ArgumentError
      expect { be_valid_when(:string_field).is_string [1, 2] }.to raise_error ArgumentError
      expect { be_valid_when(:string_field).is_string({}) }.to raise_error ArgumentError
      expect { be_valid_when(:string_field).is_string :value }.to raise_error ArgumentError
    end
  end
end
