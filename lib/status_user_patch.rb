module Plugin
  module Status
    module User
      def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do
          has_one :status_notification
        end
      end

      module InstanceMethods
        def realtime_status_notification?
          (self.status_notification && self.status_notification.option == 'realtime') ? true : false
        end
      end
    end
  end
end
