require 'test_helper'

class LaCarte::Builder::CacheDataTest < LaCarte::TestCase
  def teardown
    super
    @instance = nil
  end

  def test_cache_for_processed_data
    config.add_source_path :menu, sources_dir.join('empty_menu.yml')

    LaCarte::Builder::Processor.stub :process, [:fake, :value] do
      assert_equal [:fake, :value], instance.build(:menu)
    end

    LaCarte::Builder::Processor.stub :process, [:other, :fake, :value] do
      assert_equal [:fake, :value], instance.build(:menu)
    end
  end

  def test_cache_for_processed_data_when_forcing_reload
    config.add_source_path :menu, sources_dir.join('empty_menu.yml')

    LaCarte::Builder::Processor.stub :process, [:fake, :value] do
      assert_equal [:fake, :value], instance.build(:menu)
    end

    LaCarte::Builder::Processor.stub :process, [:other, :fake, :value] do
      assert_equal [:other, :fake, :value], instance.build(:menu, force_reload: true)
    end
  end

  private

  def instance
    @instance ||= LaCarte::Builder.send(:new)
  end
end
