require 'bundler'
Bundler.setup
Bundler.require(:default, :test)

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :fakeweb
  c.configure_rspec_metadata!
end

RSpec.configure do |config|
  config.mock_with :mocha

  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.filter_run_excluding :slow => true

  config.extend VCR::RSpec::Macros

  config.before :all do
    $redis = Redis.new({})
  end
  config.before :each do
    $redis.select 12
    $redis.flushdb
  end
end
