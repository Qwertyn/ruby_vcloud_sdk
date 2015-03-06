require "forwardable"
require_relative "infrastructure"
require_relative "ip_ranges"

module VCloudSdk
  class EdgeGateway
    include Infrastructure

    extend Forwardable
    def_delegators :entity_xml, :name, :href_id, :vdc_link

    def initialize(session, link)
      @session = session
      @link = link
    end

    def to_hash
      { name: name,
        href_id: href_id,
        vdc_href_id: vdc_href_id }
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
  end
end
