module VCloudSdk
  module Xml
    class FirewallRule < Wrapper
      def to_hash
        {
          id: get_nodes(:Id).first.content,
          enabled: is_enabled?,
          port: get_nodes(:Port).first.content,
          destination_port_group: get_nodes(:DestinationPortRange).first.content,
          destination_ip: get_nodes(:DestinationIp).first.content,
          source_port: get_nodes(:SourcePort).first.content,
          source_port_range: get_nodes(:SourcePortRange).first.content,
          source_ip: get_nodes(:SourceIp).first.content,
          enable_logging: get_nodes(:EnableLogging).first.content
        }
      end

      def is_enabled?
        get_nodes(:IsEnabled).first.content == "true"
      end
    end
  end
end