module Idobata::Hook
  class Crashlytics
    module Helper
      def label_class_from_impact_level(impact_level)
        if impact_level && impact_level >= 5
          'label-danger'
        elsif impact_level == 4
          'label-warning'
        elsif impact_level == 3
          'label-info'
        elsif impact_level == 2
          'label-success'
        else
          'label-default'
        end
      end
    end
  end
end
