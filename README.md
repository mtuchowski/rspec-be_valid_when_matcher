# rspec-be_valid_when_matcher

[![Gem Version](https://badge.fury.io/rb/rspec-be_valid_when_matcher.svg)]
(http://badge.fury.io/rb/rspec-be_valid_when_matcher)

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

  it { is_expected.to be_valid_when :name, 'Frank', 'some text' }
  it { is_expected.to be_valid_when :age, 42, 'positive number' }
  it { is_expected.not_to be_valid_when :age, -1, 'negative number' }
end
```

The `:name` and `:age` are names of fields belonging to `Person` instance. If the matcher will fail,
say for negative number check, it'll display the following message:

```console
Failures:

  1) Person should not be valid when #age is negative number (-1)
     Failure/Error: it { is_expected.not_to be_valid_when :age, -1, 'negative number' }
```

To keep the specs more readable `#is(value, message)` method can be used to separate `field`
from expected `value` and optional `message` declaration like so:

```ruby
RSpec.describe Person do
  subject { Person.new }

  it { is_expected.to be_valid_when(:name).is('Frank', 'some text') }
  it { is_expected.to be_valid_when(:age).is(42, 'positive number') }
  it { is_expected.not_to be_valid_when(:age).is(-1, 'negative number') }
end
```

### Built-in checks

#### Presence

Test field validity with the `nil` value:

```ruby
be_valid_when(:field).is_not_present     # Uses nil value
```

#### Type

Test field validity with specific type values:

```ruby
be_valid_when(:field).is_number 2          # Defaults to 42
be_valid_when(:field).is_fixnum 2          # Defaults to 42
be_valid_when(:field).is_bignum 1024**32   # Defaults to 42**13
be_valid_when(:field).is_float 0.1         # Defaults to 3.14
be_valid_when(:field).is_complex 2.to_c    # Defaults to 42+0i
```

## MIT Licensed

See [LICENSE](https://github.com/mtuchowski/rspec-be_valid_when_matcher/blob/master/LICENSE) file
for full license text.
