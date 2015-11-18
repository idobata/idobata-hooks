module Idobata::Hook
  class Coveralls
    module Helper
      def message_from_coverage_change(coverage_change)
        if coverage_change.to_f > 0.0
          render_as_haml(<<-HAML.strip_heredoc, coverage_change: two_places_of_float(coverage_change))
            coverage increased
            %span.badge.progress-bar-success= coverage_change
            to
          HAML
        elsif coverage_change.to_f < 0.0
          render_as_haml(<<-HAML.strip_heredoc, coverage_change: two_places_of_float(coverage_change))
            coverage decreased
            %span.badge.progress-bar-danger= coverage_change
            to
          HAML
        else
          'coverage remained the same at'
        end
      end

      def two_places_of_float(covered_percent)
        sprintf('%.2f', covered_percent.to_f)
      end

      def render_as_haml(haml, locals)
        Haml::Engine.new(haml, escape_html: true).render(self, locals)
      end
    end
  end
end
