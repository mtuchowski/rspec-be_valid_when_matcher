describe 'be_valid_when#is_regexp' do
  context 'with one argument' do
    it 'should fail if passed non regexp' do
      expect { be_valid_when(:regexp_field).is_regexp 42 }.to raise_error ArgumentError
      expect { be_valid_when(:regexp_field).is_regexp 42**42 }.to raise_error ArgumentError
      expect { be_valid_when(:regexp_field).is_regexp 3.14 }.to raise_error ArgumentError
      expect { be_valid_when(:regexp_field).is_regexp 42.to_c }.to raise_error ArgumentError
      expect { be_valid_when(:regexp_field).is_regexp 42.to_r }.to raise_error ArgumentError
      expect { be_valid_when(:regexp_field).is_regexp 'value' }.to raise_error ArgumentError
      expect { be_valid_when(:regexp_field).is_regexp '42' }.to raise_error ArgumentError
      expect { be_valid_when(:regexp_field).is_regexp [1, 2] }.to raise_error ArgumentError
      expect { be_valid_when(:regexp_field).is_regexp({}) }.to raise_error ArgumentError
      expect { be_valid_when(:regexp_field).is_regexp :value }.to raise_error ArgumentError
    end
  end
end
