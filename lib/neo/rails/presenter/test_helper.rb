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

          attr_accessor :output_buffer, :params, :controller

          # Configure sprockets-rails
          if defined?(VIEW_ACCESSORS) # sprockets-rails version >= 3.0
            app = ::Rails.application
            assets_config = app.config.assets

            self.debug_assets               = assets_config.debug
            self.digest_assets              = assets_config.digest
            self.assets_prefix              = assets_config.prefix
            self.assets_precompile          = assets_config.precompile
            self.assets_environment         = app.assets
            self.assets_manifest            = app.assets_manifest
            self.resolve_assets_with        = assets_config.resolve_with
            self.check_precompiled_asset    = assets_config.check_precompiled_asset
            self.precompiled_asset_checker  = -> logical_path { app.asset_precompiled? logical_path }

            if self.respond_to?(:unknown_asset_fallback=) # sprockets-rails version >= 3.2
              self.unknown_asset_fallback = assets_config.unknown_asset_fallback
            end
          end
        end
      end
    end
  end
end
