module VCloudSdk
  module Xml
    class Network < Wrapper
      def ip_scope
        get_nodes(:IpScope).first
      end

      def name
        @root["name"]
      end

      def name=(value)
        @root["name"] = value
      end
    end
  end
end
