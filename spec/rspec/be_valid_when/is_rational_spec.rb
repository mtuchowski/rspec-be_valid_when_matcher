describe 'be_valid_when#is_rational' do
  context 'with one argument' do
    it 'should fail if passed non rational' do
      expect { be_valid_when(:rational_field).is_rational 42 }.to raise_error ArgumentError
      expect { be_valid_when(:rational_field).is_rational 42**42 }.to raise_error ArgumentError
      expect { be_valid_when(:rational_field).is_rational 3.14 }.to raise_error ArgumentError
      expect { be_valid_when(:rational_field).is_rational 42.to_c }.to raise_error ArgumentError
      expect do
        be_valid_when(:rational_field).is_rational BigDecimal.new
      end.to raise_error ArgumentError
      expect { be_valid_when(:rational_field).is_rational 'value' }.to raise_error ArgumentError
      expect { be_valid_when(:rational_field).is_rational '42' }.to raise_error ArgumentError
      expect { be_valid_when(:rational_field).is_rational(/^value$/) }.to raise_error ArgumentError
      expect { be_valid_when(:rational_field).is_rational [1, 2] }.to raise_error ArgumentError
      expect { be_valid_when(:rational_field).is_rational({}) }.to raise_error ArgumentError
      expect { be_valid_when(:rational_field).is_rational :value }.to raise_error ArgumentError
    end
  end
end
