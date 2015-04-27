module VCloudSdk
  module Xml

    class NetworkConfig < Wrapper
      def ip_scope
        get_nodes("IpScope").first
      end

      def network_name
        @root["networkName"]
      end

      def parent_network
        get_nodes("ParentNetwork").first
      end

      def fence_mode
        get_nodes("FenceMode").first.content
      end

      def fence_mode=(value)
        get_nodes("FenceMode").first.content = value
      end

      def id
        get_nodes("Link").first.href[/.{8}-.{4}-.{4}-.{4}-.{12}/]
      end

      def link
        link = get_nodes("Link").first
        return unless link
        link.href[/https.*.{8}-.{4}-.{4}-.{4}-.{12}/]
      end
    end

  end
end
