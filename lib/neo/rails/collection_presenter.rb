module Neo
  module Rails
    module CollectionPresenter
      def self.included(base)
        base.extend(ClassMethods)

        base.class_eval do
          include Enumerable

          delegate :last, :size, :each, :to => :@presenters
        end
      end

      def initialize(presenters)
        @presenters = presenters
      end

      def get_by_index(index)
        @presenters[index]
      end

      def view_context
        Neo::Rails::Presenter.view_context
      end

      module ClassMethods
        def build(objects)
          presenters = objects.map do |object|
            presenter_class.new(object)
          end

          new(presenters)
        end

        private

        def presenter_class
          [module_namespace, presenter_class_name].join('::').constantize
        end

        def module_namespace
          name.deconstantize
        end

        def presenter_class_name
          name.demodulize.sub('Collection', '')
        end
      end
    end
  end
end
