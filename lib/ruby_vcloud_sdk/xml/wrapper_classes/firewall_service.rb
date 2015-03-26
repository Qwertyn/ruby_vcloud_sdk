module VCloudSdk
  module Xml
    class FirewallService < Wrapper
      def to_hash
        {
          enabled: get_nodes(:IsEnabled).first.content.to_bool,
          default_action: get_nodes(:DefaultAction).first.content,
          log_default_action: get_nodes(:LogDefaultAction).first.content.to_bool
        }
      end

      def is_enabled=(value)
        get_nodes[:IsEnabled].first.content = value
      end

      def default_action=(value)
        get_nodes[:DefaultAction].first.content = value
      end

      def log_default_action=(value)
        get_nodes[:LogDefaultAction].first.content = value
      end
    end
  end
end
