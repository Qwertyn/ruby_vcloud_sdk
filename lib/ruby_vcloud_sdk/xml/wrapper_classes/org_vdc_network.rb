module VCloudSdk
  module Xml
    class OrgVdcNetwork < Wrapper
      def ip_scope
        get_nodes(:IpScope).first
      end

      def allocated_addresses_link
        get_nodes(XML_TYPE[:LINK],
                  { type: MEDIA_TYPE[:ALLOCATED_NETWORK_IPS] },
                  true).first
      end

      def type
        "OrgNetwork"
      end

      def gateway
        get_nodes("Gateway").first
      end

      def netmask
        get_nodes("Netmask").first
      end

      def dns1
        get_nodes("Dns1").first
      end

      def dns2
        get_nodes("Dns2").first
      end
    end
  end
end
