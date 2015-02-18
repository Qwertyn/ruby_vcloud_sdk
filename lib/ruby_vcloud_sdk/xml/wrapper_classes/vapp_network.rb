module VCloudSdk
  module Xml
    class VAppNetwork < Network
      def type
        "VAppNetwork"
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
