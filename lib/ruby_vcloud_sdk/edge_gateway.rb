require "forwardable"
require_relative "infrastructure"
require_relative "ip_ranges"

module VCloudSdk
  class EdgeGateway
    STATUSES = {
      "0"  => "NOT_READY",
      "1"  => "READY",
      "-1" => "ERROR"
    }

    include Infrastructure

    extend Forwardable
    def_delegators :entity_xml, :name, :to_hash, :href_id, :vdc_link, :firewall_service, :firewall_rules

    def initialize(session, link)
      @session = session
      @link = link
    end

    def description
      entity_xml.description.content
    end

    def status
      STATUSES[entity_xml.status]
    end

    def vdc_href_id
      vdc_link.href_id
    end

    def public_ip_ranges
      uplink_gateway_interface = entity_xml
                                   .gateway_interfaces
                                   .find { |g| g.interface_type == "uplink" }

      ip_ranges = uplink_gateway_interface.ip_ranges
      return IpRanges.new unless ip_ranges

      ip_ranges
        .ranges
        .reduce(IpRanges.new) do |result, i|
          result + IpRanges.new("#{i.start_address}-#{i.end_address}")
        end
    end


    # @param [Hash] creation_params
    # For example:
    # creation_params =
    #   {
    #     is_enabled: true,
    #     description: "allow incomming ssh",
    #     policy: "allow",
    #     protocols: ["Tcp"],
    #     destination_port_range: "22",
    #     destination_ip: "Internal",
    #     source_port_range: "Any",
    #     source_ip: "External",
    #     enable_logging: false
    #   }
    def create_firewall_rule(creation_params)
      Config
        .logger
        .info "Creating firewall_rule"

      payload = entity_xml
      payload.add_firewall_rule(creation_params)

      task = connection.post(payload.configure_services_link.href,
        payload.service_configuration,
        Xml::MEDIA_TYPE[:EDGE_GATEWAY_SERVICE_CONFIGURATION])

      monitor_task(task)
      self
    end

    def delete_firewall_rule_by_id(id)
      payload = entity_xml
      unless payload.delete_firewall_rule?(id)
        fail ObjectNotFoundError, "Firewall rule with id '#{id}' is not found"
      end

      task = connection.post(payload.configure_services_link.href,
        payload.service_configuration,
        Xml::MEDIA_TYPE[:EDGE_GATEWAY_SERVICE_CONFIGURATION])

      monitor_task(task)
      self
    end

    # @param [Hash] params
    # For example:
    # params =
    #   {
    #     id: "1",
    #     is_enabled: true,
    #     description: "allow incomming ssh",
    #     policy: "allow",
    #     protocols: ["Tcp"],
    #     destination_port_range: "22",
    #     destination_ip: "Internal",
    #     source_port_range: "Any",
    #     source_ip: "External",
    #     enable_logging: false
    #   }
    def update_firewall_rule(params)
      payload = entity_xml
      firewall_rule = payload.find_firewall_rule(params[:id])

      payload.configure_firewall_rule(firewall_rule, params)

      task = connection.post(payload.configure_services_link.href,
        payload.service_configuration,
        Xml::MEDIA_TYPE[:EDGE_GATEWAY_SERVICE_CONFIGURATION])

      monitor_task(task)
      self
    end

    # in test regime
    def configure_services(services)
      payload = entity_xml

      task = connection.post(payload.configure_services_link.href,
        service_params(services),
        Xml::MEDIA_TYPE[:EDGE_GATEWAY_SERVICE_CONFIGURATION])

      monitor_task(task)
      self
    end

    # in test regime
    def service_params(params)
      configure_firewall_service(params[:firewall_service])
    end

    # in test regime
    def configure_firewall_service(params)
      firewall_service =  entity_xml.firewall_service
      firewall_service.is_enabled         = params[:is_enabled]
      firewall_service.default_action     = params[:default_action]
      firewall_service.log_default_action = params[:log_default_action]
      firewall_rules = entity_xml.firewall_rules
      firewall_rules.zip(params[:firewall_rules]).each do |firewall_rule, param|
        configure_firewall_rule(firewall_rule, param)
      end
    end

  end
end
