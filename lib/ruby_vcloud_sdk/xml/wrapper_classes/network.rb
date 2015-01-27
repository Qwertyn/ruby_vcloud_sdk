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

      def id
        @root["href"][/.{8}-.{4}-.{4}-.{4}-.{12}/]
      end
    end

  end
end
