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

      def service_configuration
        get_nodes(:Configuration).first
          .get_nodes(:EdgeGatewayServiceConfiguration).first
      end

      def firewall_service
        service_configuration.get_nodes(:FirewallService).first
      end

      def firewall_rules
        firewall_service.get_nodes(:FirewallRule)
      end

      def configure_services_link
        get_nodes(XML_TYPE[:LINK],
          { rel: "edgeGateway:configureServices" },
          true).first
      end

      # Services configuration

      def add_firewall_rule(params)
        section = firewall_service

        firewall_rule = add_child("FirewallRule", nil, nil, section.node)

        add_child("IsEnabled", nil, nil, firewall_rule).content            = params[:is_enabled]
        add_child("Description", nil, nil, firewall_rule).content          = params[:description]
        add_child("Policy", nil, nil, firewall_rule).content               = params[:policy]
        add_child("DestinationPortRange", nil, nil, firewall_rule).content = params[:destination_port_range]
        add_child("DestinationIp", nil, nil, firewall_rule).content        = params[:destination_ip]
        add_child("SourcePortRange", nil, nil, firewall_rule).content      = params[:source_port_range]
        add_child("SourceIp", nil, nil, firewall_rule).content             = params[:source_ip]
        add_child("EnableLogging", nil, nil, firewall_rule).content        = params[:enable_logging]

        protocols_node = add_child("Protocols", nil, nil, firewall_rule)
        generate_protocols(params[:protocols], protocols_node)
      end

      def generate_protocols(protocols, node)
        protocols.each do |protocol|
          add_child(protocol.capitalize, nil, nil, node).content = "true"
        end
      end
    end
  end
end
