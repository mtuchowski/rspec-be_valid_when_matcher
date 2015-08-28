describe 'be_valid_when#is_bigdecimal' do
  context 'with one argument' do
    it 'should fail if passed non bigdecimal' do
      expect { be_valid_when(:bigdecimal_field).is_bigdecimal 42 }.to raise_error ArgumentError
      expect { be_valid_when(:bigdecimal_field).is_bigdecimal 42**42 }.to raise_error ArgumentError
      expect { be_valid_when(:bigdecimal_field).is_bigdecimal 3.14 }.to raise_error ArgumentError
      expect do
        be_valid_when(:bigdecimal_field).is_bigdecimal 42.to_c
      end.to raise_error ArgumentError
      expect do
        be_valid_when(:bigdecimal_field).is_bigdecimal 42.to_r
      end.to raise_error ArgumentError
      expect do
        be_valid_when(:bigdecimal_field).is_bigdecimal 'value'
      end.to raise_error ArgumentError
      expect { be_valid_when(:bigdecimal_field).is_bigdecimal '42' }.to raise_error ArgumentError
      expect do
        be_valid_when(:bigdecimal_field).is_bigdecimal(/^value$/)
      end.to raise_error ArgumentError
      expect { be_valid_when(:bigdecimal_field).is_bigdecimal [1, 2] }.to raise_error ArgumentError
      expect { be_valid_when(:bigdecimal_field).is_bigdecimal({}) }.to raise_error ArgumentError
      expect { be_valid_when(:bigdecimal_field).is_bigdecimal :value }.to raise_error ArgumentError
    end
  end
end
