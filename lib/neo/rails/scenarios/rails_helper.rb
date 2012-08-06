module Neo
  module Rails
    module Scenarios
      module RailsHelper
        def scenario_link(scenario)
          link_to scenario.label, url_for(:action => scenario.action, :scenario => scenario.name, :id => 1), scenario.options
        end

        def render_scenarios_list
          if ::Rails.env.development? && respond_to?(:list_scenarios) && (list = list_scenarios).any?
            scenario_links = list.map { |scenario| content_tag(:li, scenario_link(scenario)) }
            ul = content_tag(:ul, scenario_links.join.html_safe)
            raw content_tag(:div, ul, :class => "neo-rails-scenarios-list")
          end
        end
      end
    end
  end
end
