require 'rails/generators'

class PresenterGenerator < Rails::Generators::Base

  source_root File.expand_path('../templates', __FILE__)

  def create_file
    create_file "app/presenters/#{file_name}_helper.rb", <<-FILE
      class #{class_name}Presenter < Presenter

        def initialize(#{plural_name.singularize})
          @#{plural_name.singularize} = #{plural_name.singularize}
        end

      end
          FILE
  end
  
end