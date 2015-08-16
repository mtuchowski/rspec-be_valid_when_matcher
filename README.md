# rspec-be_valid_when_matcher

[![Gem Version](https://badge.fury.io/rb/rspec-be_valid_when_matcher.svg)]
(http://badge.fury.io/rb/rspec-be_valid_when_matcher)
[![Build Status](https://travis-ci.org/mtuchowski/rspec-be_valid_when_matcher.svg)]
(https://travis-ci.org/mtuchowski/rspec-be_valid_when_matcher)

RSpec matcher for testing ActiveRecord models with a fluent and clear language.

```ruby
expect(person).to be_valid_when(:age).is_number
```

The matcher will check only the specified field for validation errors, so if there's one buggy
validator the whole model spec suite won't go red.

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

Here's an example using `be_valid_when` matcher:

```ruby
require 'active_model'

class Person
  include ActiveModel::Validations

  attr_accessor :name
  attr_accessor :age

  validates_presence_of :name
  validates_numericality_of :age, greater_than: 0
end

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

## Built-in checks

In addition to standard matcher declaration interface and the `#is` method, there is also a number
of helper methods to test common cases.

### Presence

Test field validity with the `nil` value:

```ruby
be_valid_when(:field).is_not_present
```

### Type

Test field validity with specific type values (all methods accept field value argument):

```ruby
be_valid_when(:field).is_number     # Defaults to 42
be_valid_when(:field).is_fixnum     # Defaults to 42
be_valid_when(:field).is_bignum     # Defaults to 42**13
be_valid_when(:field).is_float      # Defaults to 3.14
be_valid_when(:field).is_complex    # Defaults to 42+0i
be_valid_when(:field).is_rational   # Defaults to 42/1
be_valid_when(:field).is_bigdecimal # Defaults to 0.42E2
```

## MIT Licensed

See [LICENSE](https://github.com/mtuchowski/rspec-be_valid_when_matcher/blob/master/LICENSE) file
for full license text.
