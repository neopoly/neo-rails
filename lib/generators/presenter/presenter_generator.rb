require 'rails/generators'

class PresenterGenerator < Rails::Generators::NamedBase

  source_root File.expand_path('../templates', __FILE__)

  def create_presenter_file
    path = "app/presenters/#{file_name}_presenter.rb"
    if FileTest.exists?path
      raise FileExistError, "This filename ist used by another presenter:#{path}"
    end

    copy_file "presenter_template.rb", path
    replace_class_name path
    replace_singular_name path
  end

  def create_presenter_test_file
    path = "test/presenters/#{file_name}_presenter_test.rb"
    if FileTest.exists?path
      raise FileExistError, "This filename ist used by another PresenterTest:#{path}"
    end

    copy_file "presenter_test_template.rb", path
    replace_class_name path
  end

  private 
  def replace_class_name path
    gsub_file path, '-classname-' , "#{class_name}"
  end

  def replace_singular_name path
    gsub_file path, 'singular_name' , "#{plural_name.singularize}"
  end
  
end

class FileExistError < StandardError; end