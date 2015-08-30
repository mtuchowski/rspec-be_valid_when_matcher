# Conventionally, all specs live under a `spec` directory, which RSpec adds to the `$LOAD_PATH`.
# The generated `.rspec` file contains `--require spec_helper` which will cause this file to always
# be loaded, without a need to explicitly require it in any files.
#
# Given that it is always loaded, keep this file as light-weight as possible. Requiring heavyweight
# dependencies from this file will add to the boot time of test suite on EVERY test run, even for
# an individual file that may not need all of that loaded. Instead, consider making a separate
# helper file that requires the additional dependencies and performs the additional setup,
# and require it from the spec files that actually need it.
#
# The `.rspec` file also contains a few flags that are not defaults but that are commonly wanted.
#
# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration

# Setup Code Climate test reporter.
require 'codeclimate-test-reporter'

CodeClimate::TestReporter.start

# Allow using 'be_valid_when' everywhere.
require 'rspec/be_valid_when_matcher'

RSpec.configure do |config|
  config.include RSpec::BeValidWhenMatcher

  # rspec-expectations config goes here.
  config.expect_with :rspec do |expectations|
    # This option will default to `true` in RSpec 4. It makes the `description` and
    # `failure_message` of custom matchers include text for helper methods defined using
    # `chain`, e.g.:
    #     be_bigger_than(2).and_smaller_than(4).description
    #     # => "be bigger than 2 and smaller than 4"
    # ...rather than:
    #     # => "be bigger than 2"
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true

    # Only allow expect syntax.
    expectations.syntax = :expect
  end

  # rspec-mocks config goes here.
  config.mock_with :rspec do |mocks|
    # Prevents from mocking or stubbing a method that does not exist on a real object.
    # This is generally recommended, and will default to `true` in RSpec 4.
    mocks.verify_partial_doubles = true
  end

  # Allows RSpec to persist some state between runs in order to support the `--only-failures` and
  # `--next-failure` CLI options. Source control system should be configured to ignore this file.
  config.example_status_persistence_file_path = 'spec/examples.cache'

  # Run specs in random order to surface order dependencies. To debug an order dependency after
  # finding one, fix the order by providing the seed, which is printed after each run.
  #     --seed 1234
  config.order = :random

  # Seed global randomization in this process using the `--seed` CLI option. Setting this allows
  # to use `--seed` to deterministically reproduce test failures related to randomization
  # by passing the same `--seed` value as the one that triggered the failure.
  Kernel.srand config.seed
end
