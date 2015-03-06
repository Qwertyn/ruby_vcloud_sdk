module VCloudSdk
  module Xml
    class EdgeGateway < Wrapper
      def gateway_interfaces
        get_nodes(:Configuration, nil, true)
          .first
          .get_nodes(:GatewayInterfaces, nil, true)
          .first
          .get_nodes(:GatewayInterface, nil, true)
      end


      def vdc_link
        get_nodes(XML_TYPE[:LINK], { type: ADMIN_MEDIA_TYPE[:ADMIN_VDC], rel: 'up' }).first
      end

      def description
        get_nodes("Description").first
      end
    end
  end
end
