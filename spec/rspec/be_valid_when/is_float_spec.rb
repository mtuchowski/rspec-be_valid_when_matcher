describe 'be_valid_when#is_float' do
  context 'with one argument' do
    it 'should fail if passed non float' do
      expect { be_valid_when(:float_field).is_float 42 }.to raise_error ArgumentError
      expect { be_valid_when(:float_field).is_float 42**42 }.to raise_error ArgumentError
      expect { be_valid_when(:float_field).is_float 42.to_c }.to raise_error ArgumentError
      expect { be_valid_when(:float_field).is_float 42.to_r }.to raise_error ArgumentError
      expect { be_valid_when(:float_field).is_float BigDecimal.new }.to raise_error ArgumentError
      expect { be_valid_when(:float_field).is_float 'value' }.to raise_error ArgumentError
      expect { be_valid_when(:float_field).is_float '42' }.to raise_error ArgumentError
      expect { be_valid_when(:float_field).is_float(/^value$/) }.to raise_error ArgumentError
      expect { be_valid_when(:float_field).is_float [1, 2] }.to raise_error ArgumentError
      expect { be_valid_when(:float_field).is_float({}) }.to raise_error ArgumentError
      expect { be_valid_when(:float_field).is_float :value }.to raise_error ArgumentError
    end
  end
end
