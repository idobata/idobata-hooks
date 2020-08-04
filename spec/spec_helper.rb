require 'rspec/its'
require 'rack'
require 'active_support/core_ext/string/strip'
require 'active_support/core_ext/hash/conversions'
require 'tapp'
require 'pry'

require 'idobata/hooks'

Dir[Idobata::Hook.root.join('../spec/support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.include HookHelper, type: :hook
end

Idobata::Hook.load!
