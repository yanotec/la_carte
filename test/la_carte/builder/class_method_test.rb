require 'test_helper'

class LaCarte::Builder::ClassMethodTest < LaCarte::TestCase
  def test_check_new_method_private
    assert_private_method LaCarte::Builder, :new
  end

  def test_check_instance_method_private
    assert_private_method LaCarte::Builder, :instance
  end

  def test_build_return_a_hash_config
    config.add_source_path :menu, sources_dir.join("empty_menu.yml")
    assert_equal LaCarte::Builder.build(:menu), []
  end
end
