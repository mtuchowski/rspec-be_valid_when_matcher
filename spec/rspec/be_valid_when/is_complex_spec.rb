describe 'be_valid_when#is_complex' do
  context 'with one argument' do
    it 'should fail if passed non complex' do
      expect { be_valid_when(:complex_field).is_complex 42 }.to raise_error ArgumentError
      expect { be_valid_when(:complex_field).is_complex 42**42 }.to raise_error ArgumentError
      expect { be_valid_when(:complex_field).is_complex 3.14 }.to raise_error ArgumentError
      expect { be_valid_when(:complex_field).is_complex 42.to_r }.to raise_error ArgumentError
      expect do
        be_valid_when(:complex_field).is_complex BigDecimal.new
      end.to raise_error ArgumentError
      expect { be_valid_when(:complex_field).is_complex 'value' }.to raise_error ArgumentError
      expect { be_valid_when(:complex_field).is_complex '42' }.to raise_error ArgumentError
      expect { be_valid_when(:complex_field).is_complex(/^value$/) }.to raise_error ArgumentError
      expect { be_valid_when(:complex_field).is_complex [1, 2] }.to raise_error ArgumentError
      expect { be_valid_when(:complex_field).is_complex({}) }.to raise_error ArgumentError
      expect { be_valid_when(:complex_field).is_complex :value }.to raise_error ArgumentError
    end
  end
end
