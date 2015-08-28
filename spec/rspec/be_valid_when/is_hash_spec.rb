describe 'be_valid_when#is_hash' do
  context 'with one argument' do
    it 'should fail if passed non hash' do
      expect { be_valid_when(:hash_field).is_hash 42 }.to raise_error ArgumentError
      expect { be_valid_when(:hash_field).is_hash 42**42 }.to raise_error ArgumentError
      expect { be_valid_when(:hash_field).is_hash 3.14 }.to raise_error ArgumentError
      expect { be_valid_when(:hash_field).is_hash 42.to_c }.to raise_error ArgumentError
      expect { be_valid_when(:hash_field).is_hash 42.to_r }.to raise_error ArgumentError
      expect { be_valid_when(:hash_field).is_hash 'value' }.to raise_error ArgumentError
      expect { be_valid_when(:hash_field).is_hash '42' }.to raise_error ArgumentError
      expect { be_valid_when(:hash_field).is_hash(/^value$/) }.to raise_error ArgumentError
      expect { be_valid_when(:hash_field).is_hash [1, 2] }.to raise_error ArgumentError
      expect { be_valid_when(:hash_field).is_hash :value }.to raise_error ArgumentError
    end
  end
end
