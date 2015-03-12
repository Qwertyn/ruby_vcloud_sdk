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
    end
  end
end
