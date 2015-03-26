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
    def_delegators :entity_xml, :name, :href_id, :vdc_link, :firewall_service, :firewall_rules

    def initialize(session, link)
      @session = session
      @link = link
    end

    def to_hash
      { name: name,
        description: description,
        status: status,
        href_id: href_id,
        vdc_href_id: vdc_href_id }
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

    def configure_services(services)
      payload = entity_xml

      task = connection.post(payload.configure_services_link.href,
        service_params(services),
        Xml::MEDIA_TYPE[:EDGE_GATEWAY_SERVICE_CONFIGURATION])

      monitor_task(task)
      self
    end

    def service_params(params)
      configure_firewall_service(params[:firewall_service])
    end

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

    def configure_firewall_rule(rule, params)
      rule.is_enabled     = params[:is_enabled]
      rule.description    = params[:description]
      rule.policy         = params[:policy]
      rule.protocols      = params[:protocols]
      rule.destination_ip = params[:description_ip]
      rule.source_ip      = params[:source_ip]
      rule.enable_logging = params[:enable_logging]
    end
  end
end
