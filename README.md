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

## Basic usage

Here's an example using rspec-be_valid_when_matcher:

```ruby
RSpec.describe Person do
  subject { Person.new }

  it { is_expected.to be_valid_when :name, 'Frank', 'string' }
  it { is_expected.to be_valid_when :age, 42, 'number' }
  it { is_expected.not_to be_valid_when :age, -1, 'negative' }
end
```

The `:name` and `:age` are names of fields belonging to `Person` instance. If the matcher will fail,
say for negative number check, it'll display the following message:

```console
Failures:

  1) Person should not be valid when #age is negative (-1)
     Failure/Error: it { is_expected.not_to be_valid_when :age, -1, 'negative' }
```

## MIT Licensed

See [LICENSE](https://github.com/mtuchowski/rspec-be_valid_when_matcher/blob/master/LICENSE) file
for full license text.
