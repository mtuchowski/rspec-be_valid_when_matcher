describe 'be_valid_when#is_bignum' do
  context 'with one argument' do
    it 'should fail if passed non bignum' do
      expect { be_valid_when(:bignum_field).is_bignum 42 }.to raise_error ArgumentError
      expect { be_valid_when(:bignum_field).is_bignum 3.14 }.to raise_error ArgumentError
      expect { be_valid_when(:bignum_field).is_bignum 42.to_c }.to raise_error ArgumentError
      expect { be_valid_when(:bignum_field).is_bignum 42.to_r }.to raise_error ArgumentError
      expect { be_valid_when(:bignum_field).is_bignum BigDecimal.new }.to raise_error ArgumentError
      expect { be_valid_when(:bignum_field).is_bignum 'value' }.to raise_error ArgumentError
      expect { be_valid_when(:bignum_field).is_bignum '42' }.to raise_error ArgumentError
      expect { be_valid_when(:bignum_field).is_bignum(/^value$/) }.to raise_error ArgumentError
      expect { be_valid_when(:bignum_field).is_bignum [1, 2] }.to raise_error ArgumentError
      expect { be_valid_when(:bignum_field).is_bignum({}) }.to raise_error ArgumentError
      expect { be_valid_when(:bignum_field).is_bignum :value }.to raise_error ArgumentError
    end
  end
end
