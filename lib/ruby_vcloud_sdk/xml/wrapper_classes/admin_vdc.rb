module VCloudSdk
  module Xml
    class AdminVdc < Wrapper
      def available_networks
        get_nodes("Network", type: ADMIN_MEDIA_TYPE[:ADMIN_NETWORK])
      end

      def vapps
        get_nodes(XML_TYPE[:RESOURCEENTITY], type: MEDIA_TYPE[:VAPP])
      end

      def edge_gateways_link
        get_nodes(XML_TYPE[:LINK],
                  rel: "edgeGateways")
          .first
      end

      def to_hash
        {
          href_id: href_id,
          name: name
        }
      end
    end
  end
end
