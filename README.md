# rspec-be_valid_when_matcher

RSpec matcher for testing ActiveRecord models with a fluent and clear language.

## Install

First, add to your `Gemfile` (preferably in the `:test` group):

```ruby
gem 'rspec-be_valid_when_matcher'
```

Then, include `RSpec::BeValidWhenMatcher` in RSpec configuration:

```ruby
RSpec.configure do |config|
  config.include RSpec::BeValidWhenMatcher
end
```

Or, directly in your model spec(s):

```ruby
describe MyModel do
  include RSpec::BeValidWhenMatcher

  subject { build(:my_model) }

  describe '#header' do
    it { is_expected.not_to be_valid_when :header, nil }
  end
end
```

## MIT Licensed

See [LICENSE](https://github.com/mtuchowski/rspec-be_valid_when_matcher/blob/master/LICENSE) file
for full license text.
