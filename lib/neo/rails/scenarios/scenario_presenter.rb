module Neo
  module Rails
    module Scenarios
      class ScenarioPresenter
        include Neo::Rails::Presenter

        def initialize(scenario)
          @scenario = scenario
        end

        delegate :action, :name, :options, :to => :@scenario

        def label
          "#{action.to_s.humanize} &raquo; #{name.to_s.humanize}".html_safe
        end

        def link
          view_context.link_to label, view_context.url_for(:action => action, :scenario => name, :id => 1), options
        end
      end
    end
  end
end
