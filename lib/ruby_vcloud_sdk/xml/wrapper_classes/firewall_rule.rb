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
          protocols << protocol unless get_nodes(protocol).empty?
        end
        protocols
      end

      def is_enabled=(value)
        get_nodes(:IsEnabled).first.content = value
      end

      def description=(desc)
        get_nodes(:Description).first.content = desc
      end

      def policy=(value)
        get_nodes(:Policy).first.content = value
      end

      def protocols=(value)
        raise "NotImplemented"
      end

      def destination_ip=(value)
        get_nodes(:DestinationIp).first.content = value
      end

      def source_ip=(value)
        get_nodes(:SourceIp).first.content = value
      end

      def enable_logging=(value)
        get_nodes(:EnableLogging).first.content = value
      end
    end
  end
end
