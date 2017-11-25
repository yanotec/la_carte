$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "la_carte"

require "minitest/autorun"

TEST_CASE = defined?(Minitest::Test) ? Minitest::Test : MiniTest::Unit::TestCase


class LaCarte::TestCase < TEST_CASE
  def setup
    super
  end

  def teardown
    super
    Thread.current.keys.each do |key|
      next if key.to_s !~ /\Ala_carte_/

      Thread.current[key] = nil
    end
  end

  private

  def assert_private_method(klass, method)
    assert_raises NoMethodError do
      klass.public_send(method)
    end
    assert_includes klass.private_methods, method
  end

  def store
    LaCarte::Store.store
  end

  def stored_data
    store.send(:stored_data)
  end

  def config
    LaCarte.config
  end

  def load_paths
    config.load_paths
  end

  def build_processors
    config.build_processors
  end

  def datas_dir
    Pathname.new(File.dirname(__FILE__)).join('fixtures', 'datas')
  end

  def sources_dir
    Pathname.new(File.dirname(__FILE__)).join('fixtures', 'sources')
  end
end
