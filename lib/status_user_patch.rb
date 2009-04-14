module Plugin
  module Status
    module User
      def self.included(base)
        base.class_eval do
          has_one :status_notification
        end
      end
    end
  end
end
