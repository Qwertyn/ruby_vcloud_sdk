module VCloudSdk
  module Xml
    class FirewallRule < Wrapper
      PROTOCOLS = [:Tcp, :Udp, :Icmp, :Any].freeze

      def to_hash
        {
          enabled: is_enabled?,
          description: get_nodes(:Description).first.content,
          policy: get_nodes(:Policy).first.content,
          protocols: protocols,
          port: get_nodes(:Port).first.content,
          destination_ip: get_nodes(:DestinationIp).first.content,
          source_port: get_nodes(:SourcePort).first.content,
          source_ip: get_nodes(:SourceIp).first.content,
          enable_logging: get_nodes(:EnableLogging).first.content
        }
      end

      def is_enabled?
        get_nodes(:IsEnabled).first.content == "true"
      end

      def protocols
        protocols = []
        PROTOCOLS.each do |protocol|
          protocols.push(protocol.downcase) unless get_nodes(protocol).empty?
        end
        protocols
      end
    end
  end
end
