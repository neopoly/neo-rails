module Neo
  module Rails
    module Presenter
      def self.included(base)
        base.class_eval do
          def view_context
            Neo::Rails::Presenter.view_context
          end
        end
      end

      class << self
        def view_context
          Thread.current[:neo_rails_presenter_view_context]
        end

        def view_context=(view_context)
          Thread.current[:neo_rails_presenter_view_context] = view_context
        end
      end
    end
  end
end
