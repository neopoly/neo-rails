module Neo
  module Rails
    module Scenarios
      module RailsHelper
        def scenario_link(scenario)
          link_to scenario.label, url_for(:controller => scenario.controller, :action => scenario.action, :scenario => scenario.name, :id => 1), scenario.options
        end

        def render_scenarios_list
          if ::Rails.env.development? && respond_to?(:scenarios) && scenarios.preloaded.any?
            scenario_links = scenarios.map { |scenario| content_tag(:li, scenario_link(scenario)) }
            ul = content_tag(:ul, scenario_links.join.html_safe)
            raw content_tag(:div, ul, :class => "neo-rails-scenarios-list")
          end
        end
      end
    end
  end
end
