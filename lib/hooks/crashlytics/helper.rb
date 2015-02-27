module Idobata::Hook
  class Crashlytics
    module Helper
      def label_class_from_impact_level(impact_level)
        if impact_level && impact_level >= 5
          'label-important'
        elsif impact_level == 4
          'label-warning'
        elsif impact_level == 3
          'label-success'
        elsif impact_level == 2
          'label-info'
        else
          'label-inverse'
        end
      end
    end
  end
end
