module Neo
  module Rails
    module Presenter
      module TestHelper
        def setup
          Presenter.view_context = FakeViewContext.instance
        end
        module_function :setup

        class FakeViewContext
          include Singleton
          include ActionView::Helpers::TagHelper
          include ActionView::Helpers::UrlHelper
          include ActionView::Helpers::TranslationHelper
          include ActionView::Helpers::NumberHelper
          begin
            include Sprockets::Rails::Helper
          rescue NameError
            include Sprockets::Helpers::RailsHelper
            include Sprockets::Helpers::IsolatedHelper
          end
          include ::Rails.application.routes.url_helpers

          attr_accessor :output_buffer
        end
      end
    end
  end
end
