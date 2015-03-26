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

      def firewall_service
        service_configuration
          .get_nodes(:FirewallService).first
      end

      def firewall_rules
        service_configuration
          .get_nodes(:FirewallService).first
          .get_nodes(:FirewallRule)
      end

      def service_configuration
        get_nodes(:Configuration).first
          .get_nodes(:EdgeGatewayServiceConfiguration).first
      end

      def configure_services_link
        get_nodes(XML_TYPE[:LINK],
          { rel: "edgeGateway:configureServices" },
          true).first
      end
    end
  end
end
