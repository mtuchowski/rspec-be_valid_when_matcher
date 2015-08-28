describe 'be_valid_when#is_fixnum' do
  context 'with one argument' do
    it 'should fail if passed non fixnum' do
      expect { be_valid_when(:fixnum_field).is_fixnum 42**42 }.to raise_error ArgumentError
      expect { be_valid_when(:fixnum_field).is_fixnum 3.14 }.to raise_error ArgumentError
      expect { be_valid_when(:fixnum_field).is_fixnum 42.to_c }.to raise_error ArgumentError
      expect { be_valid_when(:fixnum_field).is_fixnum 42.to_r }.to raise_error ArgumentError
      expect { be_valid_when(:fixnum_field).is_fixnum BigDecimal.new }.to raise_error ArgumentError
      expect { be_valid_when(:fixnum_field).is_fixnum 'value' }.to raise_error ArgumentError
      expect { be_valid_when(:fixnum_field).is_fixnum '42' }.to raise_error ArgumentError
      expect { be_valid_when(:fixnum_field).is_fixnum(/^value$/) }.to raise_error ArgumentError
      expect { be_valid_when(:fixnum_field).is_fixnum [1, 2] }.to raise_error ArgumentError
      expect { be_valid_when(:fixnum_field).is_fixnum({}) }.to raise_error ArgumentError
      expect { be_valid_when(:fixnum_field).is_fixnum :value }.to raise_error ArgumentError
    end
  end
end
