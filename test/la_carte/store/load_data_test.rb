require 'test_helper'

class LaCarte::Store::LoadDataTest < LaCarte::TestCase
  def test_load_a_correct_yaml_file
    config.add_source_path :correct, datas_dir.join('correct.yml').to_s

    assert_equal store[:correct], { 'data' => { 'foo' => 'bar' } }
  end

  def test_load_a_correct_rb_file
    config.add_source_path :correct, datas_dir.join('other_correct.rb').to_s

    assert_equal store[:correct], { data: { foo: 'bar' } }
  end

  def test_load_files_only_necessary
    config.add_source_path :correct, datas_dir.join('correct.yml').to_s
    config.add_source_path :other_correct, datas_dir.join('other_correct.rb').to_s

    refute_includes stored_data.keys, :correct
    refute_includes stored_data.keys, :other_correct

    store[:correct]

    assert_includes stored_data.keys, :correct
    refute_includes stored_data.keys, :other_correct
  end

  def test_reload_store_data
    config.add_source_path :correct, datas_dir.join('correct.yml').to_s
    config.add_source_path :other_correct, datas_dir.join('other_correct.rb').to_s

    store[:other_correct]
    refute_includes stored_data.keys, :correct
    assert_includes stored_data.keys, :other_correct

    store.reload!

    store[:correct]
    assert_includes stored_data.keys, :correct
    refute_includes stored_data.keys, :other_correct
  end

  def test_raise_an_exception_when_load_unknown_source_path
    assert_raises LaCarte::UnknownSourcePathException do
      store[:file]
    end
  end

  def test_load_a_file_with_wrong_sintax
    config.add_source_path :file, datas_dir.join('wrong_sintax.yml')

    assert_raises LaCarte::InvalidSintaxDataException do
      store[:file]
    end
  end

  def test_load_a_file_with_empty_value
    config.add_source_path :file, datas_dir.join('empty.rb')

    assert_raises LaCarte::InvalidSintaxDataException do
      store[:file]
    end
  end
end
