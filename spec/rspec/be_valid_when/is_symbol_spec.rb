describe 'be_valid_when#is_symbol' do
  context 'with one argument' do
    it 'should fail if passed non symbol' do
      expect { be_valid_when(:symbol_field).is_symbol 42 }.to raise_error ArgumentError
      expect { be_valid_when(:symbol_field).is_symbol 42**42 }.to raise_error ArgumentError
      expect { be_valid_when(:symbol_field).is_symbol 3.14 }.to raise_error ArgumentError
      expect { be_valid_when(:symbol_field).is_symbol 42.to_c }.to raise_error ArgumentError
      expect { be_valid_when(:symbol_field).is_symbol 42.to_r }.to raise_error ArgumentError
      expect { be_valid_when(:symbol_field).is_symbol 'value' }.to raise_error ArgumentError
      expect { be_valid_when(:symbol_field).is_symbol '42' }.to raise_error ArgumentError
      expect { be_valid_when(:symbol_field).is_symbol(/^value$/) }.to raise_error ArgumentError
      expect { be_valid_when(:symbol_field).is_symbol [1, 2] }.to raise_error ArgumentError
      expect { be_valid_when(:symbol_field).is_symbol({}) }.to raise_error ArgumentError
    end
  end
end
